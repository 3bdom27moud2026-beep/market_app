import 'package:flutter/material.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/widgets/curved_nav_bar/curved_pill_nav_bar.dart';
import 'package:market/core/widgets/curved_nav_bar/nav_bar_custom_icons.dart';

/// Centralized constants for the custom curved bottom navigation bar.
abstract final class AppBottomNav {
  // Dimensions
  static const double navHeight = 66;
  static const double navBorderRadius = 28;
  static const double iconSize = 26;
  static const double activeIconSize = 28;
  static const double labelFontSize = 10;
  static const double activeLabelFontSize = 10;

  /// The 5 tabs matching the screenshot exactly:
  /// 1. الرئيسية (Home)
  /// 2. طلباتي (My Orders)
  /// 3. نقاطي (My Points / Discount Card)
  /// 4. حسابي (Profile)
  /// 5. سلتي (My Cart)
  static const List<CurvedNavBarItemData> items = [
    CurvedNavBarItemData(
      iconType: NavTabType.home,
      label: 'الرئيسية',
      route: AppRoutes.home,
    ),
    CurvedNavBarItemData(
      icon: Icons.grid_view,
      activeIcon: Icons.grid_view_rounded,
      label: 'الاقسام',
      route: AppRoutes.categories,
    ),
    CurvedNavBarItemData(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'المفضلة',
      route: AppRoutes.favorites,
    ),
    CurvedNavBarItemData(
      iconType: NavTabType.profile,
      label: 'حسابي',
      route: AppRoutes.profile,
    ),
    CurvedNavBarItemData(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_outlined,
      label: 'سلتي',
      route: AppRoutes.basket,
    ),
  ];

  /// Legacy tabs definition kept for backward compatibility.
  static const List<TabItem> tabs = [
    TabItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'الرئيسية',
      route: AppRoutes.home,
    ),
    TabItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'الأقسام',
      route: AppRoutes.categories,
    ),
    TabItem(
      icon: Icons.favorite_border_rounded,
      activeIcon: Icons.favorite_rounded,
      label: 'المفضلة',
      route: AppRoutes.favorites,
    ),
    TabItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'حسابي',
      route: AppRoutes.profile,
    ),
    TabItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      label: 'سلتي',
      route: AppRoutes.basket,
    ),
  ];
}

/// Configuration for a single navigation tab (legacy).
class TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
