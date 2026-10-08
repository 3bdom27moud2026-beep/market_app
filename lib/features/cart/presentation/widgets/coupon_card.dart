import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';

import '../../domain/entities/coupon_entity.dart';

class CouponCard extends StatefulWidget {
  final CouponEntity? appliedCoupon;
  final String? errorMessage;
  final bool isLoading;
  final Function(String code) onApply;
  final VoidCallback onRemove;

  const CouponCard({
    super.key,
    this.appliedCoupon,
    this.errorMessage,
    this.isLoading = false,
    required this.onApply,
    required this.onRemove,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                color: context.colors.accentOrange,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'كوبون الخصم',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (widget.appliedCoupon != null)
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: context.colors.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: context.colors.accentGreen.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: context.colors.accentGreen,
                    size: 22.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تم تطبيق كود: ${widget.appliedCoupon!.code}',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: context.colors.accentGreen,
                          ),
                        ),
                        Text(
                          widget.appliedCoupon!.description,
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: context.colors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: Icon(
                      Icons.close_rounded,
                      color: context.colors.accentRed,
                      size: 20.r,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44.h,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'أدخل كود الخصم (مثال: MARKET20)',
                        hintStyle: TextStyle(
                          fontSize: 8.sp,
                          color: context.colors.textQuaternary,
                        ),
                        filled: true,
                        fillColor: context.colors.backgroundSecondary,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                SizedBox(
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            if (_controller.text.trim().isNotEmpty) {
                              widget.onApply(_controller.text.trim());
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primaryDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                    ),
                    child: widget.isLoading
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'تطبيق',
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          if (widget.errorMessage != null && widget.appliedCoupon == null) ...[
            SizedBox(height: 8.h),
            Text(
              widget.errorMessage!,
              style: TextStyle(
                fontSize: 7.sp,
                color: context.colors.accentRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
