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

  Future<AuthResponse> register({
    required String email,
    required String password,
    String? username,
    String? inviteCode,
  }) async {
    final body = <String, dynamic>{
      'email': email,
      'password': password,
    };
    if (username != null && username.isNotEmpty) body['username'] = username;
    if (inviteCode != null && inviteCode.isNotEmpty) {
      body['invite_code'] = inviteCode;
    }
    final response = await _dio.post('/api/auth/register', data: body);
    return _parseAuth(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _dio.post('/api/auth/login', data: {
      'identifier': identifier,
      'password': password,
    });
    return _parseAuth(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final response = await _dio.post('/api/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    return _parseAuth(response.data as Map<String, dynamic>);
  }

  Future<void> logout(String accessToken) async {
    await _dio.post(
      '/api/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
