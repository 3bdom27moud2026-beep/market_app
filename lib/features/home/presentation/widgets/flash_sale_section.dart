import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/widgets/orange_custom_icon.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';
import 'package:market/features/home/presentation/cubit/home_state.dart';
import 'flash_sale_timer.dart';
import 'flash_sale_product_card.dart';

/// Flash Sale section with dark navy background, header with bolt icon,
/// countdown timer, horizontal product list, and "عرض كل عروض الفلاش" button.
class FlashSaleSection extends StatelessWidget {
  final List<FlashSaleProductEntity> products;
  final Duration timerDuration;
  final void Function(String productId)? onProductTap;
  final void Function(String productId, String title)? onAddToCart;
  final VoidCallback? onViewAllTap;

  const FlashSaleSection({
    super.key,
    required this.products,
    required this.timerDuration,
    this.onProductTap,
    this.onAddToCart,
    this.onViewAllTap,
  });

  /// Sort flash sale products based on the selected filter.
  static List<FlashSaleProductEntity> sortProducts(
    List<FlashSaleProductEntity> products,
    NewestFilter filter,
  ) {
    final sorted = List<FlashSaleProductEntity>.from(products);
    switch (filter) {
      case NewestFilter.newest:
        break;
      case NewestFilter.highestDiscount:
        sorted.sort((a, b) {
          final aDiscount = _parseDiscount(
            a.discount,
            price: a.price,
            oldPrice: a.oldPrice,
          );
          final bDiscount = _parseDiscount(
            b.discount,
            price: b.price,
            oldPrice: b.oldPrice,
          );
          return bDiscount.compareTo(aDiscount);
        });
        break;
      case NewestFilter.lowestPrice:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case NewestFilter.highestRating:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return sorted;
  }

  static double _parseDiscount(
    String discount, {
    double price = 0,
    double oldPrice = 0,
  }) {
    final numeric = discount.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(numeric) ?? 0;
    if (parsed > 0) return parsed;
    if (oldPrice > price && oldPrice > 0) {
      return ((oldPrice - price) / oldPrice) * 100;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF10335D),
        borderRadius: BorderRadius.circular(22.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Decorative Overlay Shapes
          Positioned(
            top: -40.h,
            left: -40.w,
            child: Container(
              width: 140.r,
              height: 140.r,
              decoration: const BoxDecoration(
                color: Color(0x0AFFFFFF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            right: -30.w,
            child: Container(
              width: 160.r,
              height: 160.r,
              decoration: const BoxDecoration(
                color: Color(0x06FFFFFF),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main Section Content
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header Row (Title + Icon on Right, Timer on Left) ────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Right: Title & Subtitle + Orange Bolt Badge
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            OrangeCustomIcon(
                              image: "assets/images/flash_sale_icon.png",
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'فلاش سيل',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 14.5.sp,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'عروض محدودة بكميات قليلة',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 8.5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF8FA7C6),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 8.w),

                      // Left: Countdown Timer
                      FlashSaleTimer(duration: timerDuration),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // ── Horizontal Products List ──────────────────────────────
                  if (products.isEmpty)
                    const _EmptyState()
                  else
                    SizedBox(
                      height: 300.h,

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return FlashSaleProductCard(
                            product: product,
                            onCartTap: () => onProductTap?.call(product.id),
                            onFavoriteTap: () {},
                            onDetailsTap: () => onProductTap?.call(product.id),
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 14.h),

                  // ── Bottom "عرض كل عروض الفلاش" Button ──────────────────────
                  GestureDetector(
                    onTap: onViewAllTap,
                    child: Container(
                      width: double.infinity,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0x1FFFFFFF),
                        borderRadius: BorderRadius.circular(13.r),
                        border: Border.all(
                          color: const Color(0x24FFFFFF),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'عرض كل عروض الفلاش',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 13.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_offer_outlined,
            color: const Color(0xFF8FA7C6),
            size: 40.r,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            'لا توجد عروض حالياً',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 9.sp,
              color: const Color(0xFF8FA7C6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
