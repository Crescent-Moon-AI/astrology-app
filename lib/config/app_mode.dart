/// Application build mode — controls debug verbosity, error display, etc.
enum AppMode {
  /// Offline demo with mock interceptors. Most verbose.
  mock,

  /// Local development against dev backend. Verbose logging.
  dev,

  /// QA testing against test server. Moderate error detail.
  test,

  /// Production release. Minimal error info.
  release,
}

extension AppModeX on AppMode {
  /// Whether to show Flutter's debug banner.
  bool get showDebugBanner => this == AppMode.dev;

  /// Whether to show technical error details (code + message) to user.
  bool get showErrorDetail => this != AppMode.release;

  /// Whether to show full stack traces in error UI.
  bool get showStackTrace => this == AppMode.dev || this == AppMode.mock;

  /// Whether to add Dio LogInterceptor for request/response logging.
  bool get enableNetworkLog => this == AppMode.dev;
}
