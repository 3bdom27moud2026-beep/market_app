import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';

/// User info card widget for the profile screen matching the design.
class ProfileInfoCard extends StatelessWidget {
  final String fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final VoidCallback? onEditTap;

  const ProfileInfoCard({
    super.key,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.lg.h,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLight,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // User Avatar (on right in RTL)
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: context.colors.backgroundSecondary,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.person_outline,
                        size: 32.r,
                        color: context.colors.primary,
                      ),
                    )
                  : Icon(
                      Icons.person_outline,
                      size: 32.r,
                      color: context.colors.primary,
                    ),
            ),
          ),

          SizedBox(width: AppSpacing.md.w),

          // User Name and Phone Number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fullName.isNotEmpty ? fullName : 'مستخدم تسوق',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  (phoneNumber != null && phoneNumber!.isNotEmpty)
                      ? phoneNumber!
                      : 'لا يوجد رقم هاتف',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.sm.w),

          // Edit Pencil Icon Button (on left in RTL)
          InkWell(
            onTap: onEditTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.sm.r + 2.r),
              decoration: BoxDecoration(
                color: context.colors.backgroundSecondary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.edit_outlined,
                size: 20.r,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
