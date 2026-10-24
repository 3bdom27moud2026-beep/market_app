import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// Primary action button widget for the promotion dialog.
class PromotionActionButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PromotionActionButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF8226),
          foregroundColor: context.colors.textOnPrimary,
          shadowColor: const Color(0xFFEF8226).withValues(alpha: 0.8),
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText.isNotEmpty ? buttonText : 'تسوق الآن',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: context.colors.textOnPrimary,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.arrow_forward_ios,
              color: context.colors.textOnPrimary,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}
