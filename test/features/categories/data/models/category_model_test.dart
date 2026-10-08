import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/categories/data/models/category_model.dart';

void main() {
  group('CategoryModel.fromJson', () {
    test('parses stores_count when provided as int', () {
      final json = {
        'id': 1,
        'name': 'مطاعم',
        'icon': 'utensils',
        'stores_count': 12,
      };

      final model = CategoryModel.fromJson(json);
      expect(model.id, '1');
      expect(model.name, 'مطاعم');
      expect(model.storesCount, 12);
    });

    test('parses alternative keys merchants_count and shops_count', () {
      final json1 = {'id': 2, 'name': 'كافيهات', 'merchants_count': 7};
      final model1 = CategoryModel.fromJson(json1);
      expect(model1.storesCount, 7);

      final json2 = {'id': 3, 'name': 'أزياء', 'shops_count': '15'};
      final model2 = CategoryModel.fromJson(json2);
      expect(model2.storesCount, 15);
    });

    test('parses nested merchants or stores list length', () {
      final json = {
        'id': 4,
        'name': 'إلكترونيات',
        'merchants': [
          {'id': 1},
          {'id': 2},
          {'id': 3},
        ],
      };

      final model = CategoryModel.fromJson(json);
      expect(model.storesCount, 3);
    });

    test('defaults storesCount to 0 when no count keys present', () {
      final json = {'id': 5, 'name': 'صيدليات'};

      final model = CategoryModel.fromJson(json);
      expect(model.storesCount, 0);
    });

    test('parses image/icon_url as icon fallback', () {
      final json = {
        'id': 6,
        'name': 'صحة',
        'image': 'https://example.com/health.png',
      };

      final model = CategoryModel.fromJson(json);
      expect(model.icon, 'https://example.com/health.png');
    });
  });
}
