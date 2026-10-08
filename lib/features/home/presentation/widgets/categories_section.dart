import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/home/domain/entities/category_entity.dart';
import 'category_item.dart';

/// Categories section with header and horizontal list of category items.
class CategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final Function(CategoryEntity)? onCategoryTap;
  final VoidCallback? onViewAllTap;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الفئات',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16.sp),
                ),
                InkWell(
                  onTap: onViewAllTap,
                  child: Row(
                    children: [
                      Text(
                        'عرض الكل',
                        style: AppTextStyles.sectionViewAll.copyWith(
                          fontSize: 12.sp,
                          color: context.colors.primary,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12.sp,
                        color: context.colors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          // Categories list
          SizedBox(
            height: 124.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: EdgeInsets.only(left: AppSpacing.md.w),
                  child: CategoryItem(
                    category: category,
                    onTap: () => onCategoryTap?.call(category),
                    homeScreen: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
