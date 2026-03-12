import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../astro/astro_engine.dart';
import '../network/dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
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
