import 'package:dio/dio.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient({String? baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Install an interceptor that calls [onUnauthorized] on 401 responses.
  /// Returns true from [onUnauthorized] to retry the request with a new token.
  void addAuthInterceptor({
    required Future<bool> Function() onUnauthorized,
  }) {
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await onUnauthorized();
          if (refreshed) {
            // Retry the original request with updated token
            final opts = error.requestOptions;
            opts.headers['Authorization'] =
                _dio.options.headers['Authorization'];
            try {
              final response = await _dio.fetch(opts);
              return handler.resolve(response);
            } catch (e) {
              return handler.next(error);
            }
          }
        }
        return handler.next(error);
      },
    ));
  }
}
