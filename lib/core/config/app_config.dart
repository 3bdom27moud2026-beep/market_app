/// Environment flavor definition.
enum AppFlavor {
  /// Development environment for local testing and debugging.
  dev,

  /// Production environment for public release.
  prod,
}

/// Global configuration class holding flavor-specific settings.
class AppConfig {
  /// Active flavor.
  final AppFlavor flavor;

  /// Human-readable application name.
  final String appName;

  /// Base URL for the backend API.
  final String apiBaseUrl;

  /// Whether verbose network and system logging is enabled.
  final bool enableLogging;

  static AppConfig? _instance;

  /// Current active [AppConfig]. Throws an assertion error if not initialized.
  static AppConfig get current {
    _instance ??= const AppConfig(
      flavor: AppFlavor.prod,
      appName: 'Shop Guide',
      apiBaseUrl: 'https://shopguide.medguide.software/api',
      enableLogging: false,
    );
    return _instance!;
  }

  /// Whether the configuration has been initialized.
  static bool get isInitialized => _instance != null;

  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    this.enableLogging = false,
  });

  /// Set the active application configuration.
  static void initialize(AppConfig config) {
    _instance = config;
  }

  /// Whether the active environment is Development.
  bool get isDev => flavor == AppFlavor.dev;

  /// Whether the active environment is Production.
  bool get isProd => flavor == AppFlavor.prod;
}
