import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxStock;
  final bool isLoading;
  final ValueChanged<int>? onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    this.maxStock = 99,
    this.isLoading = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrease = quantity > 1 && !isLoading && onChanged != null;
    final canIncrease = quantity < maxStock && !isLoading && onChanged != null;

    return Container(
      height: 32.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            enabled: canDecrease,
            onPressed: () {
              if (canDecrease && onChanged != null) {
                onChanged!(quantity - 1);
              }
            },
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Container(
              key: ValueKey<String>('${quantity}_$isLoading'),
              constraints: BoxConstraints(minWidth: 26.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      width: 12.r,
                      height: 12.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 1.8,
                        color: Color(0xFF1E293B),
                      ),
                    )
                  : Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
            ),
          ),
          _buildButton(
            icon: Icons.add,
            enabled: canIncrease,
            onPressed: () {
              if (canIncrease && onChanged != null) {
                onChanged!(quantity + 1);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(6.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
          child: Icon(
            icon,
            size: 15.sp,
            color: enabled ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}
