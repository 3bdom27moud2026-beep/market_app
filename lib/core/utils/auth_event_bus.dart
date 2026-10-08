import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';

/// Types of authentication events.
enum AuthEventType {
  /// Emitted when a user successfully logs in or registers.
  loggedIn,

  /// Emitted when a user logs out or the session expires.
  loggedOut,

  /// Emitted when profile data is modified.
  profileUpdated,
}

/// Authentication event payload.
class AuthEvent {
  final AuthEventType type;
  final UserEntity? user;

  const AuthEvent(this.type, [this.user]);
}

/// Global event bus for broadcasting authentication changes across all screens.
class AuthEventBus {
  AuthEventBus._();

  static final AuthEventBus instance = AuthEventBus._();

  final StreamController<AuthEvent> _controller =
      StreamController<AuthEvent>.broadcast();

  /// Stream of authentication events.
  Stream<AuthEvent> get stream => _controller.stream;

  /// Notify all active screens and cubits that a user has logged in.
  void notifyLoggedIn([UserEntity? user]) {
    debugPrint('[AuthEventBus] notifyLoggedIn: broadcasting to all screens');
    _controller.add(AuthEvent(AuthEventType.loggedIn, user));
  }

  /// Notify all active screens and cubits that a user has logged out.
  void notifyLoggedOut() {
    debugPrint('[AuthEventBus] notifyLoggedOut: broadcasting to all screens');
    _controller.add(const AuthEvent(AuthEventType.loggedOut));
  }

  /// Notify all active screens and cubits that profile information was updated.
  void notifyProfileUpdated() {
    debugPrint('[AuthEventBus] notifyProfileUpdated');
    _controller.add(const AuthEvent(AuthEventType.profileUpdated));
  }
}
