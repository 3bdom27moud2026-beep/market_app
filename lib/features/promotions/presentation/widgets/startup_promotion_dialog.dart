import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_cubit.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_state.dart';
import 'package:market/features/promotions/domain/entities/startup_promotion_entity.dart';
import 'promotion_image.dart';
import 'promotion_discount_badge.dart';
import 'promotion_details.dart';
import 'promotion_price.dart';
import 'promotion_action_button.dart';

/// Animation durations for the promotion dialog.
class _PromotionAnimationDurations {
  static const Duration fadeIn = Duration(milliseconds: 350);
}

/// A promotional popup dialog that appears on app startup representing the Special Offer.
class StartupPromotionDialog extends StatelessWidget {
  const StartupPromotionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      StartupPromotionCubit,
      StartupPromotionState,
      (StartupPromotionEntity?, bool)
    >(
      selector: (state) => (state.promotion, state.isVisible),
      builder: (context, data) {
        final promotion = data.$1;
        final isVisible = data.$2;

        if (promotion == null || !isVisible) return const SizedBox.shrink();

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final dialogWidth = (screenWidth * 0.88).clamp(300.0, 360.0);
        final maxDialogHeight = screenHeight * 0.84;

        return Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Backdrop with blur and tap to dismiss
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        context.read<StartupPromotionCubit>().closePopup(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.68),
                      ),
                    ),
                  ),
                ),

                // Animated Dialog Content
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: _PromotionAnimationDurations.fadeIn,
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 0.85 + (0.15 * value),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      // Prevent closing when tapping inside the dialog
                      onTap: () {},
                      child: Container(
                        width: dialogWidth,
                        constraints: BoxConstraints(maxHeight: maxDialogHeight),
                        decoration: BoxDecoration(
                          color: const Color(0xFF102238),
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.50),
                              blurRadius: 28.r,
                              offset: Offset(0, 14.h),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // 1. Background image & gradient overlay
                            Positioned.fill(
                              child: PromotionImage(
                                imageUrl: promotion.image,
                                borderRadius: 24.r,
                              ),
                            ),

                            // 2. Dialog Content Body
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  left: 18.w,
                                  right: 18.w,
                                  top: 52.h,
                                  bottom: 14.h,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Visual space so product background image is prominently visible
                                    SizedBox(height: 125.h),

                                    // Middle Orange Banner: "عرض حصري لفترة محدودة!"
                                    if (promotion.description.isNotEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEF8226),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Text(
                                          promotion.description,
                                          style: TextStyle(
                                            color: context.colors.textOnPrimary,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 8.h),

                                    // Title, Brand & Merchant Details (Right-aligned)
                                    PromotionDetails(
                                      title: promotion.title,
                                      store: promotion.store,
                                      brand: promotion.brand,
                                      merchantName: promotion.merchantName,
                                    ),
                                    SizedBox(height: 8.h),

                                    // Price & Rating Section (Right-aligned)
                                    PromotionPrice(
                                      price: promotion.price,
                                      oldPrice: promotion.oldPrice,
                                      rating: promotion.rating,
                                      reviews: promotion.reviews,
                                    ),
                                    SizedBox(height: 10.h),

                                    // Stock / Urgency Callout (Right-aligned)
                                    if (promotion.stockMessage.isNotEmpty)
                                      Text(
                                        promotion.stockMessage,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: context.colors.heartGrey
                                              .withValues(alpha: 0.95),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    SizedBox(height: 14.h),

                                    // Action Button ("تسوق الآن ‹")
                                    PromotionActionButton(
                                      buttonText:
                                          promotion.buttonText.isNotEmpty
                                          ? promotion.buttonText
                                          : 'تسوق الآن',
                                      onPressed: () {
                                        context
                                            .read<StartupPromotionCubit>()
                                            .closePopup();
                                        context.push(
                                          '/product-details/${promotion.id}',
                                        );
                                      },
                                    ),
                                    SizedBox(height: 10.h),

                                    // Dismiss / Later Button ("لاحقاً")
                                    Center(
                                      child: TextButton(
                                        onPressed: () => context
                                            .read<StartupPromotionCubit>()
                                            .closePopup(),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 4.h,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'لاحقاً',
                                          style: TextStyle(
                                            color: const Color(0xFF8FA7C6),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 3. Top Badges & Controls Overlay (LTR layout for top row)
                            Positioned(
                              top: AppSpacing.md.h,
                              left: AppSpacing.md.w,
                              right: AppSpacing.md.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Discount Badge ("-51%")
                                  if (promotion.discount > 0)
                                    PromotionDiscountBadge(
                                      discount: promotion.discount,
                                    ),
                                  SizedBox(width: 100.w),
                                  // Close Button + "عرض خاص" Pill Badge
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _SpecialOfferBadge(
                                        text: promotion.specialOffer.isNotEmpty
                                            ? promotion.specialOffer
                                            : 'عرض خاص',
                                      ),
                                      SizedBox(width: 8.w),
                                      _CloseButton(
                                        onPressed: () => context
                                            .read<StartupPromotionCubit>()
                                            .closePopup(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Circular white close button widget.
class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: context.colors.textOnPrimary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.close, size: 25.r, color: const Color(0xFF1B2B48)),
        padding: EdgeInsets.zero,
        splashRadius: 16.r,
      ),
    );
  }
}

/// Special offer badge widget ("عرض خاص").
class _SpecialOfferBadge extends StatelessWidget {
  final String text;

  const _SpecialOfferBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEF8226),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: context.colors.textOnPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
