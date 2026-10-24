import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/discount_card/dependency_injection.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';

/// Shows a bottom sheet to request a discount card via POST /v1/card/request.
Future<void> showRequestCardBottomSheet(BuildContext context) {
  DiscountCardCubit cubit;
  try {
    cubit = context.read<DiscountCardCubit>();
  } catch (_) {
    cubit = DiscountCardDI.createDiscountCardCubit();
  }
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (ctx) => BlocProvider<DiscountCardCubit>.value(
      value: cubit,
      child: const _RequestCardBottomSheetContent(),
    ),
  );
}

class _RequestCardBottomSheetContent extends StatefulWidget {
  const _RequestCardBottomSheetContent();

  @override
  State<_RequestCardBottomSheetContent> createState() =>
      _RequestCardBottomSheetContentState();
}

class _RequestCardBottomSheetContentState
    extends State<_RequestCardBottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  String _paymentMethod = 'cash';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final result = await context.read<DiscountCardCubit>().submitCardRequest(
      deliveryAddress: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      paymentMethod: _paymentMethod,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    result.fold(
      (transportError) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: context.colors.textOnPrimary,
                ),
                SizedBox(width: AppSpacing.sm.w),
                Expanded(
                  child: Text(
                    transportError,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: context.colors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: context.colors.accentRed,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium.r),
            ),
          ),
        );
      },
      (businessResult) {
        if (businessResult.status) {
          navigator.pop();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: context.colors.textOnPrimary,
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Text(
                      businessResult.message.isNotEmpty
                          ? businessResult.message
                          : 'تم تقديم طلب الكارت بنجاح!',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textOnPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: context.colors.accentGreen,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium.r),
              ),
            ),
          );
        } else {
          // Business Rejection
          if (businessResult.card != null) {
            navigator.pop();
          }
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: context.colors.textOnPrimary,
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Text(
                      businessResult.message.isNotEmpty
                          ? businessResult.message
                          : 'لا يمكن تقديم الطلب حالياً.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textOnPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: context.colors.accentOrange,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium.r),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.xl.w,
            right: AppSpacing.xl.w,
            top: AppSpacing.xl.h,
            bottom: AppSpacing.xl.h + bottomInset,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: context.colors.border,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),

                  // Header Icon & Title
                  Center(
                    child: Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_card_rounded,
                        color: context.colors.primary,
                        size: 32.r,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  Text(
                    'طلب كارت الخصومات',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    'احصل على كارتك الخاص للاستفادة من أضخم الخصومات والتخفيضات الحصرية!',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 9.sp,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.xl.h),

                  // Delivery Address Field
                  Text(
                    'عنوان التوصيل',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  TextFormField(
                    key: const Key('card_request_address_field'),
                    controller: _addressController,
                    enabled: !_isSubmitting,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'مثال: المنصورة - شارع المشاية',
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: context.colors.textTertiary,
                        size: 20.r,
                      ),
                      filled: true,
                      fillColor: context.colors.backgroundTertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(
                          color: context.colors.primary,
                          width: 1.5.w,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.md.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال عنوان التوصيل';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  // Phone Field
                  Text(
                    'رقم الهاتف',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  TextFormField(
                    key: const Key('card_request_phone_field'),
                    controller: _phoneController,
                    enabled: !_isSubmitting,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'مثال: 01012345678',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: context.colors.textTertiary,
                        size: 20.r,
                      ),
                      filled: true,
                      fillColor: context.colors.backgroundTertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(
                          color: context.colors.primary,
                          width: 1.5.w,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.md.h,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      if (value.trim().length < 8) {
                        return 'يرجى إدخال رقم هاتف صالح';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  // Payment Method Selection (Cash & InstaPay)
                  Text(
                    'طريقة الدفع',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  _buildPaymentOption(
                    value: 'cash',
                    title: 'الدفع عند الاستلام (كاش)',
                    subtitle: 'ادفع قيمة الكارت لمندوب التوصيل فور الاستلام',
                    icon: Icons.payments_outlined,
                  ),
                  _buildPaymentOption(
                    value: 'instapay',
                    title: 'انستاباي (InstaPay)',
                    subtitle: 'التحويل المباشر عبر تطبيق انستاباي',
                    icon: Icons.bolt_rounded,
                  ),
                  _buildPaymentOption(
                    value: 'vodafone_cash',
                    title: 'محفظة كاش',
                    subtitle: 'التحويل عبر فودافون كاش، أورنج، اتصالات، وي كاش',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  SizedBox(height: AppSpacing.lg.h),

                  // Submit CTA Button
                  SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      key: const Key('card_request_submit_button'),
                      onPressed: _isSubmitting ? null : _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        disabledBackgroundColor: context.colors.primary
                            .withValues(alpha: 0.6),
                        foregroundColor: context.colors.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.medium.r,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              width: 24.r,
                              height: 24.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5.r,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.colors.textOnPrimary,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded, size: 20.r),
                                SizedBox(width: AppSpacing.sm.w),
                                Text(
                                  'تأكيد طلب الكارت',
                                  style: AppTextStyles.buttonOrange.copyWith(
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _paymentMethod == value;
    return GestureDetector(
      onTap: () {
        if (_paymentMethod != value) {
          setState(() {
            _paymentMethod = value;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md.w,
          vertical: AppSpacing.sm.h + 2.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary.withValues(alpha: 0.06)
              : context.colors.backgroundSecondary.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadius.medium.r),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.border.withValues(alpha: 0.8),
            width: isSelected ? 1.5.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? context.colors.primary.withValues(alpha: 0.08)
                  : context.colors.shadowLight,
              blurRadius: isSelected ? 6.r : 3.r,
              offset: Offset(0, 1.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.primary.withValues(alpha: 0.12)
                    : context.colors.backgroundSecondary,
                borderRadius: BorderRadius.circular(AppRadius.small.r),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? context.colors.primary
                    : context.colors.textSecondary,
                size: 20.r,
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected
                          ? context.colors.primaryDark
                          : context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected
                  ? context.colors.primary
                  : context.colors.textTertiary.withValues(alpha: 0.5),
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
