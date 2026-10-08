import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/utils/auth_helper.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';
import 'package:market/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:market/features/products/presentation/cubit/product_details_state.dart';
import 'package:market/features/products/presentation/widgets/details_body.dart';
import 'package:market/features/products/presentation/widgets/details_error.dart';
import 'package:market/features/products/presentation/widgets/details_loading.dart';
import 'package:market/features/products/presentation/widgets/add_to_cart_button.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';

/// Product details screen.
///
/// Receives a product [id] via GoRouter extra and loads product details.
class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailsCubit>().loadProduct(widget.productId);
    });
  }

  /// Handle add to cart action with authentication check.
  Future<void> _handleAddToCart() async {
    final cubit = context.read<ProductDetailsCubit>();

    await AuthHelper.ensureAuthenticated(
      context,
      onAuthenticated: () async {
        final added = await cubit.addToCart();
        if (added && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تمت إضافة المنتج إلى السلة'),
              backgroundColor: context.colors.accentGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              margin: const EdgeInsets.all(AppSpacing.lg),
            ),
          );
        }
      },
    );
  }

  /// Handle toggle favorite with auth check and snackbar feedback.
  Future<void> _handleToggleFavorite() async {
    final cubit = context.read<ProductDetailsCubit>();

    final result = await cubit.toggleFavorite();

    if (!mounted) return;

    if (result == 'unauthenticated') {
      // Not logged in → show auth bottom sheet
      final bool? authenticated = await showAuthBottomSheet(context);
      if (authenticated == true && mounted) {
        await cubit.toggleFavorite();
      }
      return;
    }

    if (result is bool) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result ? 'تمت الإضافة إلى المفضلة ❤️' : 'تمت الإزالة من المفضلة',
          ),
          backgroundColor: result
              ? context.colors.heartRed
              : context.colors.textTertiary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          margin: const EdgeInsets.all(AppSpacing.lg),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (result is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: context.colors.accentRed,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(AppSpacing.lg),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar matching screenshot
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  // Back button (in RTL: rightmost)
                  AppBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  // Share button
                  CustomIcon(
                    icon: Icons.share_outlined,
                    onPressed: () =>
                        context.read<ProductDetailsCubit>().shareProduct(),
                  ),
                  SizedBox(width: 10.w),
                  // Favorite button (in RTL: leftmost)
                  BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                    builder: (context, state) {
                      final isFavorite = state.product?.isFavorite ?? false;
                      return CustomIcon(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: isFavorite
                            ? context.colors.heartRed
                            : const Color(0xFF344054),
                        onPressed: _handleToggleFavorite,
                      );
                    },
                  ),
                  SizedBox(width: 10.w),
                  // Cart button with dynamic item count
                  const CartBadgeButton(),
                ],
              ),
            ),
            // Body Content
            Expanded(
              child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ProductDetailsStatus.initial:
                    case ProductDetailsStatus.loading:
                      return const DetailsLoading();
                    case ProductDetailsStatus.error:
                      return DetailsError(
                        message: state.errorMessage,
                        onRetry: () => context
                            .read<ProductDetailsCubit>()
                            .loadProduct(widget.productId),
                      );
                    case ProductDetailsStatus.loaded:
                      return state.product != null
                          ? DetailsBody(product: state.product!)
                          : const SizedBox.shrink();
                  }
                },
              ),
            ),
            // Bottom sticky button
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              builder: (context, state) {
                if (state.status != ProductDetailsStatus.loaded ||
                    state.product == null) {
                  return const SizedBox.shrink();
                }
                return AddToCartButton(
                  isLoading: state.isAddingToCart,
                  isAdded: state.isAddedToCart,
                  isService: state.product?.isPriceOnInspection ?? false,
                  onPressed: state.isAddedToCart ? null : _handleAddToCart,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double? size;

  const CustomIcon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEAECF0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
            icon,
            size: size ?? 18.sp,
            color: color ?? const Color(0xFF344054),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
