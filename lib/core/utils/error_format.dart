import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:astrology_app/l10n/app_localizations.dart';

/// Classify an error into a user-facing category.
enum ErrorKind { timeout, network, server, unknown }

/// Determine the [ErrorKind] for the given error.
ErrorKind classifyError(Object error) {
  if (error is TimeoutException) return ErrorKind.timeout;

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorKind.timeout;
      case DioExceptionType.connectionError:
        return ErrorKind.network;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        if (statusCode >= 500) return ErrorKind.server;
        return ErrorKind.unknown;
      default:
        return ErrorKind.unknown;
    }
  }

  if (error is SocketException) return ErrorKind.network;

  return ErrorKind.unknown;
}

/// Format an error into a user-friendly localized message.
///
/// When [l10n] is available, returns a concise localized string.
/// Falls back to the raw error string for unknown errors.
String formatError(Object error, [AppLocalizations? l10n]) {
  if (l10n != null) {
    switch (classifyError(error)) {
      case ErrorKind.timeout:
        return l10n.errorTimeout;
      case ErrorKind.network:
        return l10n.errorNetwork;
      case ErrorKind.server:
        return l10n.errorServer;
      case ErrorKind.unknown:
        break;
    }
  }

  // Fallback: technical detail (useful for dev/debug builds)
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
