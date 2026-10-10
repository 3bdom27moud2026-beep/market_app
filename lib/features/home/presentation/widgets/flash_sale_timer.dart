import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_text_styles.dart';

/// Countdown timer widget for the flash sale section matching the design mockup.
///
/// Displays "ينتهي خلال" label and 3 time boxes: Hours (س), Minutes (د), and Seconds (ث).
class FlashSaleTimer extends StatelessWidget {
  final Duration duration;

  const FlashSaleTimer({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    final totalHours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'ينتهي خلال',
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFA5C1E5),
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _TimeBox(
                value: totalHours.toString().padLeft(2, '0'),
                label: 'س',
              ),
              const _Separator(),
              _TimeBox(value: minutes.toString().padLeft(2, '0'), label: 'د'),
              const _Separator(),
              _TimeBox(value: seconds.toString().padLeft(2, '0'), label: 'ث'),
            ],
          ),
        ],
      ),
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
          width: 40.r,
          height: 55.r,
          decoration: BoxDecoration(
            color: const Color(0xFF1E4574),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0x33FFFFFF), width: 0.5.w),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFA5C1E5),
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 10.h),
      child: Text(
        ':',
        style: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFA5C1E5),
        ),
      ),
    );
  }
}
