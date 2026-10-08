import 'package:equatable/equatable.dart';
import 'offer_banner_model.dart';
import 'flash_sale_product_model.dart';
import 'category_model.dart';
import 'best_seller_model.dart';
import 'partner_model.dart';
import 'newest_product_model.dart';
import 'featured_ad_model.dart';
import '../../domain/entities/home_data_entity.dart';

/// Aggregate data model for the entire home screen JSON response.
class HomeDataModel extends Equatable {
  final List<OfferBannerModel> offers;
  final List<FlashSaleProductModel> flashSale;
  final List<CategoryModel> categories;
  final List<BestSellerModel> bestSellers;
  final List<PartnerModel> partners;
  final List<NewestProductModel> newestProducts;
  final FeaturedAdModel? featuredAd;

  /// Whether the current user is a member (has a discount card).
  final bool isMember;

  const HomeDataModel({
    required this.offers,
    required this.flashSale,
    required this.categories,
    required this.bestSellers,
    required this.partners,
    required this.newestProducts,
    this.featuredAd,
    this.isMember = false,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    final bool isMember = json['is_member'] == true;

    final featuredAdJson = json['featured_ad'] is Map<String, dynamic>
        ? json['featured_ad'] as Map<String, dynamic>
        : null;
    final featuredAd = featuredAdJson != null
        ? FeaturedAdModel.fromJson(featuredAdJson)
        : null;

    // New API uses 'sliders', old API uses 'offers' — support both
    final List<dynamic>? rawSliders =
        (json['sliders'] as List<dynamic>?) ??
        (json['offers'] as List<dynamic>?);

    final offersList =
        rawSliders
            ?.map((e) => OfferBannerModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // If sliders list is empty but featured_ad exists, map featured_ad to offers for UI banner display
    if (offersList.isEmpty && featuredAd != null) {
      offersList.add(
        OfferBannerModel(
          id: featuredAd.id,
          title: featuredAd.headline.isNotEmpty
              ? featuredAd.headline
              : featuredAd.name,
          subtitle: featuredAd.tagline.isNotEmpty
              ? featuredAd.tagline
              : featuredAd.brand,
          image: featuredAd.image,
          buttonText: 'احصل على العرض',
          discount: featuredAd.oldPrice != null && featuredAd.oldPrice! > 0
              ? '${(((featuredAd.oldPrice! - featuredAd.price) / featuredAd.oldPrice!) * 100).round()}%'
              : '',
        ),
      );
    }

    final List<dynamic>? rawProducts =
        (json['products'] as List<dynamic>?) ??
        (json['data'] is List<dynamic>
            ? json['data'] as List<dynamic>
            : (json['data'] is Map<String, dynamic> &&
                      (json['data'] as Map<String, dynamic>)['products']
                          is List<dynamic>
                  ? (json['data'] as Map<String, dynamic>)['products']
                        as List<dynamic>
                  : null)) ??
        (json['items'] as List<dynamic>?);

    // Fetch best sellers raw list for both best_sellers section and flash sale extraction
    final List<dynamic>? rawBestSellers =
        (json['best_sellers'] as List<dynamic>?) ??
        (json['bestSellers'] as List<dynamic>?) ??
        (json['bestsellers'] as List<dynamic>?) ??
        (json['popular_products'] as List<dynamic>?) ??
        (json['top_products'] as List<dynamic>?) ??
        rawProducts;

    final List<dynamic>? rawNewest =
        (json['newest_products'] as List<dynamic>?) ??
        (json['newestProducts'] as List<dynamic>?) ??
        (json['latest_products'] as List<dynamic>?) ??
        (json['latestProducts'] as List<dynamic>?) ??
        (json['new_products'] as List<dynamic>?) ??
        (json['featured_products'] as List<dynamic>?) ??
        rawProducts ??
        rawBestSellers;

    // Flash sales: prefer explicit flash_sales key; if empty, fall back to
    // extracting products from best_sellers/products so flash section is never empty.
    List<dynamic>? rawFlashSale =
        (json['flash_sales'] as List<dynamic>?) ??
        (json['flash_sale'] as List<dynamic>?) ??
        (json['flashSales'] as List<dynamic>?) ??
        (json['flashSale'] as List<dynamic>?) ??
        (json['discount_products'] as List<dynamic>?);

    if (rawFlashSale == null || rawFlashSale.isEmpty) {
      final candidates = (rawBestSellers != null && rawBestSellers.isNotEmpty)
          ? rawBestSellers
          : rawProducts;
      if (candidates != null && candidates.isNotEmpty) {
        // Filter candidates that are flash sales or have discounts
        final filtered = candidates.where((e) {
          if (e is! Map<String, dynamic>) return false;
          final isFlash = e['is_flash_sale'];
          if (isFlash == true ||
              isFlash == 1 ||
              isFlash == '1' ||
              isFlash == 'true') {
            return true;
          }
          final hasDisc = e['has_discount'];
          if (hasDisc == true ||
              hasDisc == 1 ||
              hasDisc == '1' ||
              hasDisc == 'true') {
            return true;
          }
          final double p =
              (e['display_price'] as num?)?.toDouble() ??
              (e['price'] as num?)?.toDouble() ??
              0;
          final double op =
              (e['original_price'] as num?)?.toDouble() ??
              (e['old_price'] as num?)?.toDouble() ??
              0;
          return op > p && p > 0;
        }).toList();

        rawFlashSale = filtered.isNotEmpty ? filtered : candidates;
      }
    }

    return HomeDataModel(
      offers: offersList,
      flashSale:
          rawFlashSale
              ?.map(
                (e) =>
                    FlashSaleProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bestSellers:
          rawBestSellers
              ?.map((e) => BestSellerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      partners:
          (json['partners'] as List<dynamic>?)
              ?.map((e) => PartnerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      newestProducts:
          rawNewest
              ?.map(
                (e) => NewestProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      featuredAd: featuredAd,
      isMember: isMember,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sliders': offers.map((e) => e.toJson()).toList(),
      'flash_sale': flashSale.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'best_sellers': bestSellers.map((e) => e.toJson()).toList(),
      'partners': partners.map((e) => e.toJson()).toList(),
      'newest_products': newestProducts.map((e) => e.toJson()).toList(),
      if (featuredAd != null) 'featured_ad': featuredAd!.toJson(),
      'is_member': isMember,
    };
  }

  HomeDataEntity toEntity() {
    return HomeDataEntity(
      offers: offers.map((e) => e.toEntity()).toList(),
      flashSale: flashSale.map((e) => e.toEntity()).toList(),
      categories: categories.map((e) => e.toEntity()).toList(),
      bestSellers: bestSellers.map((e) => e.toEntity()).toList(),
      partners: partners.map((e) => e.toEntity()).toList(),
      newestProducts: newestProducts.map((e) => e.toEntity()).toList(),
      featuredAd: featuredAd?.toEntity(),
      isMember: isMember,
    );
  }

  @override
  List<Object?> get props => [
    offers,
    flashSale,
    categories,
    bestSellers,
    partners,
    newestProducts,
    featuredAd,
    isMember,
  ];
}
