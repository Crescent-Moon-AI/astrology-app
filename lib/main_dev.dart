import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/env.dart';
import 'core/providers/core_providers.dart';
import 'main.dart';

/// Entry point for real device testing over WiFi.
///
/// Uses the dev machine's LAN IP so that a physical device on the same
/// network can reach the backend.
/// Forces Chinese locale for testing.
/// Auto-logs in with test credentials.
///
/// Run with:
///   flutter run -t lib/main_dev.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(EnvConfig.devDevice);
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const YuejianApp(
        forceLocale: Locale('zh'),
        autoLoginEmail: 'testzhui@test.com',
        autoLoginPassword: 'Test12345678',
      ),
    ),
  );
}
