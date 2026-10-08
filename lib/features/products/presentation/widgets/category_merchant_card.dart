import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';

/// Merchant card widget matching the visual design mockup.
class CategoryMerchantCard extends StatelessWidget {
  final MerchantEntity merchant;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const CategoryMerchantCard({
    super.key,
    required this.merchant,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final discountText = merchant.discount.isNotEmpty
        ? (merchant.discount.contains('خصم')
              ? merchant.discount
              : 'خصم ${merchant.discount}')
        : null;

    final ratingVal = merchant.rating > 0
        ? merchant.rating.toStringAsFixed(1)
        : '4.8';

    final distanceVal = merchant.distance.isNotEmpty
        ? merchant.distance
        : '1.0 كم';

    final addressText = merchant.address.isNotEmpty
        ? merchant.address
        : (merchant.area?.name ?? 'القاهرة، مصر');

    final categoryName = merchant.category?.name ?? 'سوبر ماركت';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => context.push('/merchant-details/${merchant.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: context.colors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Image Section with Badges & Avatar ─────────────────────────
              SizedBox(
                height: 120.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Store Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: merchant.image,
                        width: double.infinity,
                        height: 120.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: context.colors.backgroundSecondary,
                          child: Center(
                            child: SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFEF8226),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: context.colors.backgroundSecondary,
                          child: Center(
                            child: Icon(
                              Icons.storefront_rounded,
                              color: context.colors.textQuaternary,
                              size: 40.r,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Discount Badge (Top Right in RTL = right)
                    if (discountText != null)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF8226),
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            discountText,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Favorite Button (Top Left in RTL = left)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFavorite
                                  ? const Color(0xFFEF8226)
                                  : Colors.white,
                              size: 17.r,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Overlapping Shopping Bag Avatar
                    Positioned(
                      bottom: -18.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.colors.primary.withValues(
                                alpha: 0.2,
                              ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.3 : 0.08,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: context.colors.accentOrange,
                              size: 20.r,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Details Section ───────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Store Name + Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              merchant.name,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                                color: context.colors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF8226),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      // Category Subtitle
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),

                      // Address with Pin Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.r,
                            color: context.colors.textSecondary,
                          ),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              addressText,
                              style: TextStyle(
                                fontFamily: AppTextStyles.fontFamily,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: context.colors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      // Rating & Distance Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 14.r,
                            color: const Color(0xFFFFB800),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            ratingVal,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFEF8226),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            distanceVal,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // "عرض المتجر" Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 34.h,
                        child: TextButton(
                          onPressed: () =>
                              context.push('/merchant-details/${merchant.id}'),
                          style: TextButton.styleFrom(
                            backgroundColor: context.colors.accentOrange
                                .withValues(alpha: 0.15),
                            foregroundColor: context.colors.accentOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'عرض المتجر',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              color: context.colors.accentOrange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
