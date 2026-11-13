import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_assets.dart';

/// Reusable header widget for the profile screen matching the design in Image 2.
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

  static const Color headerNavy = Color(0xFF0F2B48);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: headerNavy,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side (LTR): Brand Logo & Tagline
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      width: 36.r,
                      height: 36.r,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 28.r,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Shop Guide',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.2,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'SHOPPING IS EASIER WITH US',
                          style: TextStyle(
                            fontSize: 6.5.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white.withValues(alpha: 0.85),
                            letterSpacing: 0.5,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Right side: Screen title "حسابي"
              Text(
                'حسابي',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}

