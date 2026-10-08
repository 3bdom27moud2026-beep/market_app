import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_bottom_nav.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';

/// A standard, elegant, and responsive bottom navigation bar.
///
/// Features:
/// - Standard Material BottomNavigationBar docked cleanly at the bottom.
/// - 5 tabs: الرئيسية, الأقسام, نقاطي, حسابي, سلتي.
/// - Theme-aware styling adapting to light and dark modes.
/// - Subtle top border and soft shadow for clean separation.
/// - Arabic typography using the Alexandria font family.
/// - Preserves GoRouter StatefulNavigationShell branch switching.
class CustomBottomNavBar extends StatelessWidget {
  final String currentRoute;
  final StatefulNavigationShell? navigationShell;

  const CustomBottomNavBar({
    super.key,
    required this.currentRoute,
    this.navigationShell,
  });

  static const List<String> _branchRoutes = [
    AppRoutes.home,
    AppRoutes.categories,
    AppRoutes.favorites,
    AppRoutes.profile,
    AppRoutes.basket,
  ];

  @override
  Widget build(BuildContext context) {
    final tabs = AppBottomNav.tabs;

    // Determine the active index:
    // 1. Check if currentRoute matches a tab route directly
    int activeIndex = tabs.indexWhere(
      (item) =>
          currentRoute == item.route ||
          currentRoute.startsWith('${item.route}/'),
    );

    // 2. Fall back to navigationShell's current branch if route didn't directly match
    if (activeIndex == -1) {
      if (navigationShell != null) {
        final currentBranchIndex = navigationShell!.currentIndex;
        final currentBranchRoute = currentBranchIndex < _branchRoutes.length
            ? _branchRoutes[currentBranchIndex]
            : '';
        final index = tabs.indexWhere((item) => item.route == currentBranchRoute);
        if (index != -1) {
          activeIndex = index;
        }
      } else {
        final index = tabs.indexWhere(
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
            selectedItemColor: colors.primary,
            unselectedItemColor: colors.textTertiary,
            selectedFontSize: 11.sp,
            unselectedFontSize: 11.sp,
            selectedLabelStyle: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              height: 1.4,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
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
      ),
    );
  }

  void _onTabTap(BuildContext context, int index, String route) {
    if (navigationShell != null) {
      if (route == AppRoutes.profile) {
        try {
          context.read<ProfileCubit>().refresh();
        } catch (_) {}
      }
      if (route == AppRoutes.basket) {
        CartEventBus.instance.notifyCartUpdated();
      }
      final branchIndex = _branchRoutes.indexOf(route);
      final targetBranch = branchIndex != -1 ? branchIndex : index;
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
