import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

import '../../domain/entities/delivery_address_entity.dart';

/// Modern, rebuilt delivery address card for the checkout screen matching the app's design system.
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
    // Determine the badge label to prevent redundant text like 'عنوان التوصيل (العنوان الرئيسي) [الرئيسي]'
    String? badgeLabel;
    final String trimmedTitle = address.title.trim();
    if (address.isDefault || trimmedTitle == 'العنوان الرئيسي') {
      if (trimmedTitle.isNotEmpty &&
          trimmedTitle != 'العنوان الرئيسي' &&
          trimmedTitle != 'عنوان التوصيل') {
        badgeLabel = '$trimmedTitle • الرئيسي';
      } else {
        badgeLabel = 'الرئيسي';
      }
    } else if (trimmedTitle.isNotEmpty &&
        trimmedTitle != 'عنوان التوصيل' &&
        trimmedTitle != 'العنوان الرئيسي') {
      badgeLabel = trimmedTitle;
    }

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colors.border.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Row: Location Icon + Title + Badge + Change Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Location Icon in subtle blue circular badge
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: const Color(0xFF38BDF8),
                        size: 16.r,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Section Title
                    Text(
                      'عنوان التوصيل',
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    // Badge (e.g. 'الرئيسي' or 'المنزل')
                    if (badgeLabel != null) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.3),
                            width: 0.8.w,
                          ),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF38BDF8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Change / Edit Button
              if (showEditButton)
                InkWell(
                  onTap: onChangeAddress,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.accentOrange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: context.colors.accentOrange.withValues(alpha: 0.3),
                        width: 0.8.w,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_location_alt_outlined,
                          size: 13.r,
                          color: context.colors.accentOrange,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'تغيير',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(
              height: 1.h,
              thickness: 0.6,
              color: context.colors.border.withValues(alpha: 0.5),
            ),
          ),

          // Recipient Name & Phone Number Row
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 15.r,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  '${address.recipientName} • ${address.phoneNumber}',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          // Full Address Details Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Icon(
                  Icons.place_outlined,
                  size: 15.r,
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  address.fullAddress,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: context.colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          // Optional Notes
          if (address.notes != null && address.notes!.trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: context.colors.backgroundSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sticky_note_2_outlined,
                    size: 14.r,
                    color: context.colors.accentOrange,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'ملاحظة: ${address.notes!}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: context.colors.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
