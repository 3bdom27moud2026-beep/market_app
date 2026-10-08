import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/favorites/domain/entities/favorite_entity.dart';

void main() {
  group('FavoriteMerchantEntity Tests', () {
    test('parses favorite merchant from nested merchant json correctly', () {
      final json = {
        'id': 1,
        'merchant': {
          'id': 12,
          'name': 'البرنس ماركت',
          'image': 'https://shopguide.medguide.software/merchants/12.png',
          'category': {'name': 'سوبر ماركت'},
          'rating': 4.9,
          'discount': '15%',
        },
      };

      final entity = FavoriteMerchantEntity.fromJson(json);

      expect(entity.id, 12);
      expect(entity.name, 'البرنس ماركت');
      expect(
        entity.image,
        'https://shopguide.medguide.software/merchants/12.png',
      );
      expect(entity.category, 'سوبر ماركت');
      expect(entity.rating, 4.9);
      expect(entity.discount, '15%');
    });

    test('parses favorite merchant from flat json fallback', () {
      final json = {
        'id': 25,
        'name': 'صيدلية النور',
        'logo': 'https://shopguide.medguide.software/merchants/25.png',
        'category_name': 'صيدليات',
        'rating': 4.7,
        'discount': '10%',
      };

      final entity = FavoriteMerchantEntity.fromJson(json);

      expect(entity.id, 25);
      expect(entity.name, 'صيدلية النور');
      expect(
        entity.image,
        'https://shopguide.medguide.software/merchants/25.png',
      );
      expect(entity.category, 'صيدليات');
      expect(entity.rating, 4.7);
      expect(entity.discount, '10%');
    });
  });
}
