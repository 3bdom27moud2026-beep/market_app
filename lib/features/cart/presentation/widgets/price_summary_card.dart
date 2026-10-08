import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/widgets/dashed_painters.dart';
import '../../domain/entities/cart_summary_entity.dart';

class PriceSummaryCard extends StatelessWidget {
  final num total;
  final num savings;
  final int count;
  final bool isMember;
  final CartSummaryEntity? summary;
  final VoidCallback? onCheckout;
  final bool isLoading;
  final bool showCheckoutButton;

  const PriceSummaryCard({
    super.key,
    this.total = 0,
    this.savings = 0,
    this.count = 1,
    this.isMember = false,
    this.summary,
    this.onCheckout,
    this.isLoading = false,
    this.showCheckoutButton = true,
  });

  /// Convenience constructor for backward compatibility with checkout screen.
  factory PriceSummaryCard.fromSummary({
    Key? key,
    required CartSummaryEntity summary,
    VoidCallback? onCheckout,
    bool isLoading = false,
    bool showCheckoutButton = false,
  }) {
    return PriceSummaryCard(
      key: key,
      total: summary.total,
      savings: summary.discountAmount,
      summary: summary,
      onCheckout: onCheckout,
      isLoading: isLoading,
      showCheckoutButton: showCheckoutButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double displaySubtotal = summary != null
        ? summary!.subtotal
        : total.toDouble();

    final double displaySavings = summary != null
        ? summary!.discountAmount
        : savings.toDouble();

    final double displayShipping = summary != null ? summary!.shippingFee : 0.0;

    final double displayTotal = summary != null
        ? summary!.total
        : total.toDouble();

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? context.colors.surface : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? context.colors.border.withValues(alpha: 0.6)
              : const Color(0xFFF2F4F7),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? context.colors.shadowLight
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Subtotal Row
          _buildRow(
            context,
            label: 'المجموع الفرعي',
            value: '${displaySubtotal.toStringAsFixed(0)} ج.م',
          ),

          // 2. Savings Row (ONLY if savings > 0)
          if (displaySavings > 0) ...[
            SizedBox(height: 10.h),
            _buildSavingsRow(
              context,
              label: 'خصم كارت التوفير 🎉',
              value: '- ${displaySavings.toStringAsFixed(0)} ج.م',
            ),
          ],

          // 3. Shipping Fee Row (ONLY if shipping fee > 0)
          if (displayShipping > 0) ...[
            SizedBox(height: 10.h),
            _buildRow(
              context,
              label: 'رسوم التوصيل',
              value: '${displayShipping.toStringAsFixed(0)} ج.م',
            ),
          ],

          // 4. Dashed Divider Line
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: CustomPaint(
              size: Size(double.infinity, 1.h),
              painter: DashedDividerPainter(
                color: isDark
                    ? context.colors.divider
                    : const Color(0xFFE5E7EB),
                strokeWidth: 1.0,
                dashWidth: 4.0,
                dashSpace: 3.0,
              ),
            ),
          ),

          // 5. Total Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الإجمالي',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Text(
                  '${displayTotal.toStringAsFixed(0)} ج.م',
                  key: ValueKey<double>(displayTotal),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ],
          ),

          // 6. Member Savings Pill (ONLY if savings > 0)
          if (displaySavings > 0) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F3934)
                    : const Color(0xFFE8F8F5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Text(
                '✓ سعر المشتركين – وفرت ${displaySavings.toStringAsFixed(0)} ج.م',
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFF2DD4BF)
                      : const Color(0xFF0D9488),
                ),
              ),
            ),
          ],

          // 7. Orange Checkout Button
          if (showCheckoutButton && onCheckout != null) ...[
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE67E22),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 22.r,
                        height: 22.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'إتمام الشراء (${displayTotal.toStringAsFixed(0)} ج.م)',
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5.sp,
              color: isDark
                  ? context.colors.textSecondary
                  : const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.bold,
            color: isDark
                ? context.colors.textPrimary
                : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0D9488);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
