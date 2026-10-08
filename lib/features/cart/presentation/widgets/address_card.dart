import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

import '../../domain/entities/delivery_address_entity.dart';

class AddressCard extends StatelessWidget {
  final DeliveryAddressEntity address;
  final VoidCallback onChangeAddress;
  final bool showEditButton;

  const AddressCard({
    super.key,
    required this.address,
    required this.onChangeAddress,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLight,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: context.colors.primaryLightest,
                      size: 22.r,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        'عنوان التوصيل (${address.title})',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    if (address.isDefault) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.primaryDark.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'الرئيسي',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showEditButton)
                TextButton(
                  onPressed: onChangeAddress,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    'تغيير',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.accentOrange,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${address.recipientName} • ${address.phoneNumber}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            address.fullAddress,
            style: TextStyle(
              fontSize: 11.5.sp,
              color: context.colors.textSecondary,
              height: 1.4,
            ),
          ),
          if (address.notes != null && address.notes!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  size: 15.r,
                  color: context.colors.textTertiary,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    'ملاحظات: ${address.notes}',
                    style: TextStyle(
                      fontSize: 10.5.sp,
                      fontStyle: FontStyle.italic,
                      color: context.colors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
