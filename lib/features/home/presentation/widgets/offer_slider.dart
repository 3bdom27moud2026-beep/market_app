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
      height: 230.h,
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A3E65),
              Color(0xFF1B3F67),
              Color(0xFF182B40),
              Color(0xFF1D2430),
              Color(0xFF45271E),
              Color(0xFF7A3617),
              Color(0xFFB04615),
              Color(0xFFEA6D1A),
            ],
            stops: [0.0, 0.18, 0.38, 0.55, 0.70, 0.82, 0.92, 1.0],
          ),
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

            // ── Gradient overlay matching banner design ────────────────
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xE61A3E65),
                    Color(0xB3182B40),
                    Color(0x661D2430),
                    Color(0x447A3617),
                    Color(0x88EA6D1A),
                  ],
                  stops: [0.20, 0.40, 0.60, 0.80, 1.0],
                ),
              ),
            ),

<<<<<<< HEAD
            // ── Text & button content ──────────────────────────────────
            //   Padding(
            //     padding: EdgeInsets.all(AppSpacing.md.r),
            //     child: FittedBox(
            //       fit: BoxFit.scaleDown,
            //       alignment: AlignmentDirectional.bottomStart,
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children: [
            //           if (offer.discount.isNotEmpty)
            //             Container(
            //               padding: EdgeInsets.symmetric(
            //                 horizontal: AppSpacing.sm.w,
            //                 vertical: AppSpacing.xs.h,
            //               ),
            //               decoration: BoxDecoration(
            //                 color: context.colors.discountRed,
            //                 borderRadius: BorderRadius.circular(AppSpacing.xs.r),
            //               ),
            //               child: Text(
            //                 offer.discount,
            //                 style: AppTextStyles.discountBadge,
            //               ),
            //             ),
            //           SizedBox(height: AppSpacing.xs.h),
            //           Text(
            //             offer.title,
            //             style: AppTextStyles.whiteHeading,
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //           SizedBox(height: AppSpacing.xs.h),
            //           Text(
            //             offer.subtitle,
            //             style: AppTextStyles.whiteSmall,
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //           SizedBox(height: AppSpacing.xs.h),
            //           ElevatedButton(
            //             onPressed: onTap,
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: context.colors.accentOrange,
            //               foregroundColor: context.colors.textOnPrimary,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(AppSpacing.xl.r),
            //               ),
            //               padding: EdgeInsets.symmetric(
            //                 horizontal: AppSpacing.lg.w,
            //                 vertical: 4.h,
            //               ),
            //               visualDensity: VisualDensity.compact,
            //             ),
            //             child: Text(
            //               offer.buttonText.isNotEmpty
            //                   ? offer.buttonText
            //                   : 'تسوق الآن',
            //               style: AppTextStyles.buttonSmall,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
=======
            // ── Text & button content positioned on the left ──────────
            Positioned(
              left: 18.w,
              top: 30.h,
              bottom: 14.h,
              width: 300.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (offer.discount.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 4.h),
                      padding: EdgeInsets.symmetric(
                        // horizontal: AppSpacing.sm.w,
                        vertical: 2.h,
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
                  SizedBox(height: 12.h),
                  Text(
                    offer.title,
                    style: AppTextStyles.whiteHeading.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    offer.subtitle,
                    style: AppTextStyles.whiteSmall.copyWith(
                      color: Colors.white,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.accentOrange,
                        foregroundColor: context.colors.textOnPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md.w,
                          vertical: 20.h,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 16.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              offer.buttonText.isNotEmpty
                                  ? offer.buttonText
                                  : 'تسوق الآن',
                              style: AppTextStyles.buttonSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
>>>>>>> b6fa6321f2dd520aaf5d36db3c607f68bb5947b1
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A3E65),
            Color(0xFF1B3F67),
            Color(0xFF182B40),
            Color(0xFF1D2430),
            Color(0xFF45271E),
            Color(0xFF7A3617),
            Color(0xFFB04615),
            Color(0xFFEA6D1A),
          ],
          stops: [0.0, 0.18, 0.38, 0.55, 0.70, 0.82, 0.92, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Ambient radial orange glow on the right ────────────────
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.85, 0.45),
                radius: 0.85,
                colors: [
                  Color(0x66EA6D1A),
                  Color(0x22B04615),
                  Colors.transparent,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Card and % graphics floating on the right side ─────────
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.48,
              child: Image.asset(
                AppAssets.placeholderImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
