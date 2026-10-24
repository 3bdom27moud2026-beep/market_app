import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Statistics widget for profile screen matching the exact design.
class ProfileStatistics extends StatelessWidget {
  final int ordersCount;
  final int subscriptionDaysRemaining;
  final int favoritesCount;
  final bool hasActiveCard;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onOrdersTap;

  const ProfileStatistics({
    super.key,
    required this.ordersCount,
    required this.subscriptionDaysRemaining,
    required this.favoritesCount,
    this.hasActiveCard = true,
    this.onFavoritesTap,
    this.onOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Row(
        children: [
          // Favorites Card (Left in RTL)
          _StatCard(
            value: '$favoritesCount',
            label: 'المفضلة',
            onTap: onFavoritesTap,
          ),

          SizedBox(width: (AppSpacing.sm + 2).w),

          // Subscription Days Card (Middle - Coral Red Highlighted when active)
          _StatCard(
            value: hasActiveCard
                ? '$subscriptionDaysRemaining يوم'
                : 'غير مفعّل',
            label: 'باقي بالاشتراك',
            isHighlighted: hasActiveCard && subscriptionDaysRemaining > 0,
          ),

          SizedBox(width: (AppSpacing.sm + 2).w),

          // Orders Card (Right in RTL)
          _StatCard(
            value: '$ordersCount',
            label: 'الطلبات',
            onTap: onOrdersTap,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const _StatCard({
    required this.value,
    required this.label,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xs.w,
            vertical: (AppSpacing.md + 2).h,
          ),
          decoration: BoxDecoration(
            color: isHighlighted
                ? const Color(0xFFFF5B5B)
                : context.colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadowLight,
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted
                      ? Colors.white
                      : context.colors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isHighlighted
                      ? Colors.white.withValues(alpha: 0.9)
                      : context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
