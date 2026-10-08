import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/routes/app_routes.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                color: context.colors.primaryDark.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 60.r,
                color: context.colors.primaryDark,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'السلة فارغة',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'لم تقم بإضافة أي منتجات إلى سلة التسوق الخاصة بك بعد.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colors.textTertiary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: 200.w,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.accentOrange,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'ابدأ التسوق',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
