import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/features/home/domain/entities/newest_product_entity.dart';

/// Card widget for a product in the newest products grid.
class NewestProductCard extends StatelessWidget {
  final NewestProductEntity product;
  final VoidCallback? onCartTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onDetailsTap;

  const NewestProductCard({
    super.key,
    required this.product,
    this.onCartTap,
    this.onFavoriteTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format discount text
    String? discountText;
    if (product.discount.isNotEmpty) {
      discountText = product.discount.startsWith('-')
          ? product.discount
          : '-${product.discount}';
      if (!discountText.endsWith('%')) {
        discountText = '$discountText%';
      }
    }

    return GestureDetector(
      onTap: onDetailsTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppShadows.productCard,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Expanded(
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
                      placeholder: (_, _) =>
                          Container(color: context.colors.backgroundSecondary),
                      errorWidget: (_, _, _) => Container(
                        color: context.colors.backgroundSecondary,
                        child: Icon(
                          Icons.image,
                          color: context.colors.textQuaternary,
                        ),
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: InkWell(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavorite
                              ? context.colors.heartRed
                              : const Color(0xFF90A4AE),
                          size: 18.r,
                        ),
                      ),
                    ),
                  ),
                  // Discount badge
                  if (discountText != null)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF183B64),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          discountText,
                          style: TextStyle(
                            color: context.colors.textOnPrimary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 4.h,
                    left: 8.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colors.background,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.rating.toStringAsFixed(1),
                                style: TextStyle(
                                  color: context.colors.textSecondary,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.star_rounded,
                                size: 14.r,
                                color: const Color(0xFFFFB800),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    product.title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),

                  // Store
                  if (product.store.isNotEmpty) ...[
                    Text(
                      product.store,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Rating
                  SizedBox(height: 15.h),

                  // Price & Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Cart button

                      // Price
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${product.price.toStringAsFixed(0)} ج.م',
                                style: TextStyle(
                                  color: context.colors.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
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
                                    color: context.colors.textTertiary,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor:
                                        context.colors.textTertiary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: onCartTap,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: context.colors.textOnPrimary,
                            size: 16.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
