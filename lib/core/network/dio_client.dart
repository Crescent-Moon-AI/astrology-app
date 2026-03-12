import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import '../../config/env.dart';
import 'api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient({String? baseUrl}) {
    final resolvedBase = baseUrl ?? ApiConstants.baseUrl;
    _dio = Dio(
      BaseOptions(
        baseUrl: resolvedBase,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // In dev mode connecting to a local HTTPS backend (self-signed cert),
    // use the standard IOHttpClientAdapter with SSL verification disabled.
    // For all other cases, use the platform-native adapter (TLS 1.3, DPI bypass).
    final isLocalHttps =
        AppConfig.isDev &&
        (resolvedBase.startsWith('https://10.0.2.2') ||
            resolvedBase.startsWith('https://localhost'));
    if (isLocalHttps) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
    } else {
      // Use platform-native HTTP client for proper TLS 1.3 support.
      // Dart's built-in BoringSSL may use TLS 1.2 which can be blocked by DPI.
      _dio.httpClientAdapter = NativeAdapter();
    }

    // Log requests/responses in dev mode for easier debugging.
    if (AppConfig.mode.enableNetworkLog) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  Dio get dio => _dio;

  /// Update the base URL at runtime (e.g. dev server switch).
  void updateBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Install an interceptor that calls [onUnauthorized] on 401 responses.
  /// Returns true from [onUnauthorized] to retry the request with a new token.
  /// Safe to call multiple times — only installs once per DioClient instance.
  bool _hasAuthInterceptor = false;
  void addAuthInterceptor({required Future<bool> Function() onUnauthorized}) {
    if (_hasAuthInterceptor) return;
    _hasAuthInterceptor = true;
    _dio.interceptors.add(
      InterceptorsWrapper(
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
      ),
    );
  }
}
