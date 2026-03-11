import 'package:dio/dio.dart';
import '../models/auth_response.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  /// Parse auth response — handles both `{data: {...}}` envelope and flat response.
  AuthResponse _parseAuth(Map<String, dynamic> json) {
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      return AuthResponse.fromJson(json['data'] as Map<String, dynamic>);
    }
    return AuthResponse.fromJson(json);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await _dio.post(
      '/api/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return _parseAuth(response.data as Map<String, dynamic>);
  }

  Future<void> logout(String accessToken) async {
    await _dio.post(
      '/api/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// Fetch current user profile using stored auth token.
  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/api/auth/me');
    final data = response.data as Map<String, dynamic>;
    if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
      return data['data'] as Map<String, dynamic>;
    }
    return data;
  }

  /// Send SMS OTP to the given phone number. Returns cooldown seconds from server.
  Future<int> sendSMSOTP(String phone) async {
    final response = await _dio.post(
      '/api/auth/sms/send',
      data: {'phone': phone},
    );
    final data = response.data as Map<String, dynamic>;
    return (data['cooldown'] as num?)?.toInt() ?? 60;
  }

  /// Verify phone + OTP. Auto-registers if new user.
  Future<AuthResponse> smsVerify({
    required String phone,
    required String code,
  }) async {
    final response = await _dio.post(
      '/api/auth/sms/verify',
      data: {'phone': phone, 'code': code},
    );
    return _parseAuth(response.data as Map<String, dynamic>);
  }

  /// Update user profile.
  Future<void> updateProfile(Map<String, dynamic> body) async {
    await _dio.patch('/api/auth/me', data: body);
  }
}
