// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/core/constants/app_assets.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/home/domain/entities/offer_banner_entity.dart';

/// Horizontal page view slider for offer banners with animated indicator.
class OfferSlider extends StatefulWidget {
  final List<OfferBannerEntity> offers;
  final int currentIndex;
  final Function(int) onPageChanged;
  final Function(OfferBannerEntity)? onOfferTap;

  const OfferSlider({
    super.key,
    required this.offers,
    required this.currentIndex,
    required this.onPageChanged,
    this.onOfferTap,
  });

  @override
  State<OfferSlider> createState() => _OfferSliderState();
}

class _OfferSliderState extends State<OfferSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void didUpdateWidget(OfferSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex &&
        _pageController.hasClients) {
      if (_pageController.page?.round() != widget.currentIndex) {
        _pageController.animateToPage(
          widget.currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onIndicatorTap(int index) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    widget.onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200.h,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.offers.length,
              onPageChanged: widget.onPageChanged,
              itemBuilder: (context, index) {
                final offer = widget.offers[index];
                return _OfferBannerCard(
                  offer: offer,
                  onTap: () => widget.onOfferTap?.call(offer),
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.sm.h),
          _AnimatedIndicator(
            count: widget.offers.length,
            currentIndex: widget.currentIndex,
            onTap: _onIndicatorTap,
          ),
        ],
      ),
    );
  }
}

class _OfferBannerCard extends StatelessWidget {
  final OfferBannerEntity offer;
  final VoidCallback? onTap;

  const _OfferBannerCard({required this.offer, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.lg.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background image with graceful 404 fallback ────────────
            CachedNetworkImage(
              imageUrl: offer.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => const _BannerPlaceholder(),
              errorWidget: (context, url, error) => const _BannerPlaceholder(),
            ),

            // ── Gradient overlay ───────────────────────────────────────
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black54],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // ── Text & button content ──────────────────────────────────
            Padding(
              padding: EdgeInsets.all(AppSpacing.md.r),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.bottomStart,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (offer.discount.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm.w,
                          vertical: AppSpacing.xs.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.discountRed,
                          borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                        ),
                        child: Text(
                          offer.discount,
                          style: AppTextStyles.discountBadge,
                        ),
                      ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      offer.title,
                      style: AppTextStyles.whiteHeading,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      offer.subtitle,
                      style: AppTextStyles.whiteSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.accentOrange,
                        foregroundColor: context.colors.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.xl.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg.w,
                          vertical: 4.h,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        offer.buttonText.isNotEmpty
                            ? offer.buttonText
                            : 'تسوق الآن',
                        style: AppTextStyles.buttonSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const _AnimatedIndicator({
    required this.count,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
            width: isActive ? 24.w : 8.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: isActive ? context.colors.primary : context.colors.border,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        );
      }),
    );
  }
}

/// Fallback shown while a banner image is loading or when the URL returns a
/// 404 / any network error. Renders a subtle gradient so the banner area
/// never appears blank.
class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        child: Image.asset(AppAssets.placeholderImage, fit: BoxFit.cover),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primaryDark.withValues(alpha: 0.8),
            context.colors.primary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
