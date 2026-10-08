import 'package:flutter/material.dart';

/// Enum representing the 5 navigation tabs.
enum NavTabType { home, orders, points, profile, cart }

/// A dedicated widget that renders one of the 5 custom navigation icons
/// exactly as styled in the screenshot, supporting both active and inactive states.
class NavBarCustomIcon extends StatelessWidget {
  final NavTabType type;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final double size;

  const NavBarCustomIcon({
    super.key,
    required this.type,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    this.size = 28.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavIconPainter(
          type: type,
          isActive: isActive,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        ),
      ),
    );
  }
}

class _NavIconPainter extends CustomPainter {
  final NavTabType type;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  _NavIconPainter({
    required this.type,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (type) {
      case NavTabType.home:
        _paintHome(canvas, w, h);
        break;
      case NavTabType.orders:
        _paintOrders(canvas, w, h);
        break;
      case NavTabType.points:
        _paintPoints(canvas, w, h);
        break;
      case NavTabType.profile:
        _paintProfile(canvas, w, h);
        break;
      case NavTabType.cart:
        _paintCart(canvas, w, h);
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 1. HOME (الرئيسية)
  // House / dome shape with rounded peak, vertical walls, flat base.
  // Inactive: Navy outline. Active: Filled orange with rounded corners.
  // ─────────────────────────────────────────────────────────────
  void _paintHome(Canvas canvas, double w, double h) {
    final strokePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    // Outer boundary of the dome house
    final path = Path();
    final left = w * 0.16;
    final right = w * 0.84;
    final bottom = h * 0.86;
    final eaveY = h * 0.44;
    final apexY = h * 0.14;
    final apexX = w * 0.5;
    const r = 4.0;

    path.moveTo(left, eaveY);
    // Roof to apex with rounded corner
    path.lineTo(apexX - 3, apexY + 2);
    path.quadraticBezierTo(apexX, apexY, apexX + 3, apexY + 2);
    path.lineTo(right, eaveY);
    // Right wall
    path.lineTo(right, bottom - r);
    path.quadraticBezierTo(right, bottom, right - r, bottom);
    // Bottom wall
    path.lineTo(left + r, bottom);
    path.quadraticBezierTo(left, bottom, left, bottom - r);
    // Left wall
    path.close();

    if (isActive) {
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    } else {
      canvas.drawPath(path, strokePaint);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 2. ORDERS (طلباتي)
  // Open 3D isometric parcel box with flaps.
  // Inactive: Navy outline. Active: Filled with orange shading + navy lines.
  // ─────────────────────────────────────────────────────────────
  void _paintOrders(Canvas canvas, double w, double h) {
    final strokePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final darkOutlinePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaintPrimary = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final fillPaintSecondary = Paint()
      ..color = Color.lerp(activeColor, Colors.black, 0.12)!
      ..style = PaintingStyle.fill;

    final fillPaintLighter = Paint()
      ..color = Color.lerp(activeColor, Colors.white, 0.25)!
      ..style = PaintingStyle.fill;

    // Key points of the isometric box
    final centerX = w * 0.5;
    final topCenterY = h * 0.38;
    final bottomCenterY = h * 0.86;
    final leftX = w * 0.15;
    final rightX = w * 0.85;
    final midLeftY = h * 0.50;
    final midRightY = h * 0.50;
    final bottomLeftY = h * 0.74;
    final bottomRightY = h * 0.74;

    // Flap top vertices
    final flapTopLeft = Offset(w * 0.22, h * 0.20);
    final flapTopRight = Offset(w * 0.78, h * 0.20);
    final flapTopCenter = Offset(centerX, h * 0.26);

    if (isActive) {
      // Draw left face
      final leftFace = Path()
        ..moveTo(centerX, topCenterY)
        ..lineTo(leftX, midLeftY)
        ..lineTo(leftX, bottomLeftY)
        ..lineTo(centerX, bottomCenterY)
        ..close();
      canvas.drawPath(leftFace, fillPaintPrimary);

      // Draw right face
      final rightFace = Path()
        ..moveTo(centerX, topCenterY)
        ..lineTo(rightX, midRightY)
        ..lineTo(rightX, bottomRightY)
        ..lineTo(centerX, bottomCenterY)
        ..close();
      canvas.drawPath(rightFace, fillPaintSecondary);

      // Draw open flaps
      final leftFlap = Path()
        ..moveTo(leftX, midLeftY)
        ..lineTo(flapTopLeft.dx, flapTopLeft.dy)
        ..lineTo(centerX, topCenterY)
        ..close();
      canvas.drawPath(leftFlap, fillPaintLighter);

      final rightFlap = Path()
        ..moveTo(rightX, midRightY)
        ..lineTo(flapTopRight.dx, flapTopRight.dy)
        ..lineTo(centerX, topCenterY)
        ..close();
      canvas.drawPath(rightFlap, fillPaintLighter);
    }

    // Outlines
    final activeStroke = isActive ? darkOutlinePaint : strokePaint;

    // Lower box body outline
    final boxBody = Path()
      ..moveTo(leftX, midLeftY)
      ..lineTo(leftX, bottomLeftY)
      ..lineTo(centerX, bottomCenterY)
      ..lineTo(rightX, bottomRightY)
      ..lineTo(rightX, midRightY);
    canvas.drawPath(boxBody, activeStroke);

    // Center vertical seam
    canvas.drawLine(
      Offset(centerX, topCenterY),
      Offset(centerX, bottomCenterY),
      activeStroke,
    );

    // Left flap
    final flapPathLeft = Path()
      ..moveTo(leftX, midLeftY)
      ..lineTo(flapTopLeft.dx, flapTopLeft.dy)
      ..lineTo(centerX, topCenterY);
    canvas.drawPath(flapPathLeft, activeStroke);

    // Right flap
    final flapPathRight = Path()
      ..moveTo(rightX, midRightY)
      ..lineTo(flapTopRight.dx, flapTopRight.dy)
      ..lineTo(centerX, topCenterY);
    canvas.drawPath(flapPathRight, activeStroke);

    // Back flap hint
    final backFlap = Path()
      ..moveTo(flapTopLeft.dx, flapTopLeft.dy)
      ..lineTo(flapTopCenter.dx, flapTopCenter.dy)
      ..lineTo(flapTopRight.dx, flapTopRight.dy);
    canvas.drawPath(backFlap, activeStroke);
  }

  // ─────────────────────────────────────────────────────────────
  // 3. POINTS (نقاطي)
  // Wallet / card pouch with downward arrow.
  // Inactive: Navy outline. Active: Orange filled pouch with downward arrow.
  // ─────────────────────────────────────────────────────────────
  void _paintPoints(Canvas canvas, double w, double h) {
    final strokePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    // Wallet body dimensions
    final left = w * 0.18;
    final right = w * 0.82;
    final top = h * 0.36;
    final bottom = h * 0.86;
    const r = 5.0;

    final walletPath = Path();
    // Top slit: starts at arrow entrance
    walletPath.moveTo(left, top);
    walletPath.lineTo(w * 0.62, top);
    // Inner dip / slot
    walletPath.lineTo(w * 0.62, top + 6);
    walletPath.lineTo(right, top + 6);
    // Right side
    walletPath.lineTo(right, bottom - r);
    walletPath.quadraticBezierTo(right, bottom, right - r, bottom);
    // Bottom
    walletPath.lineTo(left + r, bottom);
    walletPath.quadraticBezierTo(left, bottom, left, bottom - r);
    // Left side
    walletPath.close();

    if (isActive) {
      canvas.drawPath(walletPath, fillPaint);
      final darkStroke = Paint()
        ..color = inactiveColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(walletPath, darkStroke);
    } else {
      canvas.drawPath(walletPath, strokePaint);
    }

    // Downward arrow entering the top
    final arrowPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final arrowX = w * 0.74;
    final arrowTopY = h * 0.16;
    final arrowBottomY = h * 0.44;

    // Vertical shaft
    canvas.drawLine(
      Offset(arrowX, arrowTopY),
      Offset(arrowX, arrowBottomY),
      arrowPaint,
    );

    // Arrowhead pointing down
    final arrowHead = Path()
      ..moveTo(arrowX - 4, arrowBottomY - 4)
      ..lineTo(arrowX, arrowBottomY)
      ..lineTo(arrowX + 4, arrowBottomY - 4);
    canvas.drawPath(arrowHead, arrowPaint);
  }

  // ─────────────────────────────────────────────────────────────
  // 4. PROFILE (حسابي)
  // Bust with head, shoulders, and bottom-right checkmark badge.
  // Inactive: Navy outline. Active: Filled orange with badge.
  // ─────────────────────────────────────────────────────────────
  void _paintProfile(Canvas canvas, double w, double h) {
    final strokePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    // Head
    final headCenter = Offset(w * 0.46, h * 0.28);
    final headRadius = w * 0.17;

    if (isActive) {
      canvas.drawCircle(headCenter, headRadius, fillPaint);
      canvas.drawCircle(headCenter, headRadius, strokePaint);
    } else {
      canvas.drawCircle(headCenter, headRadius, strokePaint);
    }

    // Shoulders / Torso
    final torsoPath = Path();
    final leftShoulder = Offset(w * 0.16, h * 0.84);
    final rightShoulder = Offset(w * 0.76, h * 0.84);

    torsoPath.moveTo(leftShoulder.dx, leftShoulder.dy);
    torsoPath.cubicTo(
      w * 0.16,
      h * 0.54,
      w * 0.76,
      h * 0.54,
      rightShoulder.dx,
      rightShoulder.dy,
    );
    torsoPath.close();

    if (isActive) {
      canvas.drawPath(torsoPath, fillPaint);
      canvas.drawPath(torsoPath, strokePaint);
    } else {
      canvas.drawPath(torsoPath, strokePaint);
    }

    // Bottom-right badge with checkmark
    final badgeCenter = Offset(w * 0.72, h * 0.72);
    final badgeRadius = w * 0.15;

    // Background circle for badge to cleanly overlap shoulder
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(badgeCenter, badgeRadius, bgPaint);

    final badgeStrokePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawCircle(badgeCenter, badgeRadius, badgeStrokePaint);

    // Checkmark inside badge
    final checkPaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path()
      ..moveTo(badgeCenter.dx - 3.2, badgeCenter.dy)
      ..lineTo(badgeCenter.dx - 0.8, badgeCenter.dy + 2.5)
      ..lineTo(badgeCenter.dx + 3.2, badgeCenter.dy - 2.5);
    canvas.drawPath(checkPath, checkPaint);
  }

  // ─────────────────────────────────────────────────────────────
  // 5. CART (سلتي)
  // Shopping cart with angled handle, basket body, and two wheels.
  // Inactive: Navy outline. Active: Filled orange basket with wheels.
  // ─────────────────────────────────────────────────────────────
  void _paintCart(Canvas canvas, double w, double h) {
    final strokePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    // Cart basket polygon
    final p0 = Offset(w * 0.14, h * 0.22); // Handle start
    final p1 = Offset(w * 0.26, h * 0.22); // Handle bend
    final p2 = Offset(w * 0.33, h * 0.60); // Basket rear bottom
    final p3 = Offset(w * 0.78, h * 0.60); // Basket front bottom
    final p4 = Offset(w * 0.86, h * 0.32); // Basket front top
    final p5 = Offset(w * 0.30, h * 0.32); // Basket rear top

    // Basket body path (for fill)
    final bodyPath = Path()
      ..moveTo(p5.dx, p5.dy)
      ..lineTo(p4.dx, p4.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p2.dx, p2.dy)
      ..close();

    if (isActive) {
      canvas.drawPath(bodyPath, fillPaint);
      final darkStroke = Paint()
        ..color = inactiveColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(bodyPath, darkStroke);
    }

    // Outer cart frame line: handle -> rear -> bottom -> front
    final framePath = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy);
    canvas.drawPath(framePath, strokePaint);

    // Horizontal grill wire line
    final wireY = h * 0.46;
    final wireLeft = w * 0.31;
    final wireRight = w * 0.82;
    canvas.drawLine(
      Offset(wireLeft, wireY),
      Offset(wireRight, wireY),
      isActive
          ? (Paint()
              ..color = inactiveColor
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5)
          : strokePaint,
    );

    // Two small wheels at bottom
    final wheelRadius = w * 0.07;
    final wheelY = h * 0.77;
    final wheel1Center = Offset(w * 0.40, wheelY);
    final wheel2Center = Offset(w * 0.72, wheelY);

    final wheelPaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.fill;

    final wheelBorder = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(wheel1Center, wheelRadius, wheelPaint);
    canvas.drawCircle(wheel1Center, wheelRadius, wheelBorder);
    canvas.drawCircle(wheel2Center, wheelRadius, wheelPaint);
    canvas.drawCircle(wheel2Center, wheelRadius, wheelBorder);
  }

  @override
  bool shouldRepaint(covariant _NavIconPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.isActive != isActive ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
