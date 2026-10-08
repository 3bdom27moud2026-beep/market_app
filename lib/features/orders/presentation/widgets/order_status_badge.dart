import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;
  final bool isLarge;

  const OrderStatusBadge({
    super.key,
    required this.status,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusInfo = _getStatusInfo(status, isDark);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 12.w : 8.w,
        vertical: isLarge ? 6.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: statusInfo.backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: statusInfo.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isLarge ? 8.r : 6.r,
            height: isLarge ? 8.r : 6.r,
            decoration: BoxDecoration(
              color: statusInfo.textColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            statusInfo.label,
            style: TextStyle(
              color: statusInfo.textColor,
              fontSize: isLarge ? 12.sp : 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo(String rawStatus, bool isDark) {
    switch (rawStatus.toLowerCase()) {
      case 'pending':
        return _StatusInfo(
          label: 'قيد المراجعة',
          textColor: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
          backgroundColor: isDark
              ? const Color(0xFFD97706).withValues(alpha: 0.15)
              : const Color(0xFFFEF3C7),
          borderColor: isDark
              ? const Color(0xFFD97706).withValues(alpha: 0.35)
              : const Color(0xFFFDE68A),
        );
      case 'confirmed':
      case 'processing':
        return _StatusInfo(
          label: 'قيد التجهيز',
          textColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
          backgroundColor: isDark
              ? const Color(0xFF2563EB).withValues(alpha: 0.15)
              : const Color(0xFFEFF6FF),
          borderColor: isDark
              ? const Color(0xFF2563EB).withValues(alpha: 0.35)
              : const Color(0xFFBFDBFE),
        );
      case 'completed':
      case 'delivered':
        return _StatusInfo(
          label: 'تم الاستلام',
          textColor: isDark ? const Color(0xFF34D399) : const Color(0xFF059669),
          backgroundColor: isDark
              ? const Color(0xFF059669).withValues(alpha: 0.15)
              : const Color(0xFFECFDF5),
          borderColor: isDark
              ? const Color(0xFF059669).withValues(alpha: 0.35)
              : const Color(0xFFA7F3D0),
        );
      case 'cancelled':
      case 'canceled':
        return _StatusInfo(
          label: 'ملغي',
          textColor: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
          backgroundColor: isDark
              ? const Color(0xFFDC2626).withValues(alpha: 0.15)
              : const Color(0xFFFEF2F2),
          borderColor: isDark
              ? const Color(0xFFDC2626).withValues(alpha: 0.35)
              : const Color(0xFFFECACA),
        );
      default:
        return _StatusInfo(
          label: rawStatus,
          textColor: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF4B5563),
          backgroundColor: isDark
              ? const Color(0xFF4B5563).withValues(alpha: 0.15)
              : const Color(0xFFF3F4F6),
          borderColor: isDark
              ? const Color(0xFF4B5563).withValues(alpha: 0.35)
              : const Color(0xFFE5E7EB),
        );
    }
  }
}

class _StatusInfo {
  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  const _StatusInfo({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });
}
