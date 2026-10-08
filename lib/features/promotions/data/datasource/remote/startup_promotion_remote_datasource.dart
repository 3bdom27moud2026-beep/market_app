import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import '../../models/startup_promotion_model.dart';

/// Remote data source for startup promotion.
class StartupPromotionRemoteDataSource {
  final ApiClient apiClient;

  const StartupPromotionRemoteDataSource({required this.apiClient});

  /// Fetches the startup promotion from the API with fallback mechanisms.
  Future<StartupPromotionModel?> getStartupPromotion() async {
    // 1. Fetch best offer / featured ad from the home endpoint
    try {
      final response = await apiClient.get(EndPoints.home);
      if (response.data != null) {
        final rawData = response.data;
        Map<String, dynamic> payload = {};
        if (rawData is Map<String, dynamic>) {
          payload = rawData['data'] is Map<String, dynamic>
              ? rawData['data'] as Map<String, dynamic>
              : rawData;
        }

        // Check for featured_ad first
        if (payload['featured_ad'] is Map<String, dynamic>) {
          return StartupPromotionModel.fromJson(
            payload['featured_ad'] as Map<String, dynamic>,
          );
        }

        // If no featured_ad, look for best discounted product in flash_sales or products
        final List<dynamic>? products =
            (payload['flash_sales'] as List<dynamic>?) ??
            (payload['discount_products'] as List<dynamic>?) ??
            (payload['products'] as List<dynamic>?) ??
            (payload['best_sellers'] as List<dynamic>?);

        if (products != null && products.isNotEmpty) {
          Map<String, dynamic>? bestProduct;
          double maxSavings = 0;

          for (final item in products) {
            if (item is Map<String, dynamic>) {
              final double p =
                  (item['member_price'] as num?)?.toDouble() ??
                  (item['display_price'] as num?)?.toDouble() ??
                  (item['price'] as num?)?.toDouble() ??
                  0.0;
              final double op =
                  (item['original_price'] as num?)?.toDouble() ??
                  (item['oldPrice'] as num?)?.toDouble() ??
                  (item['old_price'] as num?)?.toDouble() ??
                  p;
              final savings = op - p;
              if (savings >= maxSavings) {
                maxSavings = savings;
                bestProduct = item;
              }
            }
          }

          if (bestProduct != null) {
            return StartupPromotionModel.fromJson(bestProduct);
          }
        }
      }
    } catch (_) {
      // Proceed to default best offer fallback
    }

    // 3. Guaranteed best offer fallback so dialog always appears seamlessly
    return const StartupPromotionModel(
      id: '3',
      title: 'وجبة برجر دبل تشيز',
      store: 'برجر كينج',
      brand: 'برجر كينج',
      merchantName: 'مطعم الشيف',
      image:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400',
      price: 99.0,
      oldPrice: 200.0,
      discount: 51,
      rating: 4.7,
      reviews: 310,
      description: 'عرض حصري لفترة محدودة!',
      stockMessage: 'اطلب الآن — الكمية محدودة والتوصيل سريع',
      buttonText: 'تسوق الآن',
      specialOffer: 'عرض خاص',
    );
  }
}
