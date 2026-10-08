import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

import '../../domain/entities/payment_method_entity.dart';

class PaymentTile extends StatelessWidget {
  final PaymentMethodEntity paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentTile({
    super.key,
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primaryDark.withValues(alpha: 0.04)
              : context.colors.background,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? context.colors.accentOrange
                : context.colors.border.withValues(alpha: 0.8),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.accentOrange.withValues(alpha: 0.15),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : [
                  BoxShadow(
                    color: context.colors.shadowLight,
                    blurRadius: 6.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colors.accentOrange.withValues(alpha: 0.1)
                    : context.colors.backgroundSecondary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                _getIconForType(paymentMethod.type),
                color: isSelected
                    ? context.colors.accentOrange
                    : context.colors.primaryDark,
                size: 24.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paymentMethod.title,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    paymentMethod.subtitle,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: context.colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.colors.accentOrange
                      : context.colors.border,
                  width: isSelected ? 6.r : 2.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(PaymentType type) {
    switch (type) {
      case PaymentType.cashOnDelivery:
        return Icons.payments_outlined;
      case PaymentType.visaMastercard:
        return Icons.credit_card_rounded;
      case PaymentType.applePay:
        return Icons.apple_rounded;
      case PaymentType.googlePay:
        return Icons.g_mobiledata_rounded;
      case PaymentType.vodafoneCash:
      case PaymentType.wallet:
        return Icons.account_balance_wallet_outlined;
    }
  }
}
