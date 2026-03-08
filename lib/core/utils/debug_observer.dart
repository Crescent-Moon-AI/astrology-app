import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logs provider state changes in dev/mock mode.
class DebugProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    dev.log(
      '${provider.name ?? provider.runtimeType} changed',
      name: 'Riverpod',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    dev.log(
      '${provider.name ?? provider.runtimeType} threw $error',
      name: 'Riverpod',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
