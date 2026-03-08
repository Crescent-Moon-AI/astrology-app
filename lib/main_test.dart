import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/env.dart';
import 'core/astro/astro_engine.dart';
import 'core/providers/core_providers.dart';
import 'main.dart';

/// Test entry point — connects to test server (ECS).
///
/// Moderate error detail (code + message, no stack trace).
/// Forces Chinese locale.
///
/// Build with:
///   flutter build apk -t lib/main_test.dart --release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(EnvConfig.testServer, mode: AppMode.test);

  final astroEngine = AstroEngine();
  await astroEngine.init();

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        astroEngineProvider.overrideWithValue(astroEngine),
      ],
      child: const XingjianApp(),
    ),
  );
}
