import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';

/// {@template statistic_card}
/// Single statistic display card with icon, value, and title.
/// {@endtemplate}
class StatisticCard extends StatelessWidget {
  final StatisticsEntity statistic;

  const StatisticCard({super.key, required this.statistic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.7)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.colors.primaryLightest.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(statistic.icon, style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            statistic.value,
            style: AppTextStyles.headingMedium.copyWith(
              color: context.colors.primaryDark,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            statistic.title,
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.textTertiary,
              fontSize: 7.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
