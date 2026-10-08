import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Individual menu tile widget for the profile screen.
///
/// Each row contains:
/// - Leading icon
/// - Title
/// - Arrow icon
class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.md.h,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.lg.r),
        ),
        child: Row(
          children: [
            // Leading Icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: context.colors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppSpacing.md.r),
              ),
              child: Icon(
                icon,
                size: 22.r,
                color: iconColor ?? context.colors.textSecondary,
              ),
            ),

            SizedBox(width: AppSpacing.md.w),

            // Title
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.chevron_left,
              size: 24.r,
              color: context.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
