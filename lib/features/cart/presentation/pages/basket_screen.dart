import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';
import 'package:market/core/widgets/dashed_painters.dart';
import 'package:market/features/home/presentation/widgets/home_app_bar.dart';

import 'package:market/features/discount_card/presentation/widgets/request_card_bottom_sheet.dart';
import '../../domain/entities/cart_data_entity.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/basket_item_card.dart';
import '../widgets/empty_cart_widget.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/price_summary_card.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  StreamSubscription? _cartSubscription;
  StreamSubscription? _authSubscription;

  @override
  void initState() {
    super.initState();
    _cartSubscription = CartEventBus.instance.stream.listen((_) {
      if (mounted) {
        context.read<CartCubit>().loadCart();
      }
    });
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (mounted && event.type == AuthEventType.loggedIn) {
        context.read<CartCubit>().loadCart();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartCubit>().loadCart();
    });
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _confirmDeleteItem(BuildContext context, int cartItemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'حذف المنتج؟',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف هذا المنتج من سلة التسوق؟',
            style: TextStyle(
              fontSize: 10.sp,
              color: context.colors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: context.colors.textTertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accentRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<CartCubit>().removeItem(cartItemId);
    }
  }

  Future<void> _confirmClearCart(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'إفراغ السلة؟',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف جميع المنتجات من سلة التسوق؟',
            style: TextStyle(
              fontSize: 10.sp,
              color: context.colors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: context.colors.textTertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.accentRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('إفراغ السلة'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<CartCubit>().clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const HomeAppBar(),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colors.accentRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const LoadingSkeleton();
          }

          if (state is CartUnauthenticated) {
            return _UnauthenticatedCartView(
              onLoginPressed: () async {
                final bool? result = await showAuthBottomSheet(context);
                if (result == true && context.mounted) {
                  context.read<CartCubit>().loadCart();
                }
              },
            );
          }

          if (state is CartEmpty) {
            return const EmptyCartWidget();
          }

          if (state is CartLoaded) {
            final cartData = state.cartData;

            if (cartData.cart.isEmpty) {
              return const EmptyCartWidget();
            }

            return RefreshIndicator(
              onRefresh: () => context.read<CartCubit>().loadCart(),
              color: context.colors.accentOrange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Screen Title & Clear Cart Row
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'سلة المشتريات',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          if (cartData.cart.isNotEmpty)
                            IconButton(
                              onPressed: () => _confirmClearCart(context),
                              tooltip: 'إفراغ السلة',
                              icon: Icon(
                                Icons.delete_sweep_outlined,
                                size: 22.r,
                                color: context.colors.accentRed,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Savings motivation banner (ONLY if member and savings > 0)
                    if (cartData.isMember && cartData.cartSavings > 0)
                      _buildSavingsBanner(context, cartData.cartSavings)
                    else if (!cartData.isMember)
                      _buildCardUpsellCard(context, cartData),

                    // Cart Items
                    ...cartData.cart.map((item) {
                      final isUpdating = state.updatingCartItemId == item.id;
                      final isDeleting = state.deletingCartItemId == item.id;
                      return BasketItemCard(
                        item: item,
                        isUpdating: isUpdating,
                        isDeleting: isDeleting,
                        onQuantityChanged: isUpdating || isDeleting
                            ? null
                            : (newQty) {
                                context.read<CartCubit>().updateQuantity(
                                  item.id,
                                  newQty,
                                );
                              },
                        onDelete: isUpdating || isDeleting
                            ? null
                            : () => _confirmDeleteItem(context, item.id),
                      );
                    }),
                    SizedBox(height: 16.h),

                    // Order Summary Card with embedded checkout button
                    PriceSummaryCard(
                      total: cartData.cartTotal,
                      savings: cartData.cartSavings,
                      count: cartData.cartCount,
                      isMember: cartData.isMember,
                      totalWithoutCard: cartData.cartTotalWithoutCard,
                      totalWithCard: cartData.cartTotalWithCard,
                      potentialSavings: cartData.cartPotentialCardSavings ??
                          cartData.cardUpsell?.potentialSavings,
                      onSubscribe: () async {
                        await showRequestCardBottomSheet(context);
                        if (context.mounted) {
                          context.read<CartCubit>().loadCart();
                        }
                      },
                      onCheckout: () {
                        context.push(
                          AppRoutes.checkout,
                          extra: context.read<CartCubit>(),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCardUpsellCard(BuildContext context, CartDataEntity cartData) {
    final upsell = cartData.cardUpsell;
    final double potentialSavings = (upsell?.potentialSavings ??
        cartData.cartPotentialCardSavings?.toDouble() ??
        0.0);

    if (potentialSavings <= 0 && upsell == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = upsell != null && upsell.title.isNotEmpty
        ? upsell.title
        : 'وفّر ${potentialSavings.toStringAsFixed(0)} جنيه على منتجات سلتك الآن!';
    final message = upsell != null && upsell.message.isNotEmpty
        ? upsell.message
        : 'لو اشتركت في كارت ShopGuide هتوفر ${potentialSavings.toStringAsFixed(0)} ج.م على منتجات سلتك الحالية فوراً وكل طلباتك القادمة!';
    final badge = upsell != null && upsell.badge.isNotEmpty
        ? upsell.badge
        : 'وفر ${upsell?.savingsPercentage.toInt() ?? 16}% مع الكارت 💳';
    final ctaText = upsell != null && upsell.ctaText.isNotEmpty
        ? upsell.ctaText
        : 'اشترك ووفر ${potentialSavings.toStringAsFixed(0)} ج.م';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFFFFBEB), const Color(0xFFFEF3C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF59E0B),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.card_membership_rounded,
                color: const Color(0xFFD97706),
                size: 24.r,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF92400E),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 10.5.sp,
              color: isDark ? context.colors.textSecondary : const Color(0xFF78350F),
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 42.h,
            child: ElevatedButton.icon(
              onPressed: () async {
                await showRequestCardBottomSheet(context);
                if (context.mounted) {
                  context.read<CartCubit>().loadCart();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF8226),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.flash_on_rounded, size: 18),
              label: Text(
                ctaText,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsBanner(BuildContext context, num savings) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: isDark
              ? context.colors.primary.withValues(alpha: 0.6)
              : const Color(0xFF80CBC4),
          strokeWidth: 1.2,
          radius: 12.r,
          dashWidth: 5.0,
          dashSpace: 3.5,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isDark ? context.colors.surface : const Color(0xFFF2FBF9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Text('🎉', style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أنت توفر ${savings.toStringAsFixed(0)} ج.م في هذه السلة!',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFF2DD4BF)
                            : const Color(0xFF0D9488),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'خصومات كارت التوفير مطبّقة تلقائياً على كل منتجاتك.',
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: isDark
                            ? context.colors.textSecondary
                            : const Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'مشترك ✓',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
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

class _UnauthenticatedCartView extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const _UnauthenticatedCartView({required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                color: context.colors.primaryDark.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 54.r,
                color: context.colors.primaryDark,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'سجل الدخول لعرض سلة التسوق',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'قم بتسجيل الدخول للاطلاع على المنتجات المضافة ومتابعة عملية الشراء',
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colors.textTertiary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: onLoginPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
