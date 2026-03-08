import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logs provider state changes in dev/mock mode.
base class DebugProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    dev.log(
      '${context.provider.name ?? context.provider.runtimeType} changed',
      name: 'Riverpod',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    dev.log(
      '${context.provider.name ?? context.provider.runtimeType} threw $error',
      name: 'Riverpod',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
