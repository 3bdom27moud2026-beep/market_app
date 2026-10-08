import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter/services.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/discount_card/dependency_injection.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_state.dart';
import 'package:market/features/discount_card/presentation/widgets/partner_discounts_section.dart';
import 'package:market/features/discount_card/presentation/widgets/request_card_bottom_sheet.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

/// Screen displaying full card details when user taps on the card banner in Profile.
class CardDetailsScreen extends StatelessWidget {
  final UserCardEntity? card;

  const CardDetailsScreen({super.key, this.card});

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '---';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCard = card != null && card!.cardNo.isNotEmpty;
    final UserCardEntity? cardData = card;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const CustomDetailAppBar(title: 'تفاصيل الكارت'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: hasCard
            ? _buildCardDetailsContent(context, cardData!)
            : _buildNoCardContent(context),
      ),
    );
  }

  Widget _buildCardDetailsContent(
    BuildContext context,
    UserCardEntity cardEntity,
  ) {
    final bool isActive = cardEntity.isActive;
    final String typeArabic = cardEntity.type.toLowerCase() == 'monthly'
        ? 'اشتراك شهري'
        : (cardEntity.type.toLowerCase() == 'annual' ||
                  cardEntity.type.toLowerCase() == 'yearly'
              ? 'اشتراك سنوي'
              : cardEntity.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Visual Card Representation
        FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.xl.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF334155),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x33000000),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: context.colors.primary.withValues(
                              alpha: 0.2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.credit_card_rounded,
                            color: context.colors.primary,
                            size: 24.r,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        Text(
                          'كارت التخفيضات',
                          style: TextStyle(
                            color: context.colors.textOnPrimary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
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
                            ? const Color(0x3310B981)
                            : const Color(0x33EF4444),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        isActive ? 'مُفعل' : 'غير مُفعل',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xxl.h),

                // Card Number + Copy Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardEntity.cardNo,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: context.colors.textOnPrimary,
                        fontFamily: 'monospace',
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        color: context.colors.textQuaternary,
                        size: 20.r,
                      ),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: cardEntity.cardNo),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم نسخ رقم الكارت بنجاح'),
                            backgroundColor: context.colors.accentGreen,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.lg.h),

                // Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نوع الاشتراك',
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: context.colors.textQuaternary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          typeArabic,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textOnPrimary,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'تاريخ الانتهاء',
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: context.colors.textQuaternary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _formatDate(cardEntity.expiresAt),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textOnPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: AppSpacing.lg.h),

        // Partner Discounts Section (Replaces old QR code)
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 150),
          child: BlocProvider<DiscountCardCubit>(
            create: (_) =>
                DiscountCardDI.createDiscountCardCubit()
                  ..loadDiscountCardData(),
            child: BlocBuilder<DiscountCardCubit, DiscountCardState>(
              builder: (context, state) {
                List<StatisticsEntity> stats = [];
                List<DiscountCategoryEntity> cats = [];
                if (state is DiscountCardLoaded) {
                  stats = state.data.statistics;
                  cats = state.data.categories;
                }
                return PartnerDiscountsSection(
                  statistics: stats,
                  categories: cats,
                );
              },
            ),
          ),
        ),

        SizedBox(height: AppSpacing.xxl.h),

        // Card Specifications List
        FadeInUp(
          duration: const Duration(milliseconds: 500),
          delay: const Duration(milliseconds: 300),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.lg.r),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: context.colors.shadowLight,
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.numbers_rounded,
                  label: 'رقم الكارت',
                  value: cardEntity.cardNo,
                ),
                Divider(height: AppSpacing.xl.h, color: context.colors.divider),
                _DetailRow(
                  icon: Icons.card_membership_rounded,
                  label: 'نوع الاشتراك',
                  value: typeArabic,
                ),
                Divider(height: AppSpacing.xl.h, color: context.colors.divider),
                _DetailRow(
                  icon: Icons.verified_rounded,
                  label: 'حالة الكارت',
                  value: isActive ? 'نشط (مُفعل)' : 'غير مُفعل',
                  valueColor: isActive
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                Divider(height: AppSpacing.xl.h, color: context.colors.divider),
                _DetailRow(
                  icon: Icons.savings_rounded,
                  label: 'إجمالي التوفير',
                  value: '${cardEntity.totalSavings.toInt()} ج.م',
                  valueColor: const Color(0xFF00A86B),
                ),
                Divider(height: AppSpacing.xl.h, color: context.colors.divider),
                _DetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'تاريخ التفعيل',
                  value: _formatDate(cardEntity.activatedAt),
                ),
                Divider(height: AppSpacing.xl.h, color: context.colors.divider),
                _DetailRow(
                  icon: Icons.event_available_rounded,
                  label: 'تاريخ الانتهاء',
                  value: _formatDate(cardEntity.expiresAt),
                ),
                if (cardEntity.daysRemaining > 0) ...[
                  Divider(
                    height: AppSpacing.xl.h,
                    color: context.colors.divider,
                  ),
                  _DetailRow(
                    icon: Icons.timer_rounded,
                    label: 'الأيام المتبقية',
                    value: '${cardEntity.daysRemaining} يوم',
                    valueColor: const Color(0xFF0284C7),
                  ),
                ],
              ],
            ),
          ),
        ),

        SizedBox(height: AppSpacing.xxl.h),

        // Action Button: Navigate to Discount Card Features
        SizedBox(height: AppSpacing.xl.h),
      ],
    );
  }

  Widget _buildNoCardContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: AppSpacing.xxl.h),
        Container(
          width: 100.r,
          height: 100.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.primary.withValues(alpha: 0.1),
          ),
          child: Icon(
            Icons.credit_card_off_rounded,
            size: 50.r,
            color: context.colors.primary,
          ),
        ),
        SizedBox(height: AppSpacing.xl.h),
        Text(
          'لا يوجد كارت خصومات مسجل',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl.w),
          child: Text(
            'احصل على كارت خصومات شوب جايد الآن للاستمتاع بخصومات حصرية على جميع المتاجر والمنتجات!',
            style: TextStyle(
              fontSize: 12.sp,
              color: context.colors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: AppSpacing.xxl.h),
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton.icon(
            onPressed: () => showRequestCardBottomSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.accentOrange,
              foregroundColor: context.colors.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            icon: Icon(Icons.add_card_rounded, size: 20.r),
            label: Text(
              'تقديم طلب للحصول على كارت',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.r, color: context.colors.primary),
        SizedBox(width: AppSpacing.md.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            color: valueColor ?? context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
