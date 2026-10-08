import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

import '../../domain/entities/merchant_entity.dart';
import 'basket_item_card.dart';

class MerchantCard extends StatefulWidget {
  final MerchantEntity merchant;
  final Function(String itemId, int newQuantity) onQuantityChanged;
  final Function(String itemId) onItemDelete;

  const MerchantCard({
    super.key,
    required this.merchant,
    required this.onQuantityChanged,
    required this.onItemDelete,
  });

  @override
  State<MerchantCard> createState() => _MerchantCardState();
}

class _MerchantCardState extends State<MerchantCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Merchant Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.storefront_rounded,
                      color: context.colors.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.merchant.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            if (widget.merchant.isVerified) ...[
                              SizedBox(width: 6.w),
                              Icon(
                                Icons.verified_rounded,
                                color: context.colors.primaryLightest,
                                size: 16.sp,
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.merchant.items.length} منتج',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: context.colors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (widget.merchant.rating != null) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.star_rounded,
                                color: context.colors.ratingYellow,
                                size: 14.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                '${widget.merchant.rating}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: context.colors.textTertiary,
                    size: 22.sp,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: context.colors.divider),

          // Items List with AnimatedSize
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      children: widget.merchant.items.map((item) {
                        return BasketItemCard(
                          item: item,
                          onQuantityChanged: (newQty) => widget
                              .onQuantityChanged(item.id.toString(), newQty),
                          onDelete: () =>
                              widget.onItemDelete(item.id.toString()),
                        );
                      }).toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
