import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Product background image widget with dark gradient overlays.
class PromotionImage extends StatelessWidget {
  final String imageUrl;
  final double borderRadius;

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
                      color: const Color(0xFF102238),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFFEF8226),
                          strokeWidth: 2.5.w,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF102238),
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
                    color: const Color(0xFF102238),
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

        // Dark gradient vignette overlay to merge image with card background & ensure readable text
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                  const Color(0xFF102238).withValues(alpha: 0.75),
                  const Color(0xFF102238),
                ],
                stops: const [0.0, 0.28, 0.58, 0.85],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
