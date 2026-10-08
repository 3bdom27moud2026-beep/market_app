import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';
import 'discount_badge.dart';
import 'stock_progress.dart';

/// Flash sale product card for the grid view.
class FlashSaleProductCard extends StatelessWidget {
  final FlashSaleProductEntity product;

  const FlashSaleProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final discountText = product.discount.isNotEmpty ? product.discount : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          context.push('/product-details/${product.id}');
        },
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.colors.borderLight, width: 1.w),
            boxShadow: AppShadows.productCard,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image stage with discount badge
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : const Color(0xFFE2E8F0),
                      width: 0.8.w,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Hero(
                            tag: 'flash_sale_${product.id}',
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              fit: BoxFit.contain,
                              memCacheWidth: 350,
                              memCacheHeight: 350,
                              maxWidthDiskCache: 600,
                              maxHeightDiskCache: 600,
                              placeholder: (_, _) => Center(
                                child: SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.r,
                                    color: context.colors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (_, _, _) => Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  color: context.colors.textQuaternary,
                                  size: 32.r,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Discount badge on top right in RTL
                      if (discountText != null)
                        Positioned(
                          top: 6.h,
                          left: 6.w,
                          child: DiscountBadge(discountText: discountText),
                        ),
                    ],
                  ),
                ),
              ),
              // Details section
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      product.title,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: context.colors.textPrimary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),

                    // Store name
                    if (product.store.isNotEmpty)
                      Text(
                        product.store,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: context.colors.textSecondary,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 3.h),

                    // Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.rating > 0
                              ? product.rating.toStringAsFixed(1)
                              : '4.7',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: context.colors.textSecondary,
                            fontSize: 9.5.sp,
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
                    SizedBox(height: 4.h),

                    // Stock progress
                    StockProgress(
                      remaining: product.remaining,
                      stockPercent: 65,
                    ),
                    SizedBox(height: 6.h),

                    // Price row with Cart button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Price Column
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
                                    fontSize: 13.sp,
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
                                      fontSize: 9.sp,
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

                        // Cart button
                        Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 15.r,
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
