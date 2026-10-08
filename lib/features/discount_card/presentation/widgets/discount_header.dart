import 'package:flutter/material.dart';
import 'package:market/features/home/presentation/widgets/home_app_bar.dart';

/// {@template discount_header}
/// Top app bar for the Discount Card screen matching the brand header layout.
/// {@endtemplate}
class DiscountHeader extends StatelessWidget implements PreferredSizeWidget {
  final int? cartItemCount;
  final int notificationCount;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;

  const DiscountHeader({
    super.key,
    this.cartItemCount,
    this.notificationCount = 0,
    this.onCartTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return HomeAppBar(
      cartItemCount: cartItemCount,
      notificationCount: notificationCount,
      onCartTap: onCartTap,
      onNotificationTap: onNotificationTap,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
