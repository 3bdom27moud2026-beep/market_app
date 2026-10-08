import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_text_styles.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';

/// Confirm button for location selection bottom sheet.
class ConfirmLocationButton extends StatelessWidget {
  const ConfirmLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        final isEnabled =
            state.selectedGovernorate != null &&
            state.selectedCenter != null &&
            state.selectedArea != null &&
            !state.isSaving;

        return SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () => context.read<LocationCubit>().confirmLocation()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.textOnPrimary,
              disabledBackgroundColor: context.colors.primaryLightest,
              disabledForegroundColor: context.colors.textOnPrimary60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium.r),
              ),
            ),
            child: state.isSaving
                ? SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: context.colors.textOnPrimary,
                    ),
                  )
                : Text(
                    'تأكيد الموقع',
                    style: AppTextStyles.buttonOrange.copyWith(fontSize: 14.sp),
                  ),
          ),
        );
      },
    );
  }
}
