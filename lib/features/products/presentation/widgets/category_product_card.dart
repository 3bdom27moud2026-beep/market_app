import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';

/// A card widget that displays a product in the category products grid matching the design mockup.
class CategoryProductCard extends StatelessWidget {
  final ProductEntity product;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const CategoryProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String? discountLabel;
    if (product.discount > 0) {
      discountLabel = '-${product.discount}%';
    } else if (product.oldPrice > product.price && product.oldPrice > 0) {
      final diff = (product.oldPrice - product.price).toInt();
      discountLabel = 'وفّر $diff ج.م';
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => context.push('/product-details/${product.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.colors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top Image section with Discount Badge & Favorite Button ──
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        memCacheWidth: 400,
                        memCacheHeight: 400,
                        placeholder: (context, url) => Container(
                          color: context.colors.backgroundSecondary,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: context.colors.backgroundSecondary,
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: context.colors.textQuaternary,
                            size: 36.r,
                          ),
                        ),
                      ),
                    ),

                    // Discount badge on top right in RTL
                    if (discountLabel != null)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            discountLabel,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),

                    // Favorite button on top left in RTL
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: context.colors.surface.withValues(
                              alpha: 0.85,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
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
                                  : context.colors.textSecondary,
                              size: 18.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── 2. Product Details ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      product.name,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: context.colors.textPrimary,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),

                    // Store / Merchant Name
                    if (product.store.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: 14.r,
                            color: context.colors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              product.store,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: context.colors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 4.h),

                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14.r,
                          color: const Color(0xFFFFB800),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          product.rating > 0
                              ? product.rating.toStringAsFixed(1)
                              : '4.8',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Price and Old Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (product.isPriceOnInspection)
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'القيمة بعد المعاينة',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFFEF8226),
                                    ),
                                  ),
                                )
                              else ...[
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${product.price.toStringAsFixed(0)} ج.م',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w900,
                                      color: context.colors.primary,
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
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: context.colors.textTertiary,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor:
                                            context.colors.textTertiary,
                                      ),
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),

                        // Action / Cart mini button
                        Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 13.r,
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
      ),
    );
  }
}
