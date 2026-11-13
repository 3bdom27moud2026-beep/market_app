import 'dart:async';
import 'package:flutter/foundation.dart';

/// Global event bus for broadcasting favorite toggle events across all screens.
/// When a product is added/removed from favorites anywhere in the app,
/// this bus notifies [FavoritesCubit] to reload its list.
class FavoritesEventBus {
  FavoritesEventBus._();

  static final FavoritesEventBus instance = FavoritesEventBus._();

  final StreamController<FavoriteChangedEvent> _controller =
      StreamController<FavoriteChangedEvent>.broadcast();

  /// Stream of favorite change notifications.
  Stream<FavoriteChangedEvent> get stream => _controller.stream;

  /// Notify all listeners that a product's favorite status changed.
  void notifyFavoriteChanged({
    required String productId,
    required bool isAdded,
  }) {
    debugPrint(
      '[FavoritesEventBus] favorite changed: productId=$productId isAdded=$isAdded',
    );
    _controller.add(FavoriteChangedEvent(productId: productId, isAdded: isAdded));
  }
}

class FavoriteChangedEvent {
  final String productId;
  final bool isAdded;

  const FavoriteChangedEvent({
    required this.productId,
    required this.isAdded,
  });
}

