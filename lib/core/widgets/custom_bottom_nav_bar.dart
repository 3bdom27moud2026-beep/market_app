import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_bottom_nav.dart';
import 'package:market/core/constants/app_colors.dart';
import 'package:market/core/constants/app_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/core/widgets/curved_nav_bar/curved_pill_nav_bar.dart';
import 'package:market/core/widgets/curved_nav_bar/nav_bar_custom_icons.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';

/// The classic, elegant curved bottom navigation bar with:
/// - Floating animated circle with dual drop-shadow for clear motion animation.
/// - Text label below every icon in Arabic.
/// - Full synchronization with swipeable PageView in MainShell.
class CustomBottomNavBar extends StatefulWidget {
  final String currentRoute;
  final StatefulNavigationShell? navigationShell;
  final ValueChanged<int>? onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentRoute,
    this.navigationShell,
    this.onTabSelected,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  static const List<String> _branchRoutes = [
    AppRoutes.home,
    AppRoutes.categories,
    AppRoutes.profile,
    AppRoutes.favorites,
    AppRoutes.basket,
  ];

  late AnimationController _animationController;
  late double _pos;
  late double _startingPos;
  late int _endingIndex;
  double _buttonHide = 0.0;
  late int _activeIndex;

  int _computeActiveIndex(List<CurvedNavBarItemData> items) {
    int index = items.indexWhere(
      (item) =>
          widget.currentRoute == item.route ||
          widget.currentRoute.startsWith('${item.route}/'),
    );

    if (index == -1) {
      if (widget.navigationShell != null) {
        final currentBranchIndex = widget.navigationShell!.currentIndex;
        final currentBranchRoute = currentBranchIndex < _branchRoutes.length
            ? _branchRoutes[currentBranchIndex]
            : '';
        final found = items.indexWhere(
          (item) => item.route == currentBranchRoute,
        );
        if (found != -1) {
          index = found;
        }
      } else {
        final found = items.indexWhere(
          (item) => widget.currentRoute.startsWith(item.route),
        );
        if (found != -1) {
          index = found;
        }
      }
    }

    return (index >= 0 && index < items.length) ? index : 0;
  }

  @override
  void initState() {
    super.initState();
    final items = AppBottomNav.items;
    _activeIndex = _computeActiveIndex(items);
    _pos = _activeIndex / items.length;
    _startingPos = _pos;
    _endingIndex = _activeIndex;

    _animationController = AnimationController(
      vsync: this,
      value: _pos,
      duration: const Duration(milliseconds: 320),
    );

    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos = _endingIndex / items.length;
        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - middle).abs() > 0.0001) {
          _buttonHide =
              (1.0 - ((middle - _pos) / (_startingPos - middle)).abs()).clamp(
                0.0,
                1.0,
              );
        } else {
          _buttonHide = 0.0;
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final items = AppBottomNav.items;
    final newActiveIndex = _computeActiveIndex(items);
    if (newActiveIndex != _activeIndex) {
      _activeIndex = newActiveIndex;
      _startingPos = _pos;
      _endingIndex = newActiveIndex;
      final newPos = newActiveIndex / items.length;
      _animationController.animateTo(
        newPos,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color headerNavy = Color(0xFF0F2B48);
    final items = AppBottomNav.items;
    final colors = context.colors;
    final activeColor = AppColors.brandOrange;
    final inactiveColor = AppColors.inactiveGrey;
    final barBg = headerNavy;

    final navHeight = math.min(68.0.h, 75.0);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: colors.background,
        child: SafeArea(
          top: false,
          bottom: true,
          child: SizedBox(
            height: navHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final itemWidth = maxWidth / items.length;
                final isRtl = Directionality.of(context) == TextDirection.rtl;

                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    // 1. Curved Background Bar with cutout
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: navHeight,
                      child: CustomPaint(
                        painter: _CurvedNavPainter(
                          startingLoc: _pos,
                          itemsLength: items.length,

                          color: barBg,
                          textDirection: Directionality.of(context),
                        ),
                        child: SizedBox(height: navHeight, width: maxWidth),
                      ),
                    ),

                    // 2. Animated Floating Circle with Enhanced Shadow
                    // Positioned above the active dip so movement is clearly visible
                    Positioned(
                      bottom: navHeight - 34.h + (_buttonHide * 8.h),
                      left: isRtl ? null : _pos * maxWidth,
                      right: isRtl ? _pos * maxWidth : null,
                      width: itemWidth,
                      child: Center(
                        child: Container(
                          width: 48.0.r,
                          height: 48.0.r,
                          decoration: BoxDecoration(
                            color: barBg,
                            shape: BoxShape.circle,
                            boxShadow: [
                              // Ambient soft shadow
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 10.r,
                                spreadRadius: 1.5.r,
                                offset: Offset(0, 4.h),
                              ),
                              // Vibrant orange glow for clear motion visibility
                              BoxShadow(
                                color: activeColor.withValues(alpha: 0.32),
                                blurRadius: 12.r,
                                spreadRadius: 1.r,
                                offset: Offset(0, 2.h),
                              ),
                            ],
                          ),
                          child: Center(
                            child: NavBarCustomIcon(
                              key: ValueKey('active_nav_icon_$_endingIndex'),
                              type:
                                  items[_endingIndex].iconType ??
                                  NavTabType.home,
                              isActive: true,
                              activeColor: activeColor,
                              inactiveColor: inactiveColor,
                              size: 26.0.r,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 3. Tab Buttons with Icon + Name (Label) under each icon
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: navHeight,
                      child: Row(
                        children: List.generate(items.length, (index) {
                          final item = items[index];
                          final isActive = index == _activeIndex;

                          return Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () =>
                                    _onTabTap(context, index, item.route),
                                splashColor: activeColor.withValues(
                                  alpha: 0.08,
                                ),
                                highlightColor: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 4.h,
                                    bottom: math.max(4.h, bottomPadding * 0.2),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Icon (fades out when active into the floating circle)
                                      AnimatedOpacity(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        opacity: isActive ? 0.0 : 1.0,
                                        child: AnimatedScale(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          scale: isActive ? 0.8 : 1.0,
                                          child: NavBarCustomIcon(
                                            type:
                                                item.iconType ??
                                                NavTabType.home,
                                            isActive: false,
                                            activeColor: activeColor,
                                            inactiveColor: inactiveColor,
                                            size: 23.0.r,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      // Name under each icon
                                      Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: AppStyles.fontFamily,
                                          fontSize: 10.0.sp,
                                          fontWeight: isActive
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isActive
                                              ? activeColor
                                              : inactiveColor,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onTabTap(BuildContext context, int index, String route) {
    if (_activeIndex != index) {
      setState(() {
        _activeIndex = index;
        _startingPos = _pos;
        _endingIndex = index;
      });
      _animationController.animateTo(
        index / AppBottomNav.items.length,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }

    final branchIndex = _branchRoutes.indexOf(route);
    final targetBranch = branchIndex != -1 ? branchIndex : index;
    widget.onTabSelected?.call(targetBranch);

    if (widget.navigationShell != null) {
      if (route == AppRoutes.profile) {
        try {
          context.read<ProfileCubit>().refresh();
        } catch (_) {}
      }
      if (route == AppRoutes.basket) {
        CartEventBus.instance.notifyCartUpdated();
      }
      widget.navigationShell!.goBranch(
        targetBranch,
        initialLocation: targetBranch == widget.navigationShell!.currentIndex,
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

/// Precise painter that carves out the curved dip in the bottom nav bar.
class _CurvedNavPainter extends CustomPainter {
  final double loc;
  final double s;
  final Color color;

  _CurvedNavPainter({
    required double startingLoc,
    required int itemsLength,
    required this.color,
    required TextDirection textDirection,
  }) : s = 0.2,
       loc = _computeLoc(startingLoc, itemsLength, textDirection);

  static double _computeLoc(
    double startingLoc,
    int itemsLength,
    TextDirection textDirection,
  ) {
    final span = 1.0 / itemsLength;
    const sVal = 0.2;
    final l = startingLoc + (span - sVal) / 2;
    return textDirection == TextDirection.rtl ? (1.0 - sVal) - l : l;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo((loc - 0.1) * size.width, 0)
      ..cubicTo(
        (loc + s * 0.20) * size.width,
        size.height * 0.05,
        loc * size.width,
        size.height * 0.60,
        (loc + s * 0.50) * size.width,
        size.height * 0.60,
      )
      ..cubicTo(
        (loc + s) * size.width,
        size.height * 0.60,
        (loc + s - s * 0.20) * size.width,
        size.height * 0.05,
        (loc + s + 0.1) * size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Subtle drop shadow above the top bar edge
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.06), 6.0, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedNavPainter oldDelegate) {
    return oldDelegate.loc != loc ||
        oldDelegate.s != s ||
        oldDelegate.color != color;
  }
}
