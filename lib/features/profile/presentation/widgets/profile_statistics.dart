import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Statistics widget for profile screen matching Image 1 & Image 2 design.
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

  static const Color navyText = Color(0xFF0F2B48);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // Right: Favorites Card
            Expanded(
              child: _StatCard(
                icon: Icons.star_rounded,
                label: 'المفضلات',
                value: '$favoritesCount',
                onTap: onFavoritesTap,
              ),
            ),

            // Divider between Favorites & Days
            _buildVerticalDivider(),

            // Middle: Days Remaining Card
            Expanded(
              child: _StatCard(
                icon: Icons.access_time_rounded,
                label: 'ايام متبقية',
                value: '$subscriptionDaysRemaining',
              ),
            ),

            // Divider between Days & Orders
            _buildVerticalDivider(),

            // Left: Orders Card
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_bag_rounded,
                label: 'عدد الطلبات',
                value: '$ordersCount',
                onTap: onOrdersTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.5.w,
      height: 36.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  static const Color navyColor = Color(0xFF0F2B48);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top: Icon + Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 13.r,
                  color: navyColor,
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.bold,
                      color: navyColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            // Bottom: Bold big value
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
                color: navyColor,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
