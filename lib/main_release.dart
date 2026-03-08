import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/env.dart';
import 'core/astro/astro_engine.dart';
import 'core/providers/core_providers.dart';
import 'main.dart';

/// Entry point for release APK targeting dev server (ECS).
///
/// Connects to https://dev.astrology.net.cn
/// Forces Chinese locale for testing.
/// Auto-logs in with test credentials.
///
/// Build with:
///   flutter build apk -t lib/main_release.dart --release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(EnvConfig.devServer);

  final astroEngine = AstroEngine();
  await astroEngine.init();

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        astroEngineProvider.overrideWithValue(astroEngine),
      ],
      child: const XingjianApp(
        forceLocale: Locale('zh'),
        autoLoginEmail: 'testzhui@test.com',
        autoLoginPassword: 'Test12345678',
      ),
    ),
  );
}
