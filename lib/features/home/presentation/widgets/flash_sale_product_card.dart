import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';

/// A card widget for a flash sale product matching the design mockup.
class FlashSaleProductCard extends StatelessWidget {
  final FlashSaleProductEntity product;
  final VoidCallback? onCartTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onDetailsTap;

  const FlashSaleProductCard({
    super.key,
    required this.product,
    this.onCartTap,
    this.onFavoriteTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format discount text (e.g. "-51%")
    String? discountText;
    if (product.discount.isNotEmpty) {
      discountText = product.discount.startsWith('-')
          ? product.discount
          : '-${product.discount}';
      if (!discountText.endsWith('%')) {
        discountText = '$discountText%';
      }
    }

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
            boxShadow: AppShadows.productCard,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: SizedBox(
                  height: 125.h,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          memCacheWidth: 350,
                          memCacheHeight: 350,
                          maxWidthDiskCache: 600,
                          maxHeightDiskCache: 600,
                          placeholder: (_, _) => Container(
                            color: context.colors.backgroundSecondary,
                          ),
                          errorWidget: (_, _, _) => Container(
                            color: context.colors.backgroundSecondary,
                            child: Icon(
                              Icons.image,
                              color: context.colors.textQuaternary,
                            ),
                          ),
                        ),
                      ),

                      // Discount Badge
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
                              color: context.colors.primary,
                              borderRadius: BorderRadius.circular(6.r),
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
                                fontFamily: AppTextStyles.fontFamily,
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                      if (product.rating > 0)
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.background,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  product.rating > 0
                                      ? product.rating.toStringAsFixed(1)
                                      : '',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: context.colors.textSecondary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Icon(
                                  Icons.star_rounded,
                                  size: 14.r,
                                  color: const Color(0xFFFFB800),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 2. Card Content Details
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        SizedBox(
                          height: 35.h,
                          child: Text(
                            product.title,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: context.colors.textPrimary,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Brand / Store Name
                        if (product.store.isNotEmpty) ...[
                          SizedBox(
                            height: 30.h,
                            child: Text(
                              product.store,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                color: context.colors.textSecondary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],

                        // Stock Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2.r),
                          child: LinearProgressIndicator(
                            value: 0.65,
                            minHeight: 4.h,
                            backgroundColor: context.colors.primary.withValues(
                              alpha: 0.12,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.colors.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Remaining Stock Text
                        Text(
                          'باقي ${product.remaining} فقط',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Bottom Action Row: Price on right & Cart Button on left
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Price Column on right
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${product.price.toStringAsFixed(0)} ج.م',
                                      style: TextStyle(
                                        fontFamily: AppTextStyles.fontFamily,
                                        color: context.colors.primary,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  if (product.oldPrice > product.price &&
                                      product.oldPrice > 0)
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${product.oldPrice.toStringAsFixed(0)} ج.م',
                                        style: TextStyle(
                                          fontFamily: AppTextStyles.fontFamily,
                                          color: context.colors.textTertiary,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor:
                                              context.colors.textTertiary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Square Cart Button on left
                            GestureDetector(
                              onTap: onCartTap,
                              child: Container(
                                width: 32.r,
                                height: 32.r,
                                decoration: BoxDecoration(
                                  color: context.colors.primary,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                    size: 16.r,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
