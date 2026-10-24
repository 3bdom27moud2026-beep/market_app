import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/cart_item_entity.dart';
import 'quantity_selector.dart';

class BasketItemCard extends StatelessWidget {
  final CartItemEntity item;
  final bool isUpdating;
  final bool isDeleting;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onFavoriteToggle;

  const BasketItemCard({
    super.key,
    required this.item,
    this.isUpdating = false,
    this.isDeleting = false,
    this.onQuantityChanged,
    this.onDelete,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemTotal = (item.price * item.qty);
    final itemOldTotal = item.oldPrice != null
        ? (item.oldPrice! * item.qty)
        : null;
    final hasOldPrice = itemOldTotal != null && itemOldTotal > itemTotal;
    final hasDiscount =
        item.discountPercentage != null && item.discountPercentage! > 0;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDeleting ? 0.5 : 1.0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? context.colors.surface : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? context.colors.border.withValues(alpha: 0.6)
                : const Color(0xFFF2F4F7),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? context.colors.shadowLight
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Right side (in RTL): Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 74.r,
                height: 74.r,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 74.r,
                  height: 74.r,
                  color: context.colors.backgroundSecondary,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2.r),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 74.r,
                  height: 74.r,
                  color: context.colors.backgroundSecondary,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: context.colors.textQuaternary,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // 2. Middle: Product Name & Price / Discount Row
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? context.colors.textPrimary
                          : const Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      // Current Price
                      Text(
                        '${itemTotal.toStringAsFixed(0)} ج.م',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      // Strikethrough Old Price (only if exists and higher)
                      if (hasOldPrice)
                        Text(
                          '${itemOldTotal.toStringAsFixed(0)} ج.م',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            decoration: TextDecoration.lineThrough,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      // Discount Badge (only if exists)
                      if (hasDiscount)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1EB),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 11.sp,
                                color: const Color(0xFFEA580C),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'خصم ${item.discountPercentage!.toInt()}%',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFEA580C),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // 3. Left side (in RTL): Delete button (top) + QuantitySelector (bottom)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (isDeleting)
                  Padding(
                    padding: EdgeInsets.all(4.r),
                    child: SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  )
                else
                  InkWell(
                    onTap: isUpdating ? null : onDelete,
                    borderRadius: BorderRadius.circular(6.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 22,
                      ),
                    ),
                  ),
                SizedBox(height: 16.h),
                QuantitySelector(
                  quantity: item.qty,
                  maxStock: item.maxStock,
                  isLoading: isUpdating || isDeleting,
                  onChanged: isDeleting ? null : onQuantityChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
