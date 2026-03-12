import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/env.dart';
import 'core/astro/astro_engine.dart';
import 'core/utils/debug_observer.dart';
import 'core/providers/core_providers.dart';
import 'main.dart';

/// Dev entry point — connects to dev server (dev.astrology.net.cn).
///
/// Build with:
///   flutter run -t lib/main_dev.dart
///   flutter build apk -t lib/main_dev.dart --release
///
/// For local backend, use --dart-define:
///   flutter run -t lib/main_dev.dart --dart-define=API_HOST=lan
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiHost = String.fromEnvironment('API_HOST');
  final env = switch (apiHost) {
    'local' => EnvConfig.local,
    'local-https' => EnvConfig.localHttps,
    'lan' => EnvConfig.lan,
    _ => EnvConfig.dev,
  };
  AppConfig.init(env, mode: AppMode.dev);

  final astroEngine = AstroEngine();
  await astroEngine.init();

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      observers: [if (AppConfig.mode.showStackTrace) DebugProviderObserver()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        astroEngineProvider.overrideWithValue(astroEngine),
      ],
      child: const XingjianApp(),
    ),
  );
}
