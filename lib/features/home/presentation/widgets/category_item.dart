import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/utils/category_visual_helper.dart';
import 'package:market/features/home/domain/entities/category_entity.dart';

/// Individual category item on Home Screen matching the circular pastel design mockup.
class CategoryItem extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback? onTap;
  final bool? homeScreen;

  const CategoryItem({
    super.key,
    required this.category,
    this.onTap,
    this.homeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visualData = CategoryVisualHelper.getVisualData(
      name: category.title,
      icon: category.icon,
      customColor: category.color,
      customIconColor: category.iconColor,
    );

    final circleColor = isDark
        ? visualData.darkBgColor
        : visualData.lightBgColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        width: 82.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60.r,
              height: 60.r,
              decoration: BoxDecoration(
                color: circleColor,
                shape: homeScreen == true
                    ? BoxShape.circle
                    : BoxShape.rectangle,
              ),
              child: Center(
                child: CategoryVisualHelper.buildIconWidget(
                  visualData: visualData,
                  networkIconUrl: category.icon,
                  size: 26.r,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 35.h,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    category.title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: context.colors.textPrimary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            homeScreen == false
                ? Text(
                    '${category.storesCount} متجر',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
