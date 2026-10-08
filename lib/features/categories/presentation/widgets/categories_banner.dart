import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_assets.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/categories/domain/entities/banner_entity.dart';

/// Banner section for the categories screen.
///
/// Displays a soft illustration with stylized Arabic category title & subtitle.
class CategoriesBanner extends StatelessWidget {
  final BannerEntity? banner;
  final String purchaseMode;

  const CategoriesBanner({
    super.key,
    this.banner,
    this.purchaseMode = 'retail',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final title =
        banner != null && banner!.title.isNotEmpty && banner!.title != 'الفئات'
        ? banner!.title
        : (purchaseMode == 'wholesale'
              ? 'الفئات (سوق الجملة)'
              : 'الفئات (سوق التجزئة)');

    final subtitle =
        banner != null &&
            banner!.subtitle.isNotEmpty &&
            banner!.subtitle != 'تصفح الفئات المتاحة'
        ? banner!.subtitle
        : 'تصفح الفئات المتاحة بخصومات كارت التوفير';

    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: isDark
            ? context.colors.backgroundSecondary
            : const Color(0xFFF9FBFC),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              // Text Content on the right (in RTL)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? context.colors.textPrimary
                            : const Color(0xFF1B4270),
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? context.colors.textSecondary
                            : const Color(0xFF5A6E85),
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Space for illustration on left
              const SizedBox(width: 110),
            ],
          ),
        ),
      ),
    );
  }
}
