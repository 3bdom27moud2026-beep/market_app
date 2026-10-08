import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../cart/domain/entities/order_entity.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';
import '../widgets/order_status_badge.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat('#,##0.##', 'ar');
    final formattedDate = DateFormat(
      'yyyy/MM/dd - hh:mm a',
      'ar',
    ).format(order.createdAt);
    final isPending = order.status.toLowerCase() == 'pending';

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(6.r),
          child: const AppBackButton(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: const CartBadgeButton(),
          ),
        ],
        title: Text(
          'تفاصيل الطلب',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
      ),
      body: BlocListener<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state.cancelMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.cancelMessage!),
                backgroundColor: const Color(0xFF059669),
              ),
            );
            context.pop();
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Order Status Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: context.colors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.orderNo.isNotEmpty
                              ? order.orderNo
                              : '#${order.id}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        OrderStatusBadge(status: order.status, isLarge: true),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'تاريخ الطلب: $formattedDate',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 2. Merchant Info Card
              if (order.merchant != null) ...[
                Text(
                  'بيانات المتجر',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: context.colors.borderLight),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: context.colors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child:
                              (order.merchant!.logoUrl != null &&
                                  order.merchant!.logoUrl!.isNotEmpty)
                              ? Image.network(
                                  order.merchant!.logoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.storefront_rounded,
                                        color: context.colors.primary,
                                      ),
                                )
                              : Icon(
                                  Icons.storefront_rounded,
                                  color: context.colors.primary,
                                ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.merchant!.name,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // 3. Order Items List
              Text(
                'المنتجات المطلوبة',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: context.colors.borderLight),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: context.colors.divider),
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    final productImage = item.imageUrl;
                    final productTitle = item.name.isNotEmpty
                        ? item.name
                        : 'منتج #${item.id}';

                    return Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Product Image
                          Container(
                            width: 60.r,
                            height: 60.r,
                            decoration: BoxDecoration(
                              color: context.colors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: (productImage.isNotEmpty)
                                  ? Image.network(
                                      productImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                            Icons.image_not_supported_outlined,
                                            color:
                                                context.colors.textQuaternary,
                                          ),
                                    )
                                  : Icon(
                                      Icons.image_not_supported_outlined,
                                      color: context.colors.textQuaternary,
                                    ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productTitle,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Text(
                                      '${currencyFormatter.format(item.price)} ج.م',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: context.colors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'الكمية: ${item.qty}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: context.colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Total
                          Text(
                            '${currencyFormatter.format(item.lineTotal)} ج.م',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16.h),

              // 4. Financial Summary
              Text(
                'ملخص الفاتورة',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: context.colors.borderLight),
                ),
                child: Column(
                  children: [
                    _summaryRow(
                      context,
                      'المجموع الفرعي',
                      '${currencyFormatter.format(order.totalPrice + order.savings)} ج.م',
                    ),
                    if (order.savings > 0) ...[
                      SizedBox(height: 8.h),
                      _summaryRow(
                        context,
                        'إجمالي الخصم والوفورات',
                        '- ${currencyFormatter.format(order.savings)} ج.م',
                        valueColor: const Color(0xFF059669),
                      ),
                    ],
                    SizedBox(height: 8.h),
                    _summaryRow(
                      context,
                      'رسوم التوصيل',
                      'مجاناً',
                      valueColor: const Color(0xFF059669),
                    ),
                    SizedBox(height: 12.h),
                    Divider(height: 1, color: context.colors.divider),
                    SizedBox(height: 12.h),
                    _summaryRow(
                      context,
                      'المبلغ الإجمالي',
                      '${currencyFormatter.format(order.totalPrice)} ج.م',
                      isBold: true,
                      fontSize: 14.sp,
                      valueColor: context.colors.primary,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 5. Payment Method
              Text(
                'طريقة الدفع',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: context.colors.borderLight),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.payments_outlined,
                      color: context.colors.primary,
                      size: 22.r,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      order.paymentMethodType == 'cash'
                          ? 'الدفع عند الاستلام (كاش)'
                          : order.paymentMethodType,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // 6. Shipping & Tracking
              if ((order.trackingUrl != null &&
                      order.trackingUrl!.isNotEmpty) ||
                  (order.trackingNumber != null &&
                      order.trackingNumber!.isNotEmpty)) ...[
                SizedBox(height: 16.h),
                Text(
                  'تتبع الشحنة 🚚',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: context.colors.borderLight),
                  ),
                  child: Column(
                    children: [
                      if (order.trackingNumber != null &&
                          order.trackingNumber!.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'رقم البوليصة: ${order.trackingNumber}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.copy_rounded,
                                size: 18.r,
                                color: context.colors.primary,
                              ),
                              tooltip: 'نسخ رقم البوليصة',
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: order.trackingNumber!),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'تم نسخ رقم البوليصة بنجاح 📋',
                                    ),
                                    backgroundColor: context.colors.accentGreen,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      if (order.trackingUrl != null &&
                          order.trackingUrl!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: double.infinity,
                          height: 46.h,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final uri = Uri.parse(order.trackingUrl!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            icon: Icon(
                              Icons.local_shipping_outlined,
                              size: 18.r,
                            ),
                            label: Text(
                              'تتبع الشحنة مباشرة 🚚',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.accentOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              SizedBox(height: 24.h),

              // 7. Action Buttons
              if (isPending)
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: () => _showCancelConfirmationDialog(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFDC2626)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'إلغاء الطلب',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    double? fontSize,
    Color? valueColor,
  }) {
    final effectiveFontSize = fontSize ?? 12.sp;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: effectiveFontSize,
            color: isBold
                ? context.colors.textPrimary
                : context.colors.textSecondary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: effectiveFontSize,
            color:
                valueColor ??
                (isBold
                    ? context.colors.textPrimary
                    : context.colors.textSecondary),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'إلغاء الطلب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: context.colors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟',
          style: TextStyle(
            fontSize: 13.sp,
            color: context.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'تراجع',
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<OrdersCubit>().cancelOrder(order.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'تأكيد الإلغاء',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
