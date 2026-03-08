import 'dart:io' show Platform;

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

  /// Default dev config: Android emulator uses 10.0.2.2 to reach host machine.
  /// iOS simulator and desktop can use localhost directly.
  static final dev = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000',
    wsBaseUrl: 'ws://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000',
  );

  /// Dev config for real device testing over WiFi.
  /// Set the host IP to your dev machine's LAN address.
  static const devDevice = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'http://192.168.50.101:3000',
    wsBaseUrl: 'ws://192.168.50.101:3000',
  );

  /// Dev server (ECS) — for release APK testing against dev environment.
  static const devServer = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'https://dev.astrology.net.cn',
    wsBaseUrl: 'wss://dev.astrology.net.cn',
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
}

/// Global app configuration. Must be initialized before runApp().
class AppConfig {
  static late EnvConfig _current;

  /// Initialize the config. Call once from main() before runApp().
  static void init(EnvConfig config) {
    _current = config;
  }

  static EnvConfig get current => _current;
  static String get apiBaseUrl => _current.apiBaseUrl;
  static String get wsBaseUrl => _current.wsBaseUrl;
  static Environment get environment => _current.env;
  static bool get isDev => _current.env == Environment.dev;
}
