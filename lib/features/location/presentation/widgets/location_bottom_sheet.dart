import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import '../../domain/entities/governorate_entity.dart';
import '../../domain/entities/center_entity.dart';
import '../../domain/entities/area_entity.dart';
import '../cubit/location_cubit.dart';
import '../cubit/location_state.dart';
import '../../dependency_injection.dart';
import 'confirm_location_button.dart';
import 'location_dropdown.dart';

/// Location selection bottom sheet.
class LocationBottomSheet extends StatelessWidget {
  const LocationBottomSheet({super.key});

  /// Show the location bottom sheet.
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) =>
            LocationDI.createLocationCubit()..loadGovernorates(),
        child: const LocationBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(context), _buildContent(context)],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colors.divider, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close_rounded,
              color: context.colors.textTertiary,
              size: 24.r,
            ),
          ),
          Expanded(
            child: Text(
              'تحديد موقع التوصيل',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingMedium.copyWith(fontSize: 16.sp),
            ),
          ),
          SizedBox(width: 48.w), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            Text(
              'اختر المحافظة والمنطقة لتصفية العروض والمتاجر الأقرب إليك.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textTertiary,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),

            // Current Country
            _buildCurrentCountry(context),
            SizedBox(height: AppSpacing.xxl.h),

            // Governorate Dropdown
            BlocListener<LocationCubit, LocationState>(
              listenWhen: (previous, current) =>
                  previous.isSuccess != current.isSuccess,
              listener: (context, state) {
                if (state.isSuccess) {
                  Navigator.pop(context, true);
                }
              },
              child: BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  return LocationDropdown<GovernorateEntity>(
                    label: 'المحافظة',
                    hint: 'كل المحافظات',
                    items: state.governorates,
                    selectedItem: state.selectedGovernorate,
                    isEnabled: true,
                    isLoading: state.isLoadingGovernorates,
                    itemLabelBuilder: (governorate) => governorate.name,
                    onChanged: (governorate) {
                      if (governorate != null) {
                        context.read<LocationCubit>().selectGovernorate(
                          governorate,
                        );
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),

            // Center Dropdown
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                final isEnabled = state.selectedGovernorate != null;
                return LocationDropdown<CenterEntity>(
                  label: 'المركز',
                  hint: 'كل المراكز',
                  items: state.centers,
                  selectedItem: state.selectedCenter,
                  isEnabled: isEnabled,
                  isLoading: state.isLoadingCenters,
                  itemLabelBuilder: (center) => center.name,
                  onChanged: (center) {
                    if (center != null) {
                      context.read<LocationCubit>().selectCenter(center);
                    }
                  },
                );
              },
            ),
            SizedBox(height: AppSpacing.lg.h),

            // Area Dropdown
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                final isEnabled = state.selectedCenter != null;
                return LocationDropdown<AreaEntity>(
                  label: 'المنطقة / القرية',
                  hint: 'الكل',
                  items: state.areas,
                  selectedItem: state.selectedArea,
                  isEnabled: isEnabled,
                  isLoading: state.isLoadingAreas,
                  itemLabelBuilder: (area) => area.name,
                  onChanged: (area) {
                    if (area != null) {
                      context.read<LocationCubit>().selectArea(area);
                    }
                  },
                );
              },
            ),
            SizedBox(height: AppSpacing.xxl.h),

            // Error Message
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                if (state.error != null) {
                  return Container(
                    padding: EdgeInsets.all(AppSpacing.md.r),
                    decoration: BoxDecoration(
                      color: context.colors.accentRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small.r),
                      border: Border.all(
                        color: context.colors.accentRed.withValues(alpha: 0.3),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: context.colors.accentRed,
                          size: 20.r,
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.colors.accentRed,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: AppSpacing.lg.h),

            // Confirm Button
            const ConfirmLocationButton(),
            SizedBox(height: AppSpacing.lg.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentCountry(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: context.colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppRadius.small.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            color: context.colors.accentOrange,
            size: 20.r,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Text(
            'الموقع - مصر',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
