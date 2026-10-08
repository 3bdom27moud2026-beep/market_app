import 'package:flutter/material.dart';

/// A reusable [CustomPainter] that draws a subtle grid overlay.
///
/// The grid consists of thin, highly transparent lines.
/// Use it as a background decoration on any full-screen widget.
class BackgroundGridPainter extends CustomPainter {
  /// Spacing between grid lines.
  final double gridSize;

  /// Stroke width of the grid lines.
  final double strokeWidth;

  /// Color of the grid lines.
  final Color color;

  const BackgroundGridPainter({
    this.gridSize = 40,
    this.strokeWidth = 0.5,
    this.color = const Color(0x0FFFFFFF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundGridPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color;
  }
}
