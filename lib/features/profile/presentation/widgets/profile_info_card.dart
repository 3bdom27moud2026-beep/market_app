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
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // User Avatar (on right)
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: (avatarUrl != null && avatarUrl!.isNotEmpty)
                    ? Image.network(
                        avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.person_rounded,
                          size: 30.r,
                          color: const Color(0xFF94A3B8),
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        size: 30.r,
                        color: const Color(0xFF94A3B8),
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
                    fullName.isNotEmpty ? fullName : 'احمد شكرى فايد',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    (phoneNumber != null && phoneNumber!.isNotEmpty)
                        ? phoneNumber!
                        : '01022365400',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: AppSpacing.sm.w),

            // Edit Icon Button (on left)
            InkWell(
              onTap: onEditTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.assignment_outlined,
                  size: 26.r,
                  color: const Color(0xFFEF8025),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
