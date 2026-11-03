import 'core/config/app_config.dart';
import 'main.dart';

/// Entry point for the Development environment.
///
/// Run with:
/// ```bash
/// flutter run --flavor dev -t lib/main_dev.dart
/// ```
void main() async {
  await bootstrap(
    const AppConfig(
      flavor: AppFlavor.dev,
      appName: 'Shop Guide Dev',
      apiBaseUrl: 'https://shopguide.medguide.software/api',
      enableLogging: true,
    ),
  );
}
