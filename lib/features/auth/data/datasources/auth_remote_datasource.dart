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

  /// Send SMS OTP to the given phone number.
  Future<void> sendSMSOTP(String phone) async {
    await _dio.post('/api/auth/sms/send', data: {'phone': phone});
  }

  /// Register with phone number + OTP.
  Future<AuthResponse> smsRegister({
    required String phone,
    required String code,
    String? username,
    String? inviteCode,
  }) async {
    final body = <String, dynamic>{'phone': phone, 'code': code};
    if (username != null && username.isNotEmpty) body['username'] = username;
    if (inviteCode != null && inviteCode.isNotEmpty) {
      body['invite_code'] = inviteCode;
    }
    final response = await _dio.post('/api/auth/sms/register', data: body);
    return _parseAuth(response.data as Map<String, dynamic>);
  }

  /// Login with phone number + OTP.
  Future<AuthResponse> smsLogin({
    required String phone,
    required String code,
  }) async {
    final response = await _dio.post(
      '/api/auth/sms/login',
      data: {'phone': phone, 'code': code},
    );
    return _parseAuth(response.data as Map<String, dynamic>);
  }
}
