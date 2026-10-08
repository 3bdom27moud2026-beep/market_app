import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/utils/auth_helper.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';
import 'package:market/features/cart/dependency_injection.dart';
import 'package:market/features/home/presentation/widgets/home_app_bar.dart';
import '../../domain/entities/favorite_entity.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<FavoritesCubit>();
      if (cubit.state.status == FavoritesStatus.initial) {
        cubit.loadFavorites();
      }
    });
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      context.read<FavoritesCubit>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: HomeAppBar(
          bottom: TabBar(
            indicatorColor: context.colors.primary,
            indicatorWeight: 3,
            labelColor: context.colors.primary,
            unselectedLabelColor: context.colors.textTertiary,
            labelStyle: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 16.r),
                    SizedBox(width: 6.w),
                    Text('المنتجات المفضلة'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.storefront_outlined, size: 16.r),
                    SizedBox(width: 6.w),
                    Text('التجار المفضلون'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Favorite Products
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                switch (state.status) {
                  case FavoritesStatus.initial:
                  case FavoritesStatus.loading:
                    return const _FavoritesLoading();
                  case FavoritesStatus.unauthenticated:
                    return _UnauthenticatedView(
                      onLoginTap: () async {
                        final bool? result = await showAuthBottomSheet(context);
                        if (result == true && context.mounted) {
                          context.read<FavoritesCubit>().loadFavorites();
                        }
                      },
                    );
                  case FavoritesStatus.error:
                    return _ErrorView(
                      message: state.errorMessage ?? 'حدث خطأ في جلب المفضلة',
                      onRetry: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                    );
                  case FavoritesStatus.loaded:
                    if (state.favorites.isEmpty) {
                      return const _EmptyFavoritesView();
                    }
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                      child: _FavoritesGrid(favorites: state.favorites),
                    );
                }
              },
            ),

            // Tab 2: Favorite Merchants
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                switch (state.status) {
                  case FavoritesStatus.initial:
                  case FavoritesStatus.loading:
                    return const _FavoritesLoading();
                  case FavoritesStatus.unauthenticated:
                    return _UnauthenticatedView(
                      onLoginTap: () async {
                        final bool? result = await showAuthBottomSheet(context);
                        if (result == true && context.mounted) {
                          context.read<FavoritesCubit>().loadFavorites();
                        }
                      },
                    );
                  case FavoritesStatus.error:
                    return _ErrorView(
                      message: state.errorMessage ?? 'حدث خطأ في جلب المفضلة',
                      onRetry: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                    );
                  case FavoritesStatus.loaded:
                    if (state.favoriteMerchants.isEmpty) {
                      return const _EmptyFavoriteMerchantsView();
                    }
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<FavoritesCubit>().loadFavorites(),
                      child: _FavoriteMerchantsGrid(
                        merchants: state.favoriteMerchants,
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  final List<FavoriteEntity> favorites;

  const _FavoritesGrid({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: AppSpacing.md.w,
        mainAxisSpacing: AppSpacing.md.h,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final item = favorites[index];
        return _FavoriteCard(item: item);
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteEntity item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        boxShadow: AppShadows.productCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with remove favorite button
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.md.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: item.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        Container(color: context.colors.backgroundSecondary),
                    errorWidget: (_, _, _) => Container(
                      color: context.colors.backgroundSecondary,
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
                // Remove favorite button
                Positioned(
                  top: AppSpacing.xs.h,
                  right: AppSpacing.xs.w,
                  child: InkWell(
                    onTap: () {
                      context.read<FavoritesCubit>().removeFavorite(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تمت إزالة المنتج من المفضلة'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: context.colors.heartRed,
                        size: 18.r,
                      ),
                    ),
                  ),
                ),
                if (item.discount.isNotEmpty)
                  Positioned(
                    top: AppSpacing.xs.h,
                    left: AppSpacing.xs.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.discountRed,
                        borderRadius: BorderRadius.circular(AppSpacing.xs.r),
                      ),
                      child: Text(
                        item.discount,
                        style: AppTextStyles.discountBadge,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Product details
          Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.store.isNotEmpty)
                  Text(
                    item.store,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10.5.sp,
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 2.h),
                Text(
                  item.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.5.sp,
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs.h),
                Row(
                  children: [
                    Text(
                      '${item.price.toStringAsFixed(0)} ج.م',
                      style: AppTextStyles.price.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                    if (item.oldPrice > item.price) ...[
                      SizedBox(width: AppSpacing.xs.w),
                      Expanded(
                        child: Text(
                          '${item.oldPrice.toStringAsFixed(0)} ج.م',
                          style: AppTextStyles.oldPrice.copyWith(
                            fontSize: 11.sp,
                            color: context.colors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: AppSpacing.xs.h),
                // Add to Cart button
                SizedBox(
                  width: double.infinity,
                  height: 32.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      AuthHelper.ensureAuthenticated(
                        context,
                        onAuthenticated: () async {
                          final cartCubit = CartDI.createCartCubit();
                          final success = await cartCubit.addToCart(
                            productId: item.id,
                            quantity: 1,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'تمت إضافة "${item.name}" إلى السلة'
                                      : 'تعذر إضافة المنتج إلى السلة',
                                ),
                                backgroundColor: success
                                    ? context.colors.accentGreen
                                    : context.colors.accentRed,
                              ),
                            );
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.textOnPrimary,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                      ),
                    ),
                    icon: Icon(Icons.shopping_cart, size: 14.sp),
                    label: Text(
                      'أضف للسلة',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavoritesView extends StatelessWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.heartRed.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 44.r,
                color: context.colors.heartRed,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'قائمة المفضلة فارغة',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'تصفح المنتجات وأضف ما يعجبك إلى المفضلة للرجوع إليها لاحقاً',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colors.textTertiary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnauthenticatedView extends StatelessWidget {
  final VoidCallback onLoginTap;

  const _UnauthenticatedView({required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 44.r,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'سجّل دخولك أولاً',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'قم بتسجيل الدخول لعرض قائمة المنتجات المفضلة لديك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: onLoginTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
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

class _FavoritesLoading extends StatelessWidget {
  const _FavoritesLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.colors.primary),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: TextStyle(color: context.colors.textSecondary)),
          SizedBox(height: AppSpacing.md.h),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavoriteMerchantsView extends StatelessWidget {
  const _EmptyFavoriteMerchantsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.storefront_rounded,
                size: 44.r,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            Text(
              'لا يوجد تجار في المفضلة حالياً',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'استكشف شركاء النجاح وأضف المتاجر المميزة إلى مفضلتك للوصول السريع إليها',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: context.colors.textTertiary,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.merchants),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.md.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl.w,
                  vertical: (AppSpacing.sm + 4).h,
                ),
              ),
              icon: Icon(Icons.store, size: 18.r),
              label: Text(
                'استكشف التجار الآن',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteMerchantsGrid extends StatelessWidget {
  final List<FavoriteMerchantEntity> merchants;

  const _FavoriteMerchantsGrid({required this.merchants});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppSpacing.lg.r),
      itemCount: merchants.length,
      separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (context, index) {
        final item = merchants[index];
        return _FavoriteMerchantCard(item: item);
      },
    );
  }
}

class _FavoriteMerchantCard extends StatelessWidget {
  final FavoriteMerchantEntity item;

  const _FavoriteMerchantCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/merchant-details/${item.id}'),
      borderRadius: BorderRadius.circular(AppSpacing.md.r),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md.r),
          boxShadow: AppShadows.productCard,
        ),
        child: Row(
          children: [
            // Merchant Logo / Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.sm.r),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 64.r,
                height: 64.r,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(color: context.colors.backgroundSecondary),
                errorWidget: (_, _, _) => Container(
                  width: 64.r,
                  height: 64.r,
                  color: context.colors.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.storefront, color: context.colors.primary),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.category.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 15.sp,
                        color: context.colors.ratingGold,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      if (item.discount.isNotEmpty) ...[
                        SizedBox(width: AppSpacing.sm.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: context.colors.discountRed.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            item.discount.contains('%')
                                ? 'خصم ${item.discount}'
                                : item.discount,
                            style: TextStyle(
                              color: context.colors.discountRed,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Unfavorite action
            IconButton(
              icon: Icon(Icons.favorite, color: context.colors.heartRed),
              tooltip: 'إزالة من المفضلة',
              onPressed: () {
                context.read<FavoritesCubit>().removeFavoriteMerchant(item.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تمت إزالة المتجر من المفضلة'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
