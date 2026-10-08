import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/location/presentation/widgets/location_bottom_sheet.dart';

/// Location banner that displays the delivery location.
/// Tapping navigates to the location picker.
class LocationBanner extends StatelessWidget {
  final String? selectedLocation;
  final VoidCallback? onTap;

  const LocationBanner({super.key, this.selectedLocation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.lg.h,
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else {
            LocationBottomSheet.show(context);
          }
        },
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md.r),
          decoration: BoxDecoration(
            color: context.colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(AppSpacing.md.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: context.colors.accentOrange,
                size: 22.r,
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التوصيل إلى',
                      style: AppTextStyles.locationTitle.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      selectedLocation ?? 'حدد موقعك لتصفية العروض',
                      style: AppTextStyles.locationText.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_left,
                color: context.colors.textTertiary,
                size: 20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
