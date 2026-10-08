import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import '../../domain/entities/flash_sale_entity.dart';

/// Reusable countdown timer widget that displays days, hours, minutes, seconds.
/// Only rebuilds the timer section, not the whole screen.
class FlashSaleCountdownTimer extends StatelessWidget {
  final CountdownEntity countdown;

  const FlashSaleCountdownTimer({super.key, required this.countdown});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimeBox(
          value: countdown.days.toString().padLeft(2, '0'),
          label: 'يوم',
        ),
        _Separator(),
        _TimeBox(
          value: countdown.hours.toString().padLeft(2, '0'),
          label: 'ساعة',
        ),
        _Separator(),
        _TimeBox(
          value: countdown.minutes.toString().padLeft(2, '0'),
          label: 'دقيقة',
        ),
        _Separator(),
        _TimeBox(
          value: countdown.seconds.toString().padLeft(2, '0'),
          label: 'ثانية',
        ),
      ],
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            color: context.colors.textOnPrimary,
            borderRadius: BorderRadius.circular(AppSpacing.sm.r),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: AppTextStyles.timerNumber.copyWith(
              color: context.colors.primaryDark,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.xs.h),
        Text(label, style: AppTextStyles.timerLabel),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
      child: Text(':', style: AppTextStyles.timerNumber),
    );
  }
}
