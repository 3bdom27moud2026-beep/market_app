import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

class OrderStatusWidget extends StatelessWidget {
  final String status;
  final DateTime? orderDate;
  final DateTime? estimatedDeliveryDate;

  const OrderStatusWidget({
    super.key,
    required this.status,
    this.orderDate,
    this.estimatedDeliveryDate,
  });

  int _getCurrentStep(String rawStatus) {
    switch (rawStatus.toLowerCase().trim()) {
      case 'pending':
      case 'قيد الانتظار':
      case 'قيد المراجعة':
        return 1;
      case 'confirmed':
      case 'تم التأكيد':
      case 'processing':
      case 'preparing':
      case 'قيد التجهيز':
        return 2;
      case 'shipped':
      case 'on_way':
      case 'out_for_delivery':
      case 'in_transit':
      case 'في الطريق':
        return 3;
      case 'delivered':
      case 'completed':
      case 'تم التوصيل':
      case 'تم التسليم':
        return 4;
      case 'cancelled':
      case 'canceled':
      case 'ملغي':
        return 0;
      default:
        return 1;
    }
  }

  String _getStatusLabel(String rawStatus) {
    switch (rawStatus.toLowerCase().trim()) {
      case 'pending':
        return 'قيد المراجعة';
      case 'confirmed':
        return 'تم التأكيد';
      case 'processing':
      case 'preparing':
        return 'قيد التجهيز';
      case 'shipped':
      case 'on_way':
      case 'out_for_delivery':
      case 'in_transit':
        return 'في الطريق';
      case 'delivered':
      case 'completed':
        return 'تم التوصيل';
      case 'cancelled':
      case 'canceled':
        return 'ملغي';
      default:
        return rawStatus;
    }
  }

  Color _getStatusColor(BuildContext context, String rawStatus) {
    switch (rawStatus.toLowerCase().trim()) {
      case 'cancelled':
      case 'canceled':
      case 'ملغي':
        return context.colors.accentRed;
      case 'delivered':
      case 'completed':
      case 'تم التوصيل':
      case 'تم التسليم':
        return context.colors.accentGreen;
      case 'shipped':
      case 'on_way':
      case 'out_for_delivery':
      case 'in_transit':
        return context.colors.accentOrange;
      case 'confirmed':
      case 'processing':
      case 'preparing':
        return context.colors.primary;
      default:
        return context.colors.accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    const steps = ['تم الاستلام', 'قيد التجهيز', 'في الطريق', 'تم التوصيل'];
    final currentStep = _getCurrentStep(status);
    final statusLabel = _getStatusLabel(status);
    final statusColor = _getStatusColor(context, status);

    final double circleSize = 28.r;
    final double lineHeight = 2.5.h;
    final activeColor = context.colors.accentGreen;
    final inactiveColor = context.colors.divider.withValues(alpha: 0.8);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Localized Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حالة الطلب',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Stepper Timeline Row with perfectly balanced slots
          Row(
            children: List.generate(steps.length, (index) {
              final isDone = index < currentStep;
              final isCurrent =
                  index == currentStep && currentStep < steps.length;

              // Line halves calculation: each slot owns half backwards and half forwards
              final isHalf1Active = index > 0 && (index - 1) < currentStep;
              final isHalf2Active =
                  index < steps.length - 1 && index < currentStep;

              return Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    // Continuous Centered Connector Line
                    Positioned(
                      top: (circleSize - lineHeight) / 2,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: [
                          // Half line towards previous step
                          Expanded(
                            child: Container(
                              height: lineHeight,
                              color: index == 0
                                  ? Colors.transparent
                                  : (isHalf1Active
                                      ? activeColor
                                      : inactiveColor),
                            ),
                          ),
                          // Half line towards next step
                          Expanded(
                            child: Container(
                              height: lineHeight,
                              color: index == steps.length - 1
                                  ? Colors.transparent
                                  : (isHalf2Active
                                      ? activeColor
                                      : inactiveColor),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Step Indicator Node (Circle & Label)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone
                                ? activeColor
                                : (isCurrent
                                    ? context.colors.surface
                                    : context.colors.backgroundSecondary),
                            border: Border.all(
                              color: isDone || isCurrent
                                  ? activeColor
                                  : context.colors.border,
                              width: isCurrent ? 2.w : 1.w,
                            ),
                            boxShadow: isDone || isCurrent
                                ? [
                                    BoxShadow(
                                      color: activeColor.withValues(
                                        alpha: 0.25,
                                      ),
                                      blurRadius: 6.r,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isDone
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 16.r,
                                    color: Colors.white,
                                  )
                                : isCurrent
                                    ? Container(
                                        width: 8.r,
                                        height: 8.r,
                                        decoration: BoxDecoration(
                                          color: activeColor,
                                          shape: BoxShape.circle,
                                        ),
                                      )
                                    : Container(
                                        width: 6.r,
                                        height: 6.r,
                                        decoration: BoxDecoration(
                                          color: context.colors.textQuaternary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          steps[index],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: isDone || isCurrent
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isDone || isCurrent
                                ? context.colors.textPrimary
                                : context.colors.textTertiary,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
