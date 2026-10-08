import 'dart:async';
import 'package:flutter/foundation.dart';

/// Global event bus for broadcasting cart changes (items added, removed, updated) across all screens.
class CartEventBus {
  CartEventBus._();

  static final CartEventBus instance = CartEventBus._();

  final StreamController<void> _controller =
      StreamController<void>.broadcast();

  /// Stream of cart update notifications.
  Stream<void> get stream => _controller.stream;

  /// Notify all active screens and cubits that the cart has been updated.
  void notifyCartUpdated() {
    debugPrint('[CartEventBus] notifyCartUpdated: broadcasting to all screens');
    _controller.add(null);
  }
}
