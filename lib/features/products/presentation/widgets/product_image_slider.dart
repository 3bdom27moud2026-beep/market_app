import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Product image slider supporting single or multiple images/thumbnails with page indicator.
class ProductImageSlider extends StatefulWidget {
  final String imageUrl;
  final List<String> images;

  const ProductImageSlider({
    super.key,
    required this.imageUrl,
    this.images = const [],
  });

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  int _currentIndex = 0;
  late final PageController _pageController;

  List<String> get _displayImages {
    if (widget.imageUrl.isNotEmpty) return [widget.imageUrl];
    if (widget.images.isNotEmpty) return [widget.images.first];
    return [];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _displayImages;

    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
        child: Container(
          color: context.colors.backgroundSecondary,
          child: Icon(
            Icons.image_outlined,
            size: 48.r,
            color: context.colors.textQuaternary,
          ),
        ),
      );
    }

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
        child: CachedNetworkImage(
          imageUrl: images.first,
          width: double.infinity,
          fit: BoxFit.cover,
          memCacheWidth: 600,
          memCacheHeight: 600,
          placeholder: (_, _) => Container(
            color: context.colors.backgroundSecondary,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.r)),
          ),
          errorWidget: (_, _, _) => Container(
            color: context.colors.backgroundSecondary,
            child: Icon(
              Icons.image_outlined,
              size: 48.r,
              color: context.colors.textQuaternary,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.lg.r),
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                width: double.infinity,
                fit: BoxFit.cover,
                memCacheWidth: 600,
                memCacheHeight: 600,
                placeholder: (_, _) => Container(
                  color: context.colors.backgroundSecondary,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2.r),
                  ),
                ),
                errorWidget: (_, _, _) => Container(
                  color: context.colors.backgroundSecondary,
                  child: Icon(
                    Icons.image_outlined,
                    size: 48.r,
                    color: context.colors.textQuaternary,
                  ),
                ),
              );
            },
          ),
        ),
        // Dots indicator if multiple images
        if (images.length > 1)
          Positioned(
            bottom: AppSpacing.sm.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isSelected = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: isSelected ? 18.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.textOnPrimary60,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
