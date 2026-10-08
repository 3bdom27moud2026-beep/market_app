import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/models/review_model.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ReviewItemModel', () {
    test('should parse correctly from json with user_id and user_name', () {
      final json = {
        'id': 101,
        'user_id': 55,
        'user_name': 'أحمد محمود',
        'rating': 4.5,
        'comment': 'منتج ممتاز جداً',
        'is_verified_buyer': true,
        'created_at': '2026-03-15',
      };

      final item = ReviewItemModel.fromJson(json);

      expect(item.id, equals(101));
      expect(item.userId, equals(55));
      expect(item.userName, equals('أحمد محمود'));
      expect(item.rating, equals(4.5));
      expect(item.comment, equals('منتج ممتاز جداً'));
      expect(item.isVerifiedBuyer, isTrue);
      expect(item.createdAt, equals('2026-03-15'));
    });

    test('should parse nested user object when present', () {
      final json = {
        'id': 102,
        'user': {'id': 77, 'name': 'سارة علي'},
        'rating': 5.0,
        'review': 'خدمة رائعة',
        'verified': true,
      };

      final item = ReviewItemModel.fromJson(json);

      expect(item.id, equals(102));
      expect(item.userId, equals(77));
      expect(item.userName, equals('سارة علي'));
      expect(item.comment, equals('خدمة رائعة'));
      expect(item.isVerifiedBuyer, isTrue);
    });
  });

  group('ReviewsResponseModel', () {
    test('should parse hasReviewed and canReview flags accurately', () {
      final jsonWithReview = {
        'status': true,
        'average_rating': 4.8,
        'review_count': 12,
        'has_reviewed': true,
        'can_review': false,
        'rating_breakdown': {'5': 10, '4': 2},
        'reviews': [
          {
            'id': 1,
            'user_id': 12,
            'user_name': 'محمد',
            'rating': 5,
            'comment': 'ممتاز',
          },
        ],
      };

      final model = ReviewsResponseModel.fromJson(jsonWithReview);

      expect(model.status, isTrue);
      expect(model.averageRating, equals(4.8));
      expect(model.reviewCount, equals(12));
      expect(model.hasReviewed, isTrue);
      expect(model.canReview, isFalse);
      expect(model.reviews.length, equals(1));
      expect(model.ratingBreakdown[5], equals(10));
    });

    test(
      'should default hasReviewed to false and canReview to true if absent',
      () {
        final jsonWithoutFlag = {
          'status': true,
          'average_rating': 4.0,
          'review_count': 0,
          'reviews': <dynamic>[],
        };

        final model = ReviewsResponseModel.fromJson(jsonWithoutFlag);

        expect(model.hasReviewed, isFalse);
        expect(model.canReview, isTrue);
        expect(model.reviews, isEmpty);
      },
    );

    test('should support nested data wrapper from backend API', () {
      final nestedJson = {
        'status': true,
        'data': {
          'average_rating': 4.2,
          'review_count': 3,
          'has_reviewed': true,
          'can_review': false,
          'reviews': [
            {'id': 10, 'user_name': 'عميل تجريبي', 'rating': 4.0},
          ],
        },
      };

      final model = ReviewsResponseModel.fromJson(nestedJson);

      expect(model.hasReviewed, isTrue);
      expect(model.canReview, isFalse);
      expect(model.averageRating, equals(4.2));
      expect(model.reviewCount, equals(3));
      expect(model.reviews.length, equals(1));
    });
  });

  group('CacheHelper Reviewed Endpoints', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await CacheHelper.init();
    });

    test('tracks and normalizes reviewed endpoints accurately', () async {
      const endpoint = '/v1/products/9/reviews';
      expect(CacheHelper.hasReviewedEndpoint(endpoint), isFalse);

      await CacheHelper.markEndpointAsReviewed(endpoint);
      expect(CacheHelper.hasReviewedEndpoint(endpoint), isTrue);

      // Trailing slash or casing normalization
      expect(
        CacheHelper.hasReviewedEndpoint('/v1/products/9/reviews/'),
        isTrue,
      );
      expect(CacheHelper.hasReviewedEndpoint('/V1/PRODUCTS/9/REVIEWS'), isTrue);
    });

    test('prevents duplicates in reviewedEndpoints list', () async {
      const endpoint = '/v1/merchants/3/reviews';
      await CacheHelper.markEndpointAsReviewed(endpoint);
      await CacheHelper.markEndpointAsReviewed(endpoint);
      await CacheHelper.markEndpointAsReviewed('$endpoint/');

      expect(CacheHelper.reviewedEndpoints.length, equals(1));
    });
  });
}
