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

  static const dev = EnvConfig(
    env: Environment.dev,
    apiBaseUrl: 'http://localhost:8080',
    wsBaseUrl: 'ws://localhost:8080',
  );

  static const staging = EnvConfig(
    env: Environment.staging,
    apiBaseUrl: 'https://staging-api.yuejian.app',
    wsBaseUrl: 'wss://staging-api.yuejian.app',
  );

  static const prod = EnvConfig(
    env: Environment.prod,
    apiBaseUrl: 'https://api.yuejian.app',
    wsBaseUrl: 'wss://api.yuejian.app',
  );
}
