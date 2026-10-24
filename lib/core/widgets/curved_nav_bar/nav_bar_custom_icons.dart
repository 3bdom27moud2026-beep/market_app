import 'package:flutter/material.dart';

/// Enum representing the 5 navigation tabs matching user specification:
/// 1. home (الرئيسية)
/// 2. categories (الفئات)
/// 3. account (الحساب)
/// 4. favorites (المفضلة)
/// 5. cart (السلة)
enum NavTabType {
  home,
  categories,
  account,
  favorites,
  cart,
  // Backward compatibility aliases
  orders,
  points,
  profile,
}

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
    if (type == NavTabType.favorites) {
      return Icon(
        isActive ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isActive ? activeColor : inactiveColor,
        size: size,
      );
    }
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
      case NavTabType.categories:
        _paintCategories(canvas, w, h);
        break;
      case NavTabType.account:
      case NavTabType.profile:
        _paintAccount(canvas, w, h);
        break;
      case NavTabType.favorites:
        _paintFavorites(canvas, w, h);
        break;
      case NavTabType.cart:
        _paintCart(canvas, w, h);
        break;
      case NavTabType.orders:
        _paintOrders(canvas, w, h);
        break;
      case NavTabType.points:
        _paintPoints(canvas, w, h);
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
  // 2. CATEGORIES (الفئات)
  // 2x2 rounded squares grid with bottom-right magnifying glass.
  // Inactive: Grey outline. Active: Filled orange.
  // ─────────────────────────────────────────────────────────────
  void _paintCategories(Canvas canvas, double w, double h) {
    final strokePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    const r = 3.5;
    // Top-Left Square
    final tlRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.15, w * 0.31, h * 0.31),
      const Radius.circular(r),
    );
    // Top-Right Square
    final trRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.54, h * 0.15, w * 0.31, h * 0.31),
      const Radius.circular(r),
    );
    // Bottom-Left Square
    final blRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.54, w * 0.31, h * 0.31),
      const Radius.circular(r),
    );
    // Bottom-Right: Magnifying Glass
    final magCenter = Offset(w * 0.67, h * 0.67);
    final magRadius = w * 0.13;
    final handleStart = Offset(w * 0.76, h * 0.76);
    final handleEnd = Offset(w * 0.88, h * 0.88);

    if (isActive) {
      canvas.drawRRect(tlRect, fillPaint);
      canvas.drawRRect(trRect, fillPaint);
      canvas.drawRRect(blRect, fillPaint);
      canvas.drawCircle(magCenter, magRadius, fillPaint);
      final handlePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.8
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(handleStart, handleEnd, handlePaint);
    } else {
      canvas.drawRRect(tlRect, strokePaint);
      canvas.drawRRect(trRect, strokePaint);
      canvas.drawRRect(blRect, strokePaint);
      canvas.drawCircle(magCenter, magRadius, strokePaint);
      final handlePaint = Paint()
        ..color = inactiveColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(handleStart, handleEnd, handlePaint);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 3. ACCOUNT (الحساب)
  // Bust with head, shoulders, and bottom-right checkmark badge.
  // Inactive: Grey outline. Active: Filled orange with white checkmark.
  // ─────────────────────────────────────────────────────────────
  void _paintAccount(Canvas canvas, double w, double h) {
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
    final headCenter = Offset(w * 0.44, h * 0.28);
    final headRadius = w * 0.17;

    // Torso
    final torsoPath = Path();
    final leftShoulder = Offset(w * 0.14, h * 0.84);
    final rightShoulder = Offset(w * 0.74, h * 0.84);

    torsoPath.moveTo(leftShoulder.dx, leftShoulder.dy);
    torsoPath.cubicTo(
      w * 0.14,
      h * 0.54,
      w * 0.74,
      h * 0.54,
      rightShoulder.dx,
      rightShoulder.dy,
    );
    torsoPath.close();

    // Badge on bottom-right of torso
    final badgeCenter = Offset(w * 0.72, h * 0.72);
    final badgeRadius = w * 0.15;

    if (isActive) {
      canvas.drawCircle(headCenter, headRadius, fillPaint);
      canvas.drawPath(torsoPath, fillPaint);

      // Badge circle in orange
      canvas.drawCircle(badgeCenter, badgeRadius, fillPaint);

      // White checkmark
      final checkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final checkPath = Path()
        ..moveTo(badgeCenter.dx - 3.2, badgeCenter.dy)
        ..lineTo(badgeCenter.dx - 0.8, badgeCenter.dy + 2.5)
        ..lineTo(badgeCenter.dx + 3.2, badgeCenter.dy - 2.5);
      canvas.drawPath(checkPath, checkPaint);
    } else {
      canvas.drawCircle(headCenter, headRadius, strokePaint);
      canvas.drawPath(torsoPath, strokePaint);

      // Mask circle behind badge so torso line doesn't cut through
      final bgPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(badgeCenter, badgeRadius, bgPaint);
      canvas.drawCircle(badgeCenter, badgeRadius, strokePaint);

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
  }

  // ─────────────────────────────────────────────────────────────
  // 4. FAVORITES (المفضلة)
  // Symmetrical heart matching screenshot.
  // Inactive: Grey outline. Active: Filled orange.
  // ─────────────────────────────────────────────────────────────
  void _paintFavorites(Canvas canvas, double w, double h) {
    final strokePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final bottomPoint = Offset(w * 0.5, h * 0.86);
    final topCenter = Offset(w * 0.5, h * 0.36);

    path.moveTo(bottomPoint.dx, bottomPoint.dy);
    // Left half of heart
    path.cubicTo(
      w * 0.12, h * 0.60,
      w * 0.12, h * 0.18,
      w * 0.32, h * 0.18,
    );
    path.cubicTo(
      w * 0.42, h * 0.18,
      w * 0.48, h * 0.26,
      topCenter.dx, topCenter.dy,
    );
    // Right half of heart
    path.cubicTo(
      w * 0.52, h * 0.26,
      w * 0.58, h * 0.18,
      w * 0.68, h * 0.18,
    );
    path.cubicTo(
      w * 0.88, h * 0.18,
      w * 0.88, h * 0.60,
      bottomPoint.dx, bottomPoint.dy,
    );
    path.close();

    if (isActive) {
      canvas.drawPath(path, fillPaint);
    } else {
      canvas.drawPath(path, strokePaint);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 5. CART (السلة)
  // Shopping cart with 3 motion speed lines on the left.
  // Inactive: Grey outline. Active: Filled orange basket with speed lines.
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

    // 3 Speed / Motion lines on the left
    final linePaint = Paint()
      ..color = isActive ? activeColor : inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(w * 0.08, h * 0.32), Offset(w * 0.20, h * 0.32), linePaint);
    canvas.drawLine(Offset(w * 0.04, h * 0.44), Offset(w * 0.23, h * 0.44), linePaint);
    canvas.drawLine(Offset(w * 0.08, h * 0.56), Offset(w * 0.20, h * 0.56), linePaint);

    // Cart body
    final pHandle = Offset(w * 0.26, h * 0.22);
    final pTurn = Offset(w * 0.34, h * 0.22);
    final pRearBottom = Offset(w * 0.40, h * 0.62);
    final pFrontBottom = Offset(w * 0.80, h * 0.62);
    final pFrontTop = Offset(w * 0.88, h * 0.32);
    final pRearTop = Offset(w * 0.37, h * 0.32);

    final basketPath = Path()
      ..moveTo(pRearTop.dx, pRearTop.dy)
      ..lineTo(pFrontTop.dx, pFrontTop.dy)
      ..lineTo(pFrontBottom.dx, pFrontBottom.dy)
      ..lineTo(pRearBottom.dx, pRearBottom.dy)
      ..close();

    final framePath = Path()
      ..moveTo(pHandle.dx, pHandle.dy)
      ..lineTo(pTurn.dx, pTurn.dy)
      ..lineTo(pRearBottom.dx, pRearBottom.dy)
      ..lineTo(pFrontBottom.dx, pFrontBottom.dy)
      ..lineTo(pFrontTop.dx, pFrontTop.dy);

    // Wheels
    final wheelRadius = w * 0.07;
    final wheelY = h * 0.77;
    final wheel1 = Offset(w * 0.46, wheelY);
    final wheel2 = Offset(w * 0.74, wheelY);

    if (isActive) {
      canvas.drawPath(basketPath, fillPaint);
      canvas.drawPath(framePath, strokePaint);
      canvas.drawCircle(wheel1, wheelRadius, fillPaint);
      canvas.drawCircle(wheel2, wheelRadius, fillPaint);
    } else {
      canvas.drawPath(framePath, strokePaint);
      canvas.drawLine(Offset(pRearTop.dx, pRearTop.dy), Offset(pFrontTop.dx, pFrontTop.dy), strokePaint);
      canvas.drawCircle(wheel1, wheelRadius, strokePaint);
      canvas.drawCircle(wheel2, wheelRadius, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NavIconPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.isActive != isActive ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
