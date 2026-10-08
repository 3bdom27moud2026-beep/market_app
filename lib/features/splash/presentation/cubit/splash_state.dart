import 'package:equatable/equatable.dart';

/// Splash screen state.
abstract final class SplashState extends Equatable {
  const SplashState();
}

/// Initial splash state — app is still loading.
final class SplashInitial extends SplashState {
  const SplashInitial();

  @override
  List<Object?> get props => [];
}

/// App initialization completed — ready to navigate.
final class SplashReady extends SplashState {
  const SplashReady();

  @override
  List<Object?> get props => [];
}

/// An error occurred during initialization.
final class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
