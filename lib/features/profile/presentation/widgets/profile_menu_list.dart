import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/theme/theme_cubit.dart';

/// Menu list widget displaying grouped options for profile screen.
class ProfileMenuList extends StatelessWidget {
  final VoidCallback? onEditProfileTap;
  final VoidCallback? onChangePasswordTap;
  final VoidCallback? onTrackOrdersTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onPreviousOrdersTap;

  const ProfileMenuList({
    super.key,
    this.onEditProfileTap,
    this.onChangePasswordTap,
    this.onTrackOrdersTap,
    this.onFavoritesTap,
    this.onPreviousOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _MenuItem(
            icon: Icons.person_outline,
            title: 'تعديل الملف الشخصي',
            onTap: onEditProfileTap,
          ),
          Divider(height: 1, color: context.colors.divider),
          _MenuItem(
            icon: Icons.lock_outline_rounded,
            title: 'تغيير كلمة المرور',
            onTap: onChangePasswordTap,
          ),
          Divider(height: 1, color: context.colors.divider),
          _MenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'تتبع الطلبات',
            onTap: onTrackOrdersTap,
          ),
          Divider(height: 1, color: context.colors.divider),
          _MenuItem(
            icon: Icons.favorite_border,
            title: 'المفضلة',
            onTap: onFavoritesTap,
          ),
          Divider(height: 1, color: context.colors.divider),
          _MenuItem(
            icon: Icons.format_list_bulleted,
            title: 'الطلبات السابقة',
            onTap: onPreviousOrdersTap,
          ),
          Divider(height: 1, color: context.colors.divider),
          const _ThemeToggleMenuItem(),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({required this.icon, required this.title, this.onTap});

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
            // Chevron arrow icon (on left in RTL)
            Icon(
              Icons.chevron_left,
              size: 20.r,
              color: context.colors.textTertiary,
            ),
            const Spacer(),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            // Leading Icon (on right in RTL)
            Icon(icon, size: 22.r, color: context.colors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _ThemeToggleMenuItem extends StatelessWidget {
  const _ThemeToggleMenuItem();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isDark = mode == ThemeMode.dark;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg.w,
            vertical: AppSpacing.sm.h,
          ),
          child: Row(
            children: [
              Switch.adaptive(
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                activeThumbColor: context.colors.accentOrange,
              ),
              const Spacer(),
              Text(
                isDark ? 'الوضع الداكن (مفعّل)' : 'الوضع الداكن',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.dark_mode_outlined,
                size: 22.r,
                color: isDark
                    ? context.colors.accentOrange
                    : context.colors.textSecondary,
              ),
            ],
          ),
        );
      },
    );
  }
}
