import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';

import '../../domain/entities/order_entity.dart';
import '../widgets/order_status_widget.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderEntity? order;

  const OrderSuccessScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    String formatOrderDate(DateTime date) {
      try {
        return DateFormat('dd/MM/yyyy - hh:mm a', 'ar').format(date);
      } catch (_) {
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
    }

    String formatDeliveryDate(DateTime date) {
      try {
        return DateFormat('EEEE, dd MMMM yyyy', 'ar').format(date);
      } catch (_) {
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
    }

    return Scaffold(
      backgroundColor: context.colors.backgroundTertiary,
      appBar: CustomDetailAppBar(
        title: 'نجاح الطلب',
        onBack: () => context.go(AppRoutes.home),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            SizedBox(height: 10.h),

            // Animated Success Check Header
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                color: context.colors.accentGreen.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.colors.accentGreen,
                  width: 3.w,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 52.r,
                color: context.colors.accentGreen,
              ),
            ),
            SizedBox(height: 16.h),

            Text(
              'تم استلام طلبك بنجاح!',
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.primaryDark,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'تم إرسال تفاصيل وتأكيد الطلب إلى هاتفك بنجاح.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5.sp,
                color: context.colors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),

            // Order Status Widget
            if (order != null)
              OrderStatusWidget(
                status: order!.status,
                orderDate: order!.orderDate,
                estimatedDeliveryDate: order!.estimatedDeliveryDate,
              ),
            SizedBox(height: 16.h),



            // Order Summary Details Card
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: context.colors.border.withValues(alpha: 0.8),
                ),
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
                      Text(
                        'تفاصيل الطلب',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      if (order != null)
                        InkWell(
                          borderRadius: BorderRadius.circular(6.r),
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: order!.orderId.toString()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تم نسخ رقم الطلب #${order!.orderId} 📋'),
                                backgroundColor: context.colors.accentGreen,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.copy_rounded,
                                  size: 14.r,
                                  color: context.colors.accentOrange,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'نسخ الرقم',
                                  style: TextStyle(
                                    fontSize: 10.sp,
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
                  SizedBox(height: 12.h),
                  if (order != null) ...[
                    _detailRow(context, 'رقم الطلب', '#${order!.orderId}'),
                    _detailRow(
                      context,
                      'تاريخ الطلب',
                      formatOrderDate(order!.orderDate),
                    ),
                    _detailRow(
                      context,
                      'موعد التوصيل المتوقع',
                      formatDeliveryDate(order!.estimatedDeliveryDate),
                    ),
                    _detailRow(
                      context,
                      'طريقة الدفع',
                      order!.paymentMethod?.title.isNotEmpty == true
                          ? order!.paymentMethod!.title
                          : (order!.paymentMethodType == 'cash'
                                ? 'الدفع عند الاستلام'
                                : order!.paymentMethodType),
                    ),
                    if (order!.address != null &&
                        order!.address!.fullAddress.isNotEmpty)
                      _detailRow(
                        context,
                        'عنوان التوصيل',
                        order!.address!.fullAddress,
                      ),
                    if (order!.pointsDiscount > 0)
                      _detailRow(
                        context,
                        'خصم نقاط المكافأة',
                        '-${order!.pointsDiscount.toStringAsFixed(0)} ج.م',
                      ),
                    if (order!.earnedPoints > 0)
                      _detailRow(
                        context,
                        'النقاط المكتسبة 🌟',
                        '+${order!.earnedPoints} نقطة',
                      ),
                    Divider(height: 20.h, color: context.colors.divider),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المبلغ المدفوع',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        Text(
                          '${order!.summary.total.toStringAsFixed(0)} ج.م',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'تم تسجيل طلبك بنجاح، يمكنك متابعة تفاصيل وتتبع الطلب في أي وقت من قائمة طلباتي.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: context.colors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: OutlinedButton(
                      onPressed: () {
                        if (order != null) {
                          context.push(AppRoutes.orderDetails, extra: order);
                        } else {
                          context.push(AppRoutes.orders);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: context.colors.primaryDark),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 18.r,
                            color: context.colors.primaryDark,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'الفاتورة',
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go(AppRoutes.home);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.accentOrange,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'متابعة التسوق',
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

