import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/presentation/widgets/merchant_tile.dart';

/// {@template category_tile}
/// An expandable tile that displays a discount category with its merchants.
/// Uses AnimatedSize for smooth expand/collapse animation.
/// {@endtemplate}
class CategoryTile extends StatefulWidget {
  final DiscountCategoryEntity category;
  final VoidCallback? onToggle;

  const CategoryTile({super.key, required this.category, this.onToggle});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.8)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              widget.onToggle?.call();
            },
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  // Category icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: context.colors.primaryLightest.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Center(
                      child: Text(
                        widget.category.icon,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Category info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: AppTextStyles.headingSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${widget.category.merchantsCount} تجار',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Max discount badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.accentOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      'حتى ${widget.category.maxDiscount.toStringAsFixed(0)}%',
                      style: AppTextStyles.discountBadge.copyWith(
                        color: context.colors.accentOrange,
                        fontSize: 7.sp,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Expand arrow
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded merchants list
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _isExpanded
                ? Column(
                    children: [
                      Divider(height: 1, color: context.colors.divider),
                      ...widget.category.merchants.map(
                        (merchant) => MerchantTile(merchant: merchant),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
