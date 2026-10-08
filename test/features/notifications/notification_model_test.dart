import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/features/notifications/data/models/notification_model.dart';

void main() {
  group('NotificationItemModel Tests', () {
    test('parses order notification correctly with route resolution', () {
      final json = {
        'id': '101',
        'title': 'تم شحن طلبك!',
        'body': 'طلبك رقم #1024 في طريقه إليك مع شركة الشحن.',
        'type': 'order_status',
        'reference_id': '1024',
        'read_at': null,
        'created_at': 'منذ 15 دقيقة',
      };

      final model = NotificationItemModel.fromJson(json);

      expect(model.id, '101');
      expect(model.title, 'تم شحن طلبك!');
      expect(model.body, 'طلبك رقم #1024 في طريقه إليك مع شركة الشحن.');
      expect(model.type, 'order_status');
      expect(model.referenceId, '1024');
      expect(model.isRead, false);
      expect(model.createdAt, 'منذ 15 دقيقة');
      expect(model.actionRoute, AppRoutes.orders);
    });

    test('parses card and points notifications correctly', () {
      final cardJson = {
        'id': 202,
        'title': 'تم تفعيل كارت الخصم',
        'body': 'تمت الموافقة على طلب كارت الخصم الخاص بك.',
        'type': 'card_approved',
        'is_read': true,
        'created_at': 'منذ ساعتين',
      };

      final cardModel = NotificationItemModel.fromJson(cardJson);
      expect(cardModel.id, '202');
      expect(cardModel.isRead, true);
      expect(cardModel.actionRoute, AppRoutes.discountCard);

      final pointsJson = {
        'id': 303,
        'title': 'نقاط مكافأة جديدة',
        'message': 'حصلت على 50 نقطة جديدة من مشترياتك!',
        'type': 'loyalty_points',
        'read': false,
        'created_at': 'منذ يوم',
      };

      final pointsModel = NotificationItemModel.fromJson(pointsJson);
      expect(pointsModel.id, '303');
      expect(pointsModel.body, 'حصلت على 50 نقطة جديدة من مشترياتك!');
      expect(pointsModel.isRead, false);
      expect(pointsModel.actionRoute, AppRoutes.profile);
    });

    test('parses merchant notification route with referenceId', () {
      final json = {
        'id': '404',
        'title': 'عرض جديد من التاجر',
        'body': 'خصم 20% لدى فرع وسط البلد',
        'type': 'merchant_offer',
        'reference_id': '42',
        'read_at': '2026-03-01T10:00:00Z',
        'created_at': 'منذ يومين',
      };

      final model = NotificationItemModel.fromJson(json);
      expect(model.id, '404');
      expect(model.isRead, true);
      expect(model.actionRoute, '/merchant-details/42');
    });

    test('copyWith updates isRead and unread state cleanly', () {
      const model = NotificationItemModel(
        id: '1',
        title: 'Title',
        body: 'Body',
        type: 'general',
        isRead: false,
        createdAt: 'Now',
      );

      final updated = model.copyWith(isRead: true);
      expect(updated.isRead, true);
      expect(updated.title, 'Title');
    });
  });
}
