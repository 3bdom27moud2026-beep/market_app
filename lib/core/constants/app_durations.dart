/// Centralized duration constants for animations, delays, etc.
/// Do NOT hardcode durations; use this class instead.
abstract final class AppDurations {
  /// Duration for the splash screen before navigating away.
  static const Duration splashAutoNavigate = Duration(milliseconds: 2200);

  /// Duration for each fade/scale animation step.
  static const Duration animationStep = Duration(milliseconds: 400);
}
