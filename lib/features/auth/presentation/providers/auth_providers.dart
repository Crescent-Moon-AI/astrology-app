import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../settings/presentation/providers/profile_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/auth_response.dart';
import '../../domain/models/user.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final authDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDatasource(dioClient.dio);
});

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({this.status = AuthStatus.unknown, this.user, this.error});

  bool get needsOnboarding => user?.needsOnboarding ?? false;

  AuthState copyWith({AuthStatus? status, User? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRemoteDatasource _datasource;
  late final SecureStorage _storage;
  late final DioClient _dioClient;

  @override
  AuthState build() {
    _datasource = ref.watch(authDatasourceProvider);
    _storage = ref.watch(secureStorageProvider);
    _dioClient = ref.watch(dioClientProvider);
    // Install 401 interceptor on every new DioClient (idempotent via guard).
    _dioClient.addAuthInterceptor(onUnauthorized: () => tryRefresh());
    return const AuthState();
  }

  Future<void> checkAuth() async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _dioClient.setAuthToken(token);
      try {
        final json = await _datasource.getMe();
        final user = User.fromJson(json);
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } catch (_) {
        final refreshed = await tryRefresh();
        if (!refreshed) {
          state = const AuthState(status: AuthStatus.unauthenticated);
        }
      }
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  /// Send SMS OTP. Returns (cooldown seconds, error message).
  Future<(int?, String?)> sendSMSOTP(String phone) async {
    try {
      final cooldown = await _datasource.sendSMSOTP(phone);
      return (cooldown, null);
    } on DioException catch (e) {
      return (null, _extractError(e));
    }
  }

  /// Verify phone + OTP. Auto-registers if new user.
  Future<bool> smsVerify(String phone, String code) async {
    try {
      final response = await _datasource.smsVerify(phone: phone, code: code);
      await _saveAuth(response);
      return true;
    } on DioException catch (e) {
      final msg = _extractError(e);
      state = state.copyWith(status: AuthStatus.unauthenticated, error: msg);
      return false;
    }
  }

  /// Re-fetch user profile from server and update state.
  Future<void> refreshUser() async {
    try {
      final json = await _datasource.getMe();
      final user = User.fromJson(json);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      // Ignore — keep current state
    }
  }

  Future<void> logout() async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      try {
        await _datasource.logout(token);
      } catch (_) {}
    }
    _dioClient.clearAuthToken();
    await _storage.clearTokens();
    ref.invalidate(userProfileProvider);
    ref.invalidate(dailyFortuneProvider);
    ref.invalidate(selectedDateProvider);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> tryRefresh() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await _datasource.refresh(refreshToken);
      await _saveAuth(response);
      return true;
    } catch (_) {
      await logout();
      return false;
    }
  }

  Future<void> _saveAuth(AuthResponse response) async {
    await _storage.setAccessToken(response.accessToken);
    await _storage.setRefreshToken(response.refreshToken);
    _dioClient.setAuthToken(response.accessToken);
    ref.invalidate(userProfileProvider);
    ref.invalidate(dailyFortuneProvider);
    ref.invalidate(selectedDateProvider);
    state = AuthState(status: AuthStatus.authenticated, user: response.user);
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return error['message'] as String? ?? 'Unknown error';
      }
      if (error is String) return error;
    }
    return e.message ?? 'Network error';
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
