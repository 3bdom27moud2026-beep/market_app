import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:market/features/cart/presentation/cubit/cart_state.dart';

/// Circular white back button matching the design screenshot.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? context.colors.surface : Colors.white,
        border: Border.all(
          color: isDark
              ? context.colors.border.withValues(alpha: 0.6)
              : const Color(0xFFEAECF0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? context.colors.shadowLight
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: size ?? 16.sp,
            color: color ??
                (isDark
                    ? context.colors.textPrimary
                    : const Color(0xFF344054)),
          ),
          onPressed: onPressed ??
              () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.home);
                }
              },
        ),
      ),
    );
  }
}

/// Circular white cart button with a dynamic count badge of products in the cart.
class CartBadgeButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const CartBadgeButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
  });

  @override
  State<CartBadgeButton> createState() => _CartBadgeButtonState();
}

class _CartBadgeButtonState extends State<CartBadgeButton> {
  StreamSubscription<void>? _cartSubscription;

  @override
  void initState() {
    super.initState();
    _cartSubscription = CartEventBus.instance.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }

  int _getCartCount(BuildContext context) {
    try {
      final state = context.watch<CartCubit>().state;
      if (state is CartLoaded) {
        return state.totalItemsCount;
      }
    } catch (_) {}
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final int count = _getCartCount(context);

    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? context.colors.surface : Colors.white,
        border: Border.all(
          color: isDark
              ? context.colors.border.withValues(alpha: 0.6)
              : const Color(0xFFEAECF0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? context.colors.shadowLight
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onPressed ??
              () {
                final currentLoc = GoRouterState.of(context).uri.toString();
                if (currentLoc == AppRoutes.basket) return;
                context.go(AppRoutes.basket);
              },
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: widget.size ?? 20.sp,
                color: widget.color ??
                    (isDark
                        ? context.colors.textPrimary
                        : const Color(0xFF344054)),
              ),
              if (count > 0)
                Positioned(
                  top: 4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF8226),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isDark ? context.colors.surface : Colors.white,
                        width: 1.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom top navigation bar for detail / secondary screens without bottom nav bar.
///
/// Features:
/// - Right side (in RTL): [AppBackButton]
/// - Center: Optional Title
/// - Left side (in RTL): Optional action widgets + [CartBadgeButton]
class CustomDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBack;
  final VoidCallback? onCart;
  final List<Widget>? actions;
  final bool showCart;

  const CustomDetailAppBar({
    super.key,
    this.title,
    this.onBack,
    this.onCart,
    this.actions,
    this.showCart = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.background,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Right side (RTL Start): Back button
              AppBackButton(onPressed: onBack),

              // Center: Screen title (if provided)
              if (title != null)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                )
              else
                const Spacer(),

              // Left side (RTL End): Actions + Cart Button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...?actions,
                  if (showCart) ...[
                    if (actions != null && actions!.isNotEmpty)
                      SizedBox(width: 8.w),
                    CartBadgeButton(onPressed: onCart),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
