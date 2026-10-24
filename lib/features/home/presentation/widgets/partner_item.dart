import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/features/home/domain/entities/partner_entity.dart';

/// A card displaying a partner's logo and discount.
///
/// Tapping navigates to the merchant details screen.
class PartnerItem extends StatelessWidget {
  final PartnerEntity partner;
  final bool showDiscount;

  const PartnerItem({
    super.key,
    required this.partner,
    this.showDiscount = true,
  });

  void _navigateToDetails(BuildContext context) {
    context.push('/merchant-details/${partner.id}');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetails(context),
      borderRadius: BorderRadius.circular(AppSpacing.md.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80.h,
            width: 80.w,
            margin: EdgeInsets.only(
              left: AppSpacing.lg.w,
              bottom: AppSpacing.sm.h,
              top: AppSpacing.md.h,
            ),
            decoration: BoxDecoration(
              color: context.colors.textOnPrimary,
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
              boxShadow: AppShadows.card,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
              child: CachedNetworkImage(
                imageUrl: partner.logo,
                width: 60.r,
                height: 60.r,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: context.colors.backgroundSecondary,
                  width: 60.r,
                  height: 60.r,
                ),
                errorWidget: (_, _, _) => Container(
                  color: context.colors.backgroundSecondary,
                  width: 60.r,
                  height: 60.r,
                  child: Icon(Icons.store, size: 24.r),
                ),
              ),
            ),
          ),

          if (showDiscount && partner.discount.isNotEmpty) ...[
            SizedBox(height: AppSpacing.xs.h),
            Container(
              height: 20.h,
              width: 80.w,
              margin: EdgeInsets.only(left: AppSpacing.lg.w),
              decoration: BoxDecoration(
                color: context.colors.accentOrange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "خصم",
                    style: AppTextStyles.discountBadge.copyWith(
                      color: context.colors.accentOrange,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    partner.discount,
                    style: AppTextStyles.discountBadge.copyWith(
                      color: context.colors.accentOrange,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
