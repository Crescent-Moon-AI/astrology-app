import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/secure_storage.dart';
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

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
  });

  AuthState copyWith({AuthStatus? status, User? user, String? error}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRemoteDatasource _datasource;
  final SecureStorage _storage;
  final DioClient _dioClient;

  AuthNotifier(this._datasource, this._storage, this._dioClient)
      : super(const AuthState());

  Future<void> checkAuth() async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _dioClient.setAuthToken(token);
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String identifier, String password) async {
    try {
      final response = await _datasource.login(
        identifier: identifier,
        password: password,
      );
      await _saveAuth(response);
      return true;
    } on DioException catch (e) {
      final msg = _extractError(e);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: msg,
      );
      return false;
    }
  }

  Future<bool> register(
    String email,
    String password, {
    String? username,
    String? inviteCode,
  }) async {
    try {
      final response = await _datasource.register(
        email: email,
        password: password,
        username: username,
        inviteCode: inviteCode,
      );
      await _saveAuth(response);
      return true;
    } on DioException catch (e) {
      final msg = _extractError(e);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: msg,
      );
      return false;
    }
  }

  Future<void> logout() async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      try {
        await _datasource.logout(token);
      } catch (_) {
        // Best-effort logout
      }
    }
    _dioClient.clearAuthToken();
    await _storage.clearTokens();
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
    state = AuthState(
      status: AuthStatus.authenticated,
      user: response.user,
    );
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

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final datasource = ref.watch(authDatasourceProvider);
  final storage = ref.watch(secureStorageProvider);
  final dioClient = ref.watch(dioClientProvider);
  return AuthNotifier(datasource, storage, dioClient);
});
