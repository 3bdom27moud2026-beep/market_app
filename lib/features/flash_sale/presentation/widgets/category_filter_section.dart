import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/home/presentation/widgets/filter_chip.dart';

/// Horizontal category filter chips section.
class CategoryFilterSection extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const CategoryFilterSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('التصنيف', style: AppTextStyles.headingSmall),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm.w),
              itemBuilder: (context, index) {
                final category = categories[index];
                return FilterChipWidget(
                  label: category,
                  isSelected: category == selectedCategory,
                  onTap: () => onCategoryChanged(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
