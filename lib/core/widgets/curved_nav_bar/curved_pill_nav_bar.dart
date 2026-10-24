import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'nav_bar_custom_icons.dart';

/// Item data model for the curved pill navigation bar.
class CurvedNavBarItemData {
  /// Custom vector icon type from [NavTabType] (optional).
  final NavTabType? iconType;

  /// Standard Flutter IconData for inactive state (optional).
  final IconData? icon;

  /// Standard Flutter IconData for active state (optional).
  final IconData? activeIcon;

  /// Custom builder for SVGs or advanced widgets (optional).
  final Widget Function(
    BuildContext context,
    bool isActive,
    Color activeColor,
    Color inactiveColor,
  )?
  customIconBuilder;

  final String label;
  final String route;

  const CurvedNavBarItemData({
    this.iconType,
    this.icon,
    this.activeIcon,
    this.customIconBuilder,
    required this.label,
    required this.route,
  });
}

/// A custom floating pill bottom navigation bar with an animated convex curve (bump)
/// and floating indicator dot above the active tab, matching the screenshot 1:1.
class CurvedPillNavBar extends StatefulWidget {
  final int currentIndex;
  final List<CurvedNavBarItemData> items;
  final ValueChanged<int> onTap;
  final Color? barBackgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  const CurvedPillNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.barBackgroundColor,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<CurvedPillNavBar> createState() => _CurvedPillNavBarState();
}

class _CurvedPillNavBarState extends State<CurvedPillNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentFraction = 0.0;
  double _targetFraction = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _currentFraction = _indexToFraction(widget.currentIndex);
    _targetFraction = _currentFraction;

    _animation = Tween<double>(begin: _currentFraction, end: _targetFraction)
        .animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

    _controller.addListener(() {
      setState(() {
        _currentFraction = _animation.value;
      });
    });
  }

  @override
  void didUpdateWidget(covariant CurvedPillNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animateTo(widget.currentIndex);
    }
  }

  double _indexToFraction(int index) {
    if (widget.items.isEmpty) return 0.5;
    // Fractions are centered on each tab:
    // Tab 0 -> (0 + 0.5) / length
    return (index + 0.5) / widget.items.length;
  }

  void _animateTo(int index) {
    _targetFraction = _indexToFraction(index);
    _animation = Tween<double>(begin: _currentFraction, end: _targetFraction)
        .animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
        widget.barBackgroundColor ??
        (isDark ? const Color(0xFF1E2838) : Colors.white);
    final activeCol =
        widget.activeColor ??
        (isDark ? const Color(0xFFEF8226) : const Color(0xFFEF8226));
    final inactiveCol =
        widget.inactiveColor ??
        (isDark ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93));

    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final double barHeight = 66.0.h;
    final double waveHeight = 11.0.h;
    final double dotRadius = 3.2.r;

    return Directionality(
      // Ensure RTL alignment so Tab 0 is on the far right
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(
            left: 14.0.w,
            right: 14.0.w,
            bottom: math.max(6.0.h, bottomPadding > 0 ? 4.0.h : 8.0.h),
            top: waveHeight + 6.0.h, // extra headroom for the bump and dot
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final isRtl = Directionality.of(context) == TextDirection.rtl;

              // Compute X coordinate for the active bump
              // In RTL, index 0 is at the right edge
              final activeFraction = isRtl
                  ? (1.0 - _currentFraction)
                  : _currentFraction;
              final activeX = barWidth * activeFraction;

              return SizedBox(
                width: barWidth,
                height: barHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. Custom Painted Pill with Smooth Convex Wave and Shadow
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _CurvedPillPainter(
                          activeX: activeX,
                          waveHeight: waveHeight,
                          waveWidth: barWidth / widget.items.length * 0.9,
                          pillRadius: 28.0.r,
                          backgroundColor: bgColor,
                          shadowColor: isDark
                              ? Colors.black.withValues(alpha: 0.45)
                              : const Color(0xFF0F1E36).withValues(alpha: 0.10),
                        ),
                      ),
                    ),

                    // 2. Animated Indicator Dot on top of the bump
                    Positioned(
                      left: activeX - dotRadius,
                      top: -(waveHeight + dotRadius + 3.0.h),
                      child: Container(
                        width: dotRadius * 2,
                        height: dotRadius * 2,
                        decoration: BoxDecoration(
                          color: activeCol,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeCol.withValues(alpha: 0.35),
                              blurRadius: 4.r,
                              offset: Offset(0, 1.h),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. Tab Items Row
                    Positioned.fill(
                      child: Row(
                        children: List.generate(widget.items.length, (index) {
                          final item = widget.items[index];
                          final isActive = index == widget.currentIndex;

                          return Expanded(
                            child: _NavBarTabButton(
                              item: item,
                              isActive: isActive,
                              activeColor: activeCol,
                              inactiveColor: inactiveCol,
                              onTap: () => widget.onTap(index),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A single tab button in the navigation bar.
class _NavBarTabButton extends StatelessWidget {
  final CurvedNavBarItemData item;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavBarTabButton({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: activeColor.withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            AnimatedScale(
              scale: isActive ? 1.05 : 0.95,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: _buildIcon(context),
            ),
            SizedBox(height: 3.h),
            // Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 10.0.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
                height: 1.1,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (item.customIconBuilder != null) {
      return item.customIconBuilder!(
        context,
        isActive,
        activeColor,
        inactiveColor,
      );
    }
    if (item.icon != null) {
      return Icon(
        isActive ? (item.activeIcon ?? item.icon) : item.icon,
        color: isActive ? activeColor : inactiveColor,
        size: 26.0.r,
      );
    }
    if (item.iconType != null) {
      return NavBarCustomIcon(
        type: item.iconType!,
        isActive: isActive,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        size: 26.0.r,
      );
    }
    return SizedBox(width: 26.0.r, height: 26.0.r);
  }
}

/// CustomPainter that renders the pill shape with a smooth upward convex wave (bump)
/// and soft drop-shadow.
class _CurvedPillPainter extends CustomPainter {
  final double activeX;
  final double waveHeight;
  final double waveWidth;
  final double pillRadius;
  final Color backgroundColor;
  final Color shadowColor;

  _CurvedPillPainter({
    required this.activeX,
    required this.waveHeight,
    required this.waveWidth,
    required this.pillRadius,
    required this.backgroundColor,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = math.min(pillRadius, h / 2);

    final path = Path();

    // Start at top-left, after the top-left rounded corner
    path.moveTo(r, 0);

    // Wave bounds around activeX
    final halfWave = waveWidth / 2;
    final waveStart = math.max(r, activeX - halfWave);
    final waveEnd = math.min(w - r, activeX + halfWave);

    // Line from top-left corner to start of wave
    if (waveStart > r) {
      path.lineTo(waveStart, 0);
    }

    // Smooth Bezier upward wave (Convex bump)
    if (waveEnd > waveStart) {
      final actualPeakX = activeX.clamp(r + 10, w - r - 10);
      final cp1X = waveStart + (actualPeakX - waveStart) * 0.45;
      final cp2X = actualPeakX - (actualPeakX - waveStart) * 0.45;
      final cp3X = actualPeakX + (waveEnd - actualPeakX) * 0.45;
      final cp4X = waveEnd - (waveEnd - actualPeakX) * 0.45;

      // Left half of bump: rises to (actualPeakX, -waveHeight)
      path.cubicTo(cp1X, 0, cp2X, -waveHeight, actualPeakX, -waveHeight);

      // Right half of bump: descends back to (waveEnd, 0)
      path.cubicTo(cp3X, -waveHeight, cp4X, 0, waveEnd, 0);
    }

    // Line from end of wave to top-right corner
    path.lineTo(w - r, 0);

    // Top-right corner
    path.quadraticBezierTo(w, 0, w, r);

    // Right side
    path.lineTo(w, h - r);

    // Bottom-right corner
    path.quadraticBezierTo(w, h, w - r, h);

    // Bottom edge
    path.lineTo(r, h);

    // Bottom-left corner
    path.quadraticBezierTo(0, h, 0, h - r);

    // Left side
    path.lineTo(0, r);

    // Top-left corner
    path.quadraticBezierTo(0, 0, r, 0);

    path.close();

    // 1. Draw smooth soft shadow
    canvas.drawShadow(path, shadowColor, 12.0, false);
    // Extra soft ambient shadow
    final ambientShadowPaint = Paint()
      ..color = shadowColor.withValues(alpha: shadowColor.a * 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, ambientShadowPaint);

    // 2. Draw solid pill body
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _CurvedPillPainter oldDelegate) {
    return oldDelegate.activeX != activeX ||
        oldDelegate.waveHeight != waveHeight ||
        oldDelegate.waveWidth != waveWidth ||
        oldDelegate.pillRadius != pillRadius ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.shadowColor != shadowColor;
  }
}
