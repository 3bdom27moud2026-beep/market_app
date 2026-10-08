import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/services/fcm_service.dart';

void main() {
  group('FCMService Route Resolution Tests', () {
    test('resolves explicit route when provided', () {
      final data = {'route': '/custom/page'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, '/custom/page');
    });

    test('resolves order notification route', () {
      final data = {'type': 'order_shipped', 'reference_id': '999'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.orders);
    });

    test('resolves order notification route with order_id directly', () {
      final data = {'order_id': '450'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.orders);
    });

    test('resolves flash sale notification route', () {
      final data = {'type': 'flash_sale_alert'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.flashSale);
    });

    test('resolves promotional offer notification route', () {
      final data = {'type': 'special_offer'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.home);
    });

    test('resolves discount card notification route', () {
      final data = {'type': 'discount_card_approved'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.discountCard);
    });

    test('resolves merchant details route with reference_id', () {
      final data = {'type': 'merchant_new_item', 'reference_id': '45'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, '/merchant-details/45');
    });

    test('resolves merchant details route with merchant_id', () {
      final data = {'type': 'merchant', 'merchant_id': '88'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, '/merchant-details/88');
    });

    test('resolves general merchants route without reference_id', () {
      final data = {'type': 'merchant_updates'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.merchants);
    });

    test('resolves product details route with reference_id', () {
      final data = {'type': 'product_price_drop', 'reference_id': '108'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, '/product-details/108');
    });

    test('resolves product details route with product_id', () {
      final data = {'product_id': '205'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, '/product-details/205');
    });

    test('resolves category products route with reference_id', () {
      final data = {'type': 'category_deals', 'reference_id': '7'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, '/category-products/7');
    });

    test('resolves category products route with category_id', () {
      final data = {'type': 'category', 'category_id': '15'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, '/category-products/15');
    });

    test('resolves abandoned cart route to basket', () {
      final data = {'type': 'abandoned_cart'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.basket);
    });

    test('resolves screen name without slash to proper route', () {
      expect(
        FCMService.resolveRouteFromData({'screen': 'orders'}),
        AppRoutes.orders,
      );
      expect(
        FCMService.resolveRouteFromData({'screen': 'notifications'}),
        AppRoutes.notifications,
      );
      expect(
        FCMService.resolveRouteFromData({'screen': 'cart'}),
        AppRoutes.basket,
      );
      expect(
        FCMService.resolveRouteFromData({'screen': 'favorites'}),
        AppRoutes.favorites,
      );
      expect(
        FCMService.resolveRouteFromData({'screen': 'profile'}),
        AppRoutes.profile,
      );
    });

    test('unpacks nested JSON string payload seamlessly', () {
      final data = {'payload': '{"route": "/orders", "order_id": "789"}'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.orders);
    });

    test('falls back to notifications route for unknown type', () {
      final data = {'type': 'system_announcement'};
      final route = FCMService.resolveRouteFromData(data);
      expect(route, AppRoutes.notifications);
    });

    test('handles pending route lifecycle correctly', () {
      FCMService.pendingRoute = AppRoutes.orders;
      expect(FCMService.consumePendingRoute(), AppRoutes.orders);
      expect(FCMService.consumePendingRoute(), isNull);
    });

    test('logNotification runs without throwing errors', () {
      expect(
        () => FCMService.logNotification(
          source: 'TEST_SUITE',
          data: {'route': '/orders', 'order_id': '123'},
          title: 'Test Notification',
          body: 'Test Body',
        ),
        returnsNormally,
      );
    });
  });
}
