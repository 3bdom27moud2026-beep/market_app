import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_assets.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';

/// Top category header banner matching the visual design.
///
/// Contains:
/// - Back navigation button at the top right
/// - Category title
/// - Subtitle "اكتشف أفضل التجار والخدمات في مصر"
/// - Storefront background graphic on the left
class CategoryHeaderBanner extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onBack;

  const CategoryHeaderBanner({
    super.key,
    required this.categoryName,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDark
              ? context.colors.backgroundSecondary
              : const Color(0xFFF8FAFD),
          image: DecorationImage(
            image: const AssetImage(AppAssets.categoriesBackground),
            fit: BoxFit.cover,
            alignment: Alignment.centerLeft,
            colorFilter: isDark
                ? ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.6),
                    BlendMode.darken,
                  )
                : null,
          ),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Navigation Row: Back Button on right, Cart Badge on left
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBackButton(onPressed: onBack),
                    const CartBadgeButton(),
                  ],
                ),

                const SizedBox(height: 20),

                // Title and Subtitle Row with space for left illustration
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoryName,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? context.colors.textPrimary
                                  : const Color(0xFF1B4270),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'اكتشف أفضل التجار والخدمات في مصر',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? context.colors.textSecondary
                                  : const Color(0xFF5A6E85),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Left side reservation for the illustration in background image
                    const SizedBox(width: 120),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
