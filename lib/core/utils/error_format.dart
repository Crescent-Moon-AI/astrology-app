import 'package:dio/dio.dart';

/// Format an error for user display, respecting the current AppMode.
///
/// - dev/mock: full error string (including stack trace info)
/// - test: error code + message (no stack trace)
/// - release: generic user-friendly message
String formatError(Object error) {
  // TODO(debug): temporary — show full error detail in all modes for diagnosis.
  // Revert this function after confirming the root cause.
  if (error is DioException) {
    final buf = StringBuffer();
    buf.write('[${error.type.name}]');
    if (error.message != null) buf.write(' ${error.message}');
    if (error.error != null) buf.write('\ncause: ${error.error}');
    final uri = error.requestOptions.uri;
    buf.write('\nurl: $uri');
    if (error.response != null) {
      buf.write('\nstatus: ${error.response?.statusCode}');
      final data = error.response?.data;
      if (data != null) buf.write('\nbody: $data');
    }
    return buf.toString();
  }
  return error.toString();
}
