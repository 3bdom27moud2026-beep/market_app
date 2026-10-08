import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Support & App Information section for profile screen.
class SupportSection extends StatelessWidget {
  final VoidCallback? onSupportTap;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onAboutTap;
  final VoidCallback? onRateTap;
  final VoidCallback? onLogoutTap;

  const SupportSection({
    super.key,
    this.onSupportTap,
    this.onTermsTap,
    this.onPrivacyTap,
    this.onAboutTap,
    this.onRateTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grouped Support & Legal Menu Card
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadowLight,
                blurRadius: 10.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            children: [
              _SupportItem(
                icon: Icons.headset_mic_outlined,
                title: 'مركز الدعم (واتساب)',
                onTap: onSupportTap,
              ),
              Divider(height: 1, color: context.colors.divider),
              _SupportItem(
                icon: Icons.article_outlined,
                title: 'الشروط والأحكام',
                onTap: onTermsTap,
              ),
              Divider(height: 1, color: context.colors.divider),
              _SupportItem(
                icon: Icons.shield_outlined,
                title: 'سياسة الخصوصية',
                onTap: onPrivacyTap,
              ),
              if (onAboutTap != null) ...[
                Divider(height: 1, color: context.colors.divider),
                _SupportItem(
                  icon: Icons.info_outline_rounded,
                  title: 'عن التطبيق',
                  onTap: onAboutTap,
                ),
              ],
            ],
          ),
        ),

        SizedBox(height: AppSpacing.xl.h),

        // Logout Red Card Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
          child: InkWell(
            onTap: onLogoutTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFFFF5B5B).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: const Color(0xFFFF5B5B),
                    size: 20.r,
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF5B5B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Shows logout confirmation dialog
  static Future<void> showLogoutDialog(
    BuildContext context,
    VoidCallback onConfirm,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFF5B5B),
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

class _SupportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _SupportItem({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg.w,
          vertical: AppSpacing.md.h + 2.h,
        ),
        child: Row(
          children: [
            Icon(
              Icons.chevron_left,
              size: 20.r,
              color: context.colors.textTertiary,
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Icon(icon, size: 22.r, color: context.colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
