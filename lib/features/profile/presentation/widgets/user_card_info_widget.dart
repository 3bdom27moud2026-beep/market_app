import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/features/discount_card/presentation/widgets/request_card_bottom_sheet.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';

/// Card widget to display the user's discount card details or a prompt to request a new card if none exists.
class UserCardInfoWidget extends StatelessWidget {
  final UserCardEntity? card;
  final VoidCallback? onRequestCardTap;

  const UserCardInfoWidget({super.key, this.card, this.onRequestCardTap});

  @override
  Widget build(BuildContext context) {
    if (card == null || card!.cardNo.isEmpty) {
      return _buildNoCardView(context);
    }

    return _buildActiveCardView(context, card!);
  }

  /// Banner displayed when the user does NOT have an active discount card.
  Widget _buildNoCardView(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x22000000),
              blurRadius: 16.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title + Empty Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.add_card_rounded,
                        color: context.colors.primary,
                        size: 22.r,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm.w),
                    Text(
                      'كارت الخصومات',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md.w,
                    vertical: AppSpacing.xs.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x2BF59E0B),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFFF59E0B),
                      width: 1.w,
                    ),
                  ),
                  child: Text(
                    'غير متاح',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.md.h),

            // Description text explaining how to request a card
            Text(
              'ليس لديك كارت خصومات حالياً. يمكنك تقديم طلب للحصول على كارت والاستفادة من أفضل العروض والخصومات!',
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.textOnPrimary.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),

            SizedBox(height: AppSpacing.lg.h),

            // CTA Button to request a card
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (onRequestCardTap != null) {
                    onRequestCardTap!();
                  } else {
                    showRequestCardBottomSheet(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                icon: Icon(Icons.card_membership_rounded, size: 20.r),
                label: Text(
                  'تقديم طلب للحصول على كارت',
                  style: TextStyle(
                    fontSize: 13.sp,
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

  /// Banner displayed when user HAS an active card.
  Widget _buildActiveCardView(BuildContext context, UserCardEntity cardEntity) {
    final bool isActive = cardEntity.isActive;
    final String typeArabic = cardEntity.type.toLowerCase() == 'monthly'
        ? 'اشتراك شهري'
        : (cardEntity.type.toLowerCase() == 'annual' ||
                  cardEntity.type.toLowerCase() == 'yearly'
              ? 'اشتراك سنوي'
              : cardEntity.type);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Column(
        children: [
          InkWell(
            onTap: () => context.push(AppRoutes.cardDetails, extra: cardEntity),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg.r),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x33000000),
                    blurRadius: 16.r,
                    offset: Offset(0, 6.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Logo/Title + Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.credit_card_rounded,
                              color: context.colors.primary,
                              size: 22.r,
                            ),
                          ),
                          SizedBox(width: AppSpacing.sm.w),
                          Text(
                            'كارت الخصومات',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textOnPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md.w,
                          vertical: AppSpacing.xs.h,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0x2B10B981)
                              : const Color(0x2BEF4444),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isActive
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.r,
                              height: 6.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              isActive ? 'مُفعل' : 'غير مُفعل',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: isActive
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.lg.h),

                  // Card Number
                  Text(
                    cardEntity.cardNo.isNotEmpty ? cardEntity.cardNo : '---',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: context.colors.textOnPrimary,
                      fontFamily: 'monospace',
                    ),
                  ),

                  SizedBox(height: AppSpacing.md.h),

                  // Bottom Details Row: Type & Remaining Days
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        typeArabic,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: context.colors.textOnPrimary.withValues(
                            alpha: 0.75,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (cardEntity.daysRemaining > 0)
                        Text(
                          'متبقي ${cardEntity.daysRemaining} يوم',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF38BDF8),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // زر تفاصيل الكارت تحت الكارت
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.cardDetails, extra: cardEntity),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'اضغط هنا لتفاصيل الكارت',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
