import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/utils/category_visual_helper.dart';
import 'package:market/features/categories/domain/entities/category_entity.dart';

/// Individual category card for the grid layout.
///
/// Displays a circular pastel background with colored vector icon, bold category name,
/// and stores count matching the design mockup.
class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visualData = CategoryVisualHelper.getVisualData(
      name: category.name,
      slug: category.slug,
      icon: category.icon,
      customColor: category.color,
      customIconColor: category.iconColor,
    );

    final circleColor = isDark
        ? visualData.darkBgColor
        : visualData.lightBgColor;
    final displayStoresCount = category.storesCount;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.lg.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category Icon Circle
            Container(
              width: 68.r,
              height: 68.r,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CategoryVisualHelper.buildIconWidget(
                  visualData: visualData,
                  networkIconUrl: category.icon,
                  size: 30.r,
                ),
              ),
            ),

            SizedBox(height: 8.h),
            // Category Name
            SizedBox(
              height: 34.h,
              child: Text(
                category.name,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  height: 1.15,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 2.h),
            // Stores Count
            Text(
              '$displayStoresCount متجر',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: isDark
                    ? context.colors.textTertiary
                    : const Color(0xFF64748B),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
