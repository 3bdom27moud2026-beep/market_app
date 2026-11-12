import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_colors.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';

/// Product card for the Flash Sale section matching the new brand mockup design.
class FlashSaleProductCard extends StatelessWidget {
  final FlashSaleProductEntity product;
  final bool isFavorite;
  final VoidCallback? onCartTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onDetailsTap;

  const FlashSaleProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onCartTap,
    this.onFavoriteTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Format discount text (e.g. "35%")
    String? discountText;
    if (product.discount.isNotEmpty) {
      discountText = product.discount.replaceAll('-', '').trim();
      if (!discountText.endsWith('%')) {
        discountText = '$discountText%';
      }
    }

    final bool hasOldPrice =
        product.oldPrice > product.price && product.oldPrice > 0;
    final double savings = hasOldPrice ? (product.oldPrice - product.price) : 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onDetailsTap,
        child: Container(
          width: 155.w,
          margin: EdgeInsets.only(left: 12.w),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? context.colors.border.withValues(alpha: 0.3)
                  : const Color(0xFFF1F5F9),
              width: 1,
            ),
            boxShadow: AppShadows.productCard,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top Image Section ─────────────────────────────────────
              SizedBox(
                height: 120.h,
                child: Stack(
                  children: [
                    // Product Image (cover with smooth rounded top corners)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15.r),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          memCacheWidth: 400,
                          memCacheHeight: 400,
                          maxWidthDiskCache: 600,
                          maxHeightDiskCache: 600,
                          placeholder: (_, _) => Container(
                            color: context.colors.backgroundSecondary,
                          ),
                          errorWidget: (_, _, _) => Container(
                            color: context.colors.backgroundSecondary,
                            child: Icon(
                              Icons.image_outlined,
                              color: context.colors.textQuaternary,
                              size: 28.r,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Discount Badge (Top-Left)
                    if (discountText != null)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            discountText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                    // Favorite Button (Top-Right)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 4.r,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF1E293B),
                              size: 15.r,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Rating Badge (Bottom-Left)
                    if (product.rating > 0)
                      Positioned(
                        bottom: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 3.r,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 12.r,
                                color: const Color(0xFFFFB800),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontFamily: AppStyles.priceFontFamily,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── 2. Card Content Details (Expanded) ───────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Upper block: Title, Store, Stock bar, Prices
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title (2 lines max for consistency)
                          SizedBox(
                            height: 32.h,
                            child: Text(
                              product.title.trim(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.darkCard,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),

                          // Store name
                          if (product.store.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            SizedBox(
                              height: 14.h,
                              child: Text(
                                product.store.trim(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: context.colors.textTertiary,
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],

                          // Stock Progress & Remaining Text
                          if (product.remaining > 0) ...[
                            SizedBox(height: 3.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2.r),
                              child: LinearProgressIndicator(
                                value: 0.65,
                                minHeight: 3.h,
                                backgroundColor: context.colors.primary
                                    .withValues(alpha: 0.12),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colors.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'باقي ${product.remaining} فقط',
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 8.5.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.darkCard,
                              ),
                            ),
                          ],

                          SizedBox(height: 4.h),

                          // Regular Price Row (Old Price Strike-through)
                          SizedBox(
                            height: 15.h,
                            child: hasOldPrice
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          product.oldPrice.toStringAsFixed(0),
                                          style: AppStyles.priceStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF64748B),
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationColor: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF64748B),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'جنيه سعر عادي',
                                          style: TextStyle(
                                            fontFamily:
                                                AppTextStyles.fontFamily,
                                            fontSize: 8.5.sp,
                                            fontWeight: FontWeight.w400,
                                            color: context.colors.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          SizedBox(height: 1.h),

                          // Member / Discount Price Row
                          SizedBox(
                            height: 18.h,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: AlignmentDirectional.centerStart,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    product.price.toStringAsFixed(0),
                                    style: AppStyles.priceStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    'جنيه سعر مشترك',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF10B981),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: const Color(0xFF10B981),
                                    size: 12.r,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 1.h),

                          // Savings Row
                          SizedBox(
                            height: 14.h,
                            child: (hasOldPrice && savings > 0)
                                ? FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      'وفر ${savings.toStringAsFixed(0)} جنيه بمجرد اشتراكك',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        fontSize: 8.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: context.colors.textTertiary,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),

                      // ── 3. Add to Cart Full-width Button (Pinned at Bottom) ───
                      GestureDetector(
                        onTap: onCartTap,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F2B48),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 13.r,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'أضف الي السلة',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  color: Colors.white,
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
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
        ),
      ),
    );
  }
}
