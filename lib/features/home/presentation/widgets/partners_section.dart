import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/home/domain/entities/partner_entity.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:market/features/profile/presentation/cubit/profile_state.dart';
import 'partner_item.dart';

/// Partners section with header and horizontal list of partner logos.
///
/// Tapping a partner opens merchant details.
/// Partner discounts are displayed only if the user has an active discount card.
class PartnersSection extends StatelessWidget {
  final List<PartnerEntity> partners;
  final VoidCallback? onViewAllTap;

  const PartnersSection({super.key, required this.partners, this.onViewAllTap});

  @override
  Widget build(BuildContext context) {
    if (partners.isEmpty) return const SizedBox.shrink();

    return BlocSelector<ProfileCubit, ProfileState, bool>(
      selector: (profileState) =>
          profileState.profileData?.profile.card?.isActive == true,
      builder: (context, isCardActive) {
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
                      'شركاء التميز',
                      style:
                          AppTextStyles.sectionTitle.copyWith(fontSize: 16.sp),
                    ),
                    InkWell(
                      onTap: onViewAllTap,
                      child: Row(
                        children: [
                          Text(
                            'الكل',
                            style: AppTextStyles.sectionViewAll.copyWith(
                              fontSize: 12.sp,
                              color: context.colors.primary,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Icon(
                            Icons.arrow_forward_ios,
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
              // Partners list
              SizedBox(
                height: isCardActive ? 130.h : 105.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
                  itemCount: partners.length,
                  itemBuilder: (context, index) {
                    return PartnerItem(
                      partner: partners[index],
                      showDiscount: isCardActive,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
