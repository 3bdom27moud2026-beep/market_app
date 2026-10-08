import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

/// {@template card_status_info_widget}
/// Displays card status context (remaining days when active, or renewal banner when expired).
/// {@endtemplate}
class CardStatusInfoWidget extends StatelessWidget {
  final UserCardEntity card;

  const CardStatusInfoWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final bool isActive = card.isActive;
    final bool isExpired = card.status.toLowerCase() == 'expired';

    if (isActive) {
      final days = card.daysRemaining;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colors.accentGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: context.colors.accentGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: context.colors.accentGreen,
              size: 20,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                days > 0
                    ? 'اشتراكك مفعل - متبقي $days يوماً'
                    : 'اشتراكك مفعل حالياً',
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.accentGreen,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isExpired) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colors.accentRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: context.colors.accentRed.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: context.colors.accentRed,
              size: 28,
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'انتهت صلاحية الكارت',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.accentRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'انتهت فترة صلاحية هذا الكارت لمواصلة الاستفادة من الخصومات.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.textTertiary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'اشتراك سنوي — 12 شهر — 350 جنيه',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.accentRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 8.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
