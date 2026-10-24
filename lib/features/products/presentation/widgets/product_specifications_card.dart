import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/products/domain/entities/specification_entity.dart';

/// Card displaying product specifications in a two-column layout.
class ProductSpecificationsCard extends StatelessWidget {
  final List<SpecificationEntity> specifications;

  const ProductSpecificationsCard({super.key, required this.specifications});

  @override
  Widget build(BuildContext context) {
    if (specifications.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'المواصفات الفنية',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        // Table container
        Container(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.colors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < specifications.length; i++) ...[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Key / Title cell (on right in RTL)
                      Container(
                        width: 120.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: context.colors.border),
                          ),
                        ),
                        child: Text(
                          specifications[i].title,
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Value cell (on left in RTL)
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          alignment: Alignment.centerRight,
                          child: Text(
                            specifications[i].value,
                            style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (i < specifications.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: context.colors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
