import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/env.dart';
import '../../shared/providers/dev_server_provider.dart';
import '../astro/astro_engine.dart';
import '../network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  // Watch devServerProvider so DioClient is rebuilt on server switch (dev/mock only)
  if (AppConfig.mode == AppMode.dev || AppConfig.mode == AppMode.mock) {
    ref.watch(devServerProvider);
  }
  return DioClient();
});

/// Overridden at app startup with the real SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Overridden at app startup with the initialized AstroEngine instance.
final astroEngineProvider = Provider<AstroEngine>((ref) {
  return AstroEngine(); // Not initialized — isAvailable will be false
});
