import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/features/categories/domain/entities/category_entity.dart';
import 'category_card.dart';

/// 3-column grid layout for displaying categories.
class CategoriesGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<String> onCategoryTap;

  const CategoriesGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 18.h,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          category: category,
          onTap: () => onCategoryTap(category.id),
        );
      },
    );
  }
}
