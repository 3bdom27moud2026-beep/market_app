import 'package:equatable/equatable.dart';
import 'offer_banner_entity.dart';
import 'flash_sale_product_entity.dart';
import 'category_entity.dart';
import 'best_seller_entity.dart';
import 'partner_entity.dart';
import 'newest_product_entity.dart';
import 'featured_ad_entity.dart';

/// Aggregate entity that holds all home screen data.
class HomeDataEntity extends Equatable {
  final List<OfferBannerEntity> offers;
  final List<FlashSaleProductEntity> flashSale;
  final List<CategoryEntity> categories;
  final List<BestSellerEntity> bestSellers;
  final List<PartnerEntity> partners;
  final List<NewestProductEntity> newestProducts;
  final FeaturedAdEntity? featuredAd;

  /// Whether the current user is a member (has a discount card).
  final bool isMember;

  const HomeDataEntity({
    required this.offers,
    required this.flashSale,
    required this.categories,
    required this.bestSellers,
    required this.partners,
    required this.newestProducts,
    this.featuredAd,
    this.isMember = false,
  });

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
