import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Product background image widget with dark gradient overlays.
class PromotionImage extends StatelessWidget {
  final String imageUrl;
  final double borderRadius;

  static const LinearGradient _brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1C426C),
      Color(0xFF193A60),
      Color(0xFF163252),
      Color(0xFF132842),
      Color(0xFF101F33),
      Color(0xFF0C1624),
    ],
    stops: [0.0, 0.20, 0.40, 0.65, 0.85, 1.0],
  );

  const PromotionImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image Layer
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    placeholder: (context, url) => Container(
                      decoration: const BoxDecoration(gradient: _brandGradient),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFFEF8226),
                          strokeWidth: 2.5.w,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: const BoxDecoration(gradient: _brandGradient),
                      child: Icon(
                        Icons.fastfood_rounded,
                        size: 64.r,
                        color: context.colors.textOnPrimary.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(gradient: _brandGradient),
                    child: Icon(
                      Icons.fastfood_rounded,
                      size: 64.r,
                      color: context.colors.textOnPrimary.withValues(
                        alpha: 0.15,
                      ),
                    ),
                  ),
          ),
        ),

        // Brand gradient overlay matching banner design
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x991C426C),
                  Color(0x66163252),
                  Color(0x20132842),
                  Color(0x66101F33),
                  Color(0xCC0C1624),
                ],
                stops: [0.0, 0.25, 0.50, 0.75, 1.0],
              ),
            ),
          ),
        ),

        // Vertical vignette to ensure bottom text contrast and legibility
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x4D000000),
                  Colors.transparent,
                  Color(0x66132842),
                  Color(0xE60C1624),
                ],
                stops: [0.0, 0.25, 0.55, 0.88],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
