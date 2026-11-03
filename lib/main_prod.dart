import 'core/config/app_config.dart';
import 'main.dart';

/// Entry point for the Production environment.
///
/// Run with:
/// ```bash
/// flutter run --flavor prod -t lib/main_prod.dart
/// ```
void main() async {
  await bootstrap(
    const AppConfig(
      flavor: AppFlavor.prod,
      appName: 'Shop Guide',
      apiBaseUrl: 'https://shopguide.medguide.software/api',
      enableLogging: false,
    ),
  );
}
