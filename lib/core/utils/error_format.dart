import 'package:dio/dio.dart';
import '../../config/env.dart';

/// Format an error for user display, respecting the current AppMode.
///
/// - dev/mock: full error string (including stack trace info)
/// - test: error code + message (no stack trace)
/// - release: generic user-friendly message
String formatError(Object error) {
  final mode = AppConfig.mode;

  if (mode.showStackTrace) {
    return error.toString();
  }

  if (mode.showErrorDetail) {
    // test mode: show code + message but not full stack
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final err = data['error'];
        if (err is Map<String, dynamic>) {
          return err['message'] as String? ?? error.message ?? 'Unknown error';
        }
        if (err is String) return err;
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }

  // release mode: generic message
  return '操作失败，请重试';
}
