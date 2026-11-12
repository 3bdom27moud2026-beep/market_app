import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/core/constants/app_assets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'home_search_bar.dart';

/// Custom AppBar for the application matching the new brand header design mockup.
///
/// Features:
/// - Deep navy brand background (`Color(0xFF0F2B48)`)
/// - Left side (LTR): App icon circular badge placed to the left of the title "ShopGuide"
///   and tagline "More Savings. Better Living."
/// - Right side (LTR): Notification bell with unread red dot indicator and circular profile avatar
/// - Optional embedded search bar matching the pill-shaped design
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int? cartItemCount;
  final int? notificationCount;
  final bool? hasUnreadNotifications;
  final bool showBackButton;
  final String? titleText;
  final bool showSearchBar;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onBackTap;
  final PreferredSizeWidget? bottom;

  const HomeAppBar({
    super.key,
    this.cartItemCount,
    this.notificationCount,
    this.hasUnreadNotifications,
    this.showBackButton = false,
    this.titleText,
    this.showSearchBar = false,
    this.onCartTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.onSearchTap,
    this.onFilterTap,
    this.onBackTap,
    this.bottom,
  });

  static const Color headerNavy = Color(0xFF0F2B48);

  @override
  Widget build(BuildContext context) {
    int effectiveCount = notificationCount ?? 0;
    if (notificationCount == null) {
      try {
        effectiveCount = context.watch<NotificationsCubit>().state.unreadCount;
      } catch (_) {
        effectiveCount = 0;
      }
    }

    return Container(
      color: headerNavy,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Brand & Actions (or Screen Title & Back Button)
            Container(
              height: 64.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left side: Brand Logo + Title or Back Button + Screen Title
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (showBackButton)
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed:
                                onBackTap ?? () => Navigator.maybePop(context),
                          ),
                        if (titleText != null)
                          Text(
                            titleText!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const _ShopGuideBrandLogo(),
                      ],
                    ),

                    // Right side: Notification Bell & Profile Avatar
                    _AppBarActions(
                      effectiveCount: effectiveCount,
                      hasUnreadNotifications: hasUnreadNotifications,
                      onNotificationTap: onNotificationTap,
                      onProfileTap: onProfileTap,
                    ),
                  ],
                ),
              ),
            ),

            // Embedded search bar if enabled (Home Screen)
            if (showSearchBar)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 2.h, 16.w, 12.h),
                child: HomeSearchBar(
                  onTap: onSearchTap ?? () => context.push(AppRoutes.search),
                  onFilterTap:
                      onFilterTap ?? () => context.push(AppRoutes.search),
                ),
              ),

            ?bottom,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    double h = 64.h;
    if (showSearchBar) {
      h += 62.h;
    }
    if (bottom != null) {
      h += bottom!.preferredSize.height;
    }
    return Size.fromHeight(h);
  }
}

/// Logo and brand title with the app icon strictly on the left of the title
class _ShopGuideBrandLogo extends StatelessWidget {
  const _ShopGuideBrandLogo();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App icon in a crisp circular badge on the left of the title
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4.r,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: EdgeInsets.all(5.5.r),
            child: SvgPicture.asset(AppAssets.logoSvg, fit: BoxFit.contain),
          ),
          SizedBox(width: 8.w),
          // Title & Subtitle column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ShopGuide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'More Savings. Better Living.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Notification bell with badge counter & Profile avatar on the right side
class _AppBarActions extends StatelessWidget {
  final int effectiveCount;
  final bool? hasUnreadNotifications;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const _AppBarActions({
    required this.effectiveCount,
    this.hasUnreadNotifications,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    String? avatarUrl;
    try {
      avatarUrl = context
          .watch<ProfileCubit>()
          .state
          .profileData
          ?.profile
          .avatarUrl;
    } catch (_) {}

    final bool showCountBadge = effectiveCount > 0;
    final bool showDotBadge =
        !showCountBadge && (hasUnreadNotifications == true);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Notification Bell with count badge indicator
          GestureDetector(
            onTap: () async {
              if (onNotificationTap != null) {
                onNotificationTap!();
              } else {
                await context.push(AppRoutes.notifications);
                if (context.mounted) {
                  try {
                    context.read<NotificationsCubit>().loadNotifications();
                  } catch (_) {}
                }
              }
            },
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 36.r,
              height: 36.r,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 26.r,
                  ),
                  if (showCountBadge)
                    Positioned(
                      top: 1.h,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: effectiveCount > 9 ? 4.w : 2.5.w,
                          vertical: 1.h,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.r,
                          minHeight: 16.r,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: HomeAppBar.headerNavy,
                            width: 1.5.r,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 2.r,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            effectiveCount > 99 ? '99+' : '$effectiveCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  else if (showDotBadge)
                    Positioned(
                      top: 3.h,
                      right: 4.w,
                      child: Container(
                        width: 8.5.r,
                        height: 8.5.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HomeAppBar.headerNavy,
                            width: 1.5.r,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // User Profile Avatar Circle
          GestureDetector(
            onTap: onProfileTap ?? () => context.push(AppRoutes.profile),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4.r,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipOval(
                child: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: HomeAppBar.headerNavy,
                            size: 22.r,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: HomeAppBar.headerNavy,
                          size: 22.r,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
