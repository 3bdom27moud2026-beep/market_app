import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market/core/constants/app_assets.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/routes/app_routes.dart';
// import 'package:market/core/widgets/custom_nav_buttons.dart';

/// Custom AppBar for the application matching the brand header style.
///
/// Displays:
/// - Left side: Notification bell with orange dot
/// - Right side: Shop Guide logo with brand name and tagline
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? cartItemCount;
  final int notificationCount;
  final bool hasUnreadNotifications;
  final bool showBackButton;
  final String? titleText;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBackTap;
  final PreferredSizeWidget? bottom;

  const HomeAppBar({
    super.key,
    this.cartItemCount,
    this.notificationCount = 0,
    this.hasUnreadNotifications = true,
    this.showBackButton = false,
    this.titleText,
    this.onCartTap,
    this.onNotificationTap,
    this.onBackTap,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 68.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Right side (RTL Start): Logo with brand text & tagline or screen title & back button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showBackButton)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: const Color(0xFF1B4270),
                            size: 22.r,
                          ),
                          onPressed:
                              onBackTap ?? () => Navigator.maybePop(context),
                        ),
                      if (titleText != null)
                        Text(
                          titleText!,
                          style: TextStyle(
                            color: const Color(0xFF1B4270),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        const _ShopGuideBrandLogo(),
                    ],
                  ),

                  // Left side (RTL End): Action icons (Bell & Cart)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // const CartBadgeButton(),
                      SizedBox(width: 8.w),
                      _NotificationBellWithDot(
                        hasUnread:
                            hasUnreadNotifications || notificationCount > 0,
                        count: notificationCount,
                        onTap:
                            onNotificationTap ??
                            () => context.push(AppRoutes.notifications),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ?bottom,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(68.h + (bottom?.preferredSize.height ?? 0));
}

class _ShopGuideBrandLogo extends StatelessWidget {
  const _ShopGuideBrandLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppAssets.logoSvg,
          height: 40.r,
          width: 40.r,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Shop Guide',
              style: TextStyle(
                color: const Color(0xFF1B4270),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                height: 1.1,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'SHOPPING IS EASIER WITH US',
              style: TextStyle(
                color: const Color(0xFFEF8226),
                fontSize: 5.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                height: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationBellWithDot extends StatelessWidget {
  final bool hasUnread;
  final int count;
  final VoidCallback? onTap;

  const _NotificationBellWithDot({
    required this.hasUnread,
    this.count = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(4.0.r),
            child: Icon(
              Icons.notifications_none_rounded,
              color: const Color(0xFF1B4270),
              size: 28.r,
            ),
          ),
          if (count > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(2.5.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF8226),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                ),
                constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
                child: Center(
                  child: Text(
                    count > 99 ? '99+' : count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else if (hasUnread)
            Positioned(
              top: 2.h,
              right: 2.w,
              child: Container(
                width: 9.r,
                height: 9.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF8226),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5.w),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
