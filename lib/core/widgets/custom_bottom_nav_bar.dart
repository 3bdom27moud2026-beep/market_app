import 'dart:math' as math;
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_bottom_nav.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/core/widgets/curved_nav_bar/nav_bar_custom_icons.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';

/// The classic, elegant curved bottom navigation bar matching the user's reference image.
///
/// Features:
/// - Uses the standard [CurvedNavigationBar] matching the reference design.
/// - 5 tabs in RTL order:
///   1. الرئيسية (Home)
///   2. الفئات (Categories)
///   3. الحساب (Account / Profile)
///   4. المفضلة (Favorites - standard favorite icon)
///   5. السلة (Cart / Basket)
/// - Active accent: Vibrant Orange (0xFFEF8226).
/// - Inactive accent: Clean Grey (0xFF8E8E93).
/// - Surface: Pure White (or theme surface in dark mode).
/// - Cutout background seamlessly matches the page background.
/// - Full synchronization with swipeable PageView in MainShell.
class CustomBottomNavBar extends StatelessWidget {
  final String currentRoute;
  final StatefulNavigationShell? navigationShell;
  final ValueChanged<int>? onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentRoute,
    this.navigationShell,
    this.onTabSelected,
  });

  static const List<String> _branchRoutes = [
    AppRoutes.home,
    AppRoutes.categories,
    AppRoutes.profile,
    AppRoutes.favorites,
    AppRoutes.basket,
  ];

  @override
  Widget build(BuildContext context) {
    final items = AppBottomNav.items;

    // Determine the active index:
    int activeIndex = items.indexWhere(
      (item) =>
          currentRoute == item.route ||
          currentRoute.startsWith('${item.route}/'),
    );

    if (activeIndex == -1) {
      if (navigationShell != null) {
        final currentBranchIndex = navigationShell!.currentIndex;
        final currentBranchRoute = currentBranchIndex < _branchRoutes.length
            ? _branchRoutes[currentBranchIndex]
            : '';
<<<<<<< HEAD
        final index = items.indexWhere(
=======
        final index = tabs.indexWhere(
>>>>>>> b6fa6321f2dd520aaf5d36db3c607f68bb5947b1
          (item) => item.route == currentBranchRoute,
        );
        if (index != -1) {
          activeIndex = index;
        }
      } else {
        final index = items.indexWhere(
          (item) => currentRoute.startsWith(item.route),
        );
        if (index != -1) {
          activeIndex = index;
        }
      }
    }

    if (activeIndex == -1) {
      activeIndex = 0;
    }

    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const activeColor = Color(0xFFEF8226);
    const inactiveColor = Color(0xFF8E8E93);
    final barBg = isDark ? const Color(0xFF1E2838) : Colors.white;

<<<<<<< HEAD
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CurvedNavigationBar(
        index: activeIndex,
        height: math.min(65.0.h, 75.0),
        color: barBg,
        buttonBackgroundColor: barBg,
        backgroundColor: colors.background,
        animationCurve: Curves.easeInOutCubic,
        animationDuration: const Duration(milliseconds: 320),
        items: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = index == activeIndex;
          return NavBarCustomIcon(
            key: ValueKey('nav_item_$index'),
            type: item.iconType ?? NavTabType.home,
            isActive: isActive,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            size: 26.0.r,
          );
        }),
        onTap: (index) => _onTabTap(context, index, items[index].route),
=======
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.borderLight.withValues(alpha: 0.8),
            width: 1.w,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadowLight.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: activeIndex,
            onTap: (index) => _onTabTap(context, index, tabs[index].route),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: colors.accentOrange,
            unselectedItemColor: colors.textTertiary,
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            selectedLabelStyle: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontFamilyFallback: AppTextStyles.fontFamilyFallback,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              height: 1.4,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontFamilyFallback: AppTextStyles.fontFamilyFallback,
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              height: 1.4,
            ),
            items: tabs.map((tab) {
              return BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: Icon(tab.icon, size: 24.sp),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: Icon(tab.activeIcon, size: 24.sp),
                ),
                label: tab.label,
              );
            }).toList(),
          ),
        ),
>>>>>>> b6fa6321f2dd520aaf5d36db3c607f68bb5947b1
      ),
    );
  }

  void _onTabTap(BuildContext context, int index, String route) {
    final branchIndex = _branchRoutes.indexOf(route);
    final targetBranch = branchIndex != -1 ? branchIndex : index;
    onTabSelected?.call(targetBranch);

    if (navigationShell != null) {
      if (route == AppRoutes.profile) {
        try {
          context.read<ProfileCubit>().refresh();
        } catch (_) {}
      }
      if (route == AppRoutes.basket) {
        CartEventBus.instance.notifyCartUpdated();
      }
      navigationShell!.goBranch(
        targetBranch,
        initialLocation: targetBranch == navigationShell!.currentIndex,
      );
    } else {
      final currentLocation = GoRouterState.of(context).uri.toString();
      if (currentLocation == route) {
        if (route == AppRoutes.profile) {
          try {
            context.read<ProfileCubit>().refresh();
          } catch (_) {}
        }
        if (route == AppRoutes.basket) {
          CartEventBus.instance.notifyCartUpdated();
        }
        return;
      }
      if (route == AppRoutes.profile) {
        try {
          context.read<ProfileCubit>().refresh();
        } catch (_) {}
      }
      if (route == AppRoutes.basket) {
        CartEventBus.instance.notifyCartUpdated();
      }
      context.go(route);
    }
  }
}
