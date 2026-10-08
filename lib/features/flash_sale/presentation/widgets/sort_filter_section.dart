import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/home/presentation/widgets/filter_chip.dart';
import 'package:market/features/flash_sale/presentation/cubit/flash_sale_state.dart';

/// Horizontal sort filter chips section.
class SortFilterSection extends StatelessWidget {
  final FlashSaleSort selectedSort;
  final ValueChanged<FlashSaleSort> onSortChanged;

  const SortFilterSection({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sorts = FlashSaleSort.values;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ترتيب حسب', style: AppTextStyles.headingSmall),
          SizedBox(height: AppSpacing.md.h),
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sorts.length,
              separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm.w),
              itemBuilder: (context, index) {
                final sort = sorts[index];
                return FilterChipWidget(
                  label: sort.label,
                  isSelected: sort == selectedSort,
                  onTap: () => onSortChanged(sort),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
