import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Empty state view for the flash sale screen.
class FlashSaleEmptyView extends StatelessWidget {
  const FlashSaleEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'لا توجد عروض حالياً',
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
