import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';

/// {@template benefits_section}
/// Displays the benefits of the ShopGuide card with icons, titles,
/// and descriptions separated by dividers.
/// {@endtemplate}
class BenefitsSection extends StatelessWidget {
  final List<BenefitEntity> benefits;

  const BenefitsSection({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    if (benefits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'مميزات كارت شوب جايد',
            style: AppTextStyles.sectionTitle,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Benefits list
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: context.colors.border.withValues(alpha: 0.8),
            ),
            boxShadow: AppShadows.card,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: benefits.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: context.colors.divider),
            itemBuilder: (context, index) {
              final benefit = benefits[index];
              return Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: context.colors.primaryLightest.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Center(
                        child: Text(
                          benefit.icon,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            benefit.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            benefit.description,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
