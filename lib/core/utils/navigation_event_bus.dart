import 'dart:async';

/// Global event bus for navigating between tabs in MainShell.
class NavigationEventBus {
  NavigationEventBus._();

  static final NavigationEventBus instance = NavigationEventBus._();

  final StreamController<int> _controller = StreamController<int>.broadcast();

  /// Stream of tab index switch requests.
  Stream<int> get stream => _controller.stream;

  /// Request switching to tab index [index].
  /// 0: Home (الرئيسية)
  /// 1: Categories (الأقسام)
  /// 2: Profile (الحساب)
  /// 3: Favorites (المفضلة)
  /// 4: Cart (السلة)
  void switchTab(int index) {
    _controller.add(index);
  }
}

