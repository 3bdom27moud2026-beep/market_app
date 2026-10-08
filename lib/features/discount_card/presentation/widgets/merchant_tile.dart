import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';

/// {@template merchant_tile}
/// Displays a single merchant with its name and discount percentage.
/// Used inside expanded category tiles.
/// {@endtemplate}
class MerchantTile extends StatelessWidget {
  final MerchantEntity merchant;

  const MerchantTile({super.key, required this.merchant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Merchant icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colors.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: merchant.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      merchant.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _defaultIcon(context),
                    ),
                  )
                : _defaultIcon(context),
          ),
          const SizedBox(width: AppSpacing.md),
          // Merchant name
          Expanded(
            child: Text(
              merchant.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Discount badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: context.colors.accentGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
            child: Text(
              '${merchant.discountPercentage.toStringAsFixed(0)}%',
              style: AppTextStyles.discountBadge.copyWith(
                color: context.colors.accentGreen,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultIcon(BuildContext context) {
    return Icon(
      Icons.store_outlined,
      size: 20,
      color: context.colors.textTertiary,
    );
  }
}
