import 'package:flutter/material.dart';
import 'package:market/features/home/presentation/widgets/home_app_bar.dart';

/// Reusable header widget for the profile screen matching the brand app bar style.
class ProfileHeader extends StatelessWidget implements PreferredSizeWidget {
  final int? cartItemCount;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;

  const ProfileHeader({
    super.key,
    this.cartItemCount,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return HomeAppBar(
      cartItemCount: cartItemCount,
      notificationCount: notificationCount,
      onNotificationTap: onNotificationTap,
      onCartTap: onCartTap,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
