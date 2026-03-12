import 'dart:io' show Platform;

import 'app_mode.dart';
export 'app_mode.dart';

enum Environment { dev, staging, prod }

class EnvConfig {
  final Environment env;
  final String apiBaseUrl;
  final String wsBaseUrl;

  const EnvConfig({
    required this.env,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
  });

  /// Dev server (ECS) — default for dev mode.
  static const dev = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'https://dev.astrology.net.cn',
    wsBaseUrl: 'wss://dev.astrology.net.cn',
  );

  /// Local backend via emulator loopback or localhost (HTTP, port 3000).
  /// Use with: flutter run --dart-define=API_HOST=local
  static final local = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000',
    wsBaseUrl: 'ws://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000',
  );

  /// Local backend via emulator loopback — HTTPS (Docker nginx on port 443).
  /// Use with: flutter run --dart-define=API_HOST=local-https
  static final localHttps = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'https://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}',
    wsBaseUrl: 'wss://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}',
  );

  /// Local backend via LAN IP for real device WiFi testing.
  /// Use with: flutter run --dart-define=API_HOST=lan
  static const lan = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'http://192.168.50.101:3000',
    wsBaseUrl: 'ws://192.168.50.101:3000',
  );

  /// Test server (ECS) — for release APK testing against test environment.
  static const testServer = EnvConfig(
    env: Environment.staging,
    apiBaseUrl: 'https://test.astrology.net.cn',
    wsBaseUrl: 'wss://test.astrology.net.cn',
  );

  static const staging = EnvConfig(
    env: Environment.staging,
    apiBaseUrl: 'https://staging-api.xingjian.app',
    wsBaseUrl: 'wss://staging-api.xingjian.app',
  );

  static const prod = EnvConfig(
    env: Environment.prod,
    apiBaseUrl: 'https://api.xingjian.app',
    wsBaseUrl: 'wss://api.xingjian.app',
  );

  /// Create EnvConfig from an arbitrary API URL.
  /// Derives wsBaseUrl by replacing http→ws / https→wss.
  factory EnvConfig.custom(String apiUrl) {
    final wsUrl = apiUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    return EnvConfig(
      env: Environment.dev,
      apiBaseUrl: apiUrl,
      wsBaseUrl: wsUrl,
    );
  }
}

/// Global app configuration. Must be initialized before runApp().
class AppConfig {
  static late EnvConfig _current;
  static late EnvConfig _initial;
  static AppMode _mode = AppMode.release;

  /// Initialize the config. Call once from main() before runApp().
  static void init(EnvConfig config, {AppMode mode = AppMode.release}) {
    _current = config;
    _initial = config;
    _mode = mode;
  }

  /// Update the environment config at runtime without changing mode.
  /// Used by the dev server switcher.
  static void updateEnv(EnvConfig config) {
    _current = config;
  }

  static EnvConfig get current => _current;
  static EnvConfig get initial => _initial;
  static AppMode get mode => _mode;
  static String get apiBaseUrl => _current.apiBaseUrl;
  static String get wsBaseUrl => _current.wsBaseUrl;
  static Environment get environment => _current.env;
  static bool get isDev => _current.env == Environment.dev;
}
