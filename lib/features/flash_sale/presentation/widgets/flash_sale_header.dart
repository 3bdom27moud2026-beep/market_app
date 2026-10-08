import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';
import '../../domain/entities/flash_sale_entity.dart';
import 'countdown_timer.dart';

/// Dark blue header section with flash sale title, subtitle, lightning icon,
/// back button, and countdown timer.
class FlashSaleHeader extends StatelessWidget {
  final VoidCallback onBack;
  final CountdownEntity countdown;

  const FlashSaleHeader({
    super.key,
    required this.onBack,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxxl,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: context.colors.darkBlueContainer,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.xxl),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBackButton(onPressed: onBack),
              const CartBadgeButton(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Title and lightning icon
          Row(
            children: [
              Icon(Icons.bolt, color: context.colors.accentOrange, size: 28),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'فلاش سيل',
                style: AppTextStyles.whiteHeading.copyWith(fontSize: 20.sp),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Subtitle
          Text('عروض في جميع أنحاء مصر', style: AppTextStyles.whiteBody),
          const SizedBox(height: AppSpacing.lg),
          // Countdown timer
          FlashSaleCountdownTimer(countdown: countdown),
        ],
      ),
    );
  }
}
