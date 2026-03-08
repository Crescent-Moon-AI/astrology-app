import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/env.dart';
import 'core/astro/astro_engine.dart';
import 'core/providers/core_providers.dart';
import 'main.dart';

/// Production release entry point.
///
/// Minimal error info. No auto-login. No forced locale.
/// Currently points to testServer; switch to prod when ready.
///
/// Build with:
///   flutter build apk -t lib/main_release.dart --release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: switch to EnvConfig.prod when production is ready
  AppConfig.init(EnvConfig.testServer, mode: AppMode.release);

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
