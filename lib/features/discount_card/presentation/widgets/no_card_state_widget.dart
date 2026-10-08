import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';
import 'package:market/features/discount_card/presentation/widgets/request_card_bottom_sheet.dart';

/// {@template no_card_state_widget}
/// Displays a polished empty state when the user does not have a Discount Card (card == null).
/// Includes clear Arabic messaging and a CTA button to request a card.
/// {@endtemplate}
class NoCardStateWidget extends StatelessWidget {
  const NoCardStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.8)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          // Icon Container
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary.withValues(alpha: 0.15),
                  context.colors.primaryDark.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.credit_card_off_rounded,
              size: 36,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Heading
          Text(
            'ليس لديك كارت خصم حتى الآن',
            style: AppTextStyles.headingMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Subtitle / Description
          Text(
            'احصل على كارت شوب جايد واستمتع بخصومات وتخفيضات حصرية ومميزات خاصة لدى مئات المتاجر والخدمات الشريكة!',
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 9.sp,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Request Card CTA Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () async {
                await showRequestCardBottomSheet(context);
                if (context.mounted) {
                  context.read<DiscountCardCubit>().refresh();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primaryDark,
                foregroundColor: context.colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.add_card_rounded, size: 18),
              label: Text(
                'طلب كارت الخصم',
                style: AppTextStyles.buttonOrange.copyWith(fontSize: 11.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
