import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/utils/auth_helper.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/home/presentation/cubit/home_cubit.dart';
import 'package:market/features/home/presentation/cubit/home_state.dart';
import 'package:market/features/home/presentation/widgets/home_app_bar.dart';
import 'package:market/features/home/presentation/widgets/home_search_bar.dart';
import 'package:market/features/home/presentation/widgets/location_banner.dart';
import 'package:market/features/home/presentation/widgets/offer_slider.dart';
import 'package:market/features/home/presentation/widgets/flash_sale_section.dart';
import 'package:market/features/home/presentation/widgets/categories_section.dart';
import 'package:market/features/home/presentation/widgets/best_seller_section.dart';
import 'package:market/features/home/presentation/widgets/partners_section.dart';
import 'package:market/features/home/presentation/widgets/shopguide_card.dart';
import 'package:market/features/home/presentation/widgets/newest_products_section.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';
import 'package:market/features/discount_card/presentation/widgets/request_card_bottom_sheet.dart';
import 'package:market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:market/features/cart/presentation/cubit/cart_state.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_cubit.dart';
import 'package:market/features/promotions/presentation/widgets/startup_promotion_dialog.dart';
import 'package:market/features/location/presentation/widgets/location_bottom_sheet.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:market/features/profile/presentation/cubit/profile_state.dart'
    hide LoadingStatus;
import 'package:market/features/profile/presentation/cubit/profile_state.dart'
    as profile_state
    show LoadingStatus;
import 'package:shimmer/shimmer.dart';

/// Home Screen - the main landing page with all sections.
///
/// Requires a [HomeCubit] to be provided via [BlocProvider] above this widget.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedLocationName;
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _selectedLocationName = CacheHelper.selectedLocationName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeCubit>().loadHome();
      final promotionCubit = context.read<StartupPromotionCubit>();
      promotionCubit.loadPromotion().then((_) {
        if (mounted && promotionCubit.state.promotion != null) {
          promotionCubit.showPopup();
        }
      });
    });

    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      context.read<HomeCubit>().refresh();
      try {
        context.read<CartCubit>().loadCart();
      } catch (_) {}
      try {
        context.read<ProfileCubit>().loadProfile();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: context.colors.background,
              appBar: HomeAppBar(
                cartItemCount: cartState.totalItemsCount,
                notificationCount: 0,
                onCartTap: () {
                  AuthHelper.ensureAuthenticated(
                    context,
                    onAuthenticated: () => context.go(AppRoutes.basket),
                  );
                },
              ),
              body: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  switch (state.loadingStatus) {
                    case LoadingStatus.initial:
                    case LoadingStatus.loading:
                      return const _HomeShimmerLoading();
                    case LoadingStatus.error:
                      return _ErrorView(
                        message: state.errorMessage,
                        onRetry: () => context.read<HomeCubit>().loadHome(),
                      );
                    case LoadingStatus.loaded:
                    case LoadingStatus.refreshing:
                      return RefreshIndicator(
                        onRefresh: () => context.read<HomeCubit>().refresh(),
                        child: _HomeContent(
                          state: state,
                          selectedLocationName: _selectedLocationName,
                          onLocationChanged: (newLocation) {
                            setState(() {
                              _selectedLocationName = newLocation;
                            });
                          },
                        ),
                      );
                  }
                },
              ),
            ),
            // Best Offer Startup Promotion Dialog (covers entire screen including AppBar)
            const StartupPromotionDialog(),
          ],
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeState state;
  final String? selectedLocationName;
  final ValueChanged<String?>? onLocationChanged;

  const _HomeContent({
    required this.state,
    this.selectedLocationName,
    this.onLocationChanged,
  });

  void _navigateToProductDetails(BuildContext context, String productId) {
    context.push('/product-details/$productId');
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final sortedFlashSale = FlashSaleSection.sortProducts(
      state.flashSale,
      state.selectedFilter,
    );
    final sortedBestSellers = BestSellerSection.sortProducts(
      state.bestSellers,
      state.selectedFilter,
    );
    final sortedNewest = NewestProductsSection.sortProducts(
      state.newestProducts,
      state.selectedFilter,
    );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Search Bar
          HomeSearchBar(onTap: () => context.push(AppRoutes.search)),

          // Location Banner
          LocationBanner(
            selectedLocation: selectedLocationName,
            onTap: () async {
              final updated = await LocationBottomSheet.show(context);
              if (updated == true && context.mounted) {
                final newName = CacheHelper.selectedLocationName;
                onLocationChanged?.call(newName);
                context.read<HomeCubit>().refresh();
              }
            },
          ),

          // Offers Slider
          OfferSlider(
            offers: state.offers,
            currentIndex: state.currentBannerIndex,
            onPageChanged: (index) => cubit.changeBanner(index),
            onOfferTap: (offer) => context.go(AppRoutes.categories),
          ),

          CustomProductFilter(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.sm.h,
            ),
            onFilterChanged: (filter) => cubit.changeNewestFilter(filter),
            selectedFilter: state.selectedFilter,
          ),
          // Flash Sale
          FlashSaleSection(
            products: sortedFlashSale,
            timerDuration: state.flashSaleTimer,
            onProductTap: (id) => _navigateToProductDetails(context, id),
            onAddToCart: (id, title) => _navigateToProductDetails(context, id),
            onViewAllTap: () =>
                context.push('${AppRoutes.allProducts}?filter=flash_sale'),
          ),
          const ScreenDivider(),
          // Categories
          CategoriesSection(
            categories: state.categories,
            onCategoryTap: (category) {
              CacheHelper.setSelectedCategoryId(category.id);
              context.push(
                '${AppRoutes.merchants}?categoryId=${category.id}&name=${Uri.encodeComponent(category.name)}',
              );
            },
            onViewAllTap: () => context.go(AppRoutes.categories),
          ),
          const ScreenDivider(),

          // Best Sellers
          BestSellerSection(
            products: sortedBestSellers,
            onProductTap: (id) => _navigateToProductDetails(context, id),
            onAddToCart: (id, title) => _navigateToProductDetails(context, id),
            onViewAllTap: () =>
                context.push('${AppRoutes.allProducts}?filter=best_sellers'),
          ),
          const ScreenDivider(),

          // Partners
          PartnersSection(
            partners: state.partners,
            onViewAllTap: () => context.push(AppRoutes.merchants),
          ),
          const ScreenDivider(),

          // ShopGuide Card (Request Discount Card section)
          // - Shown if user is unauthenticated (not logged in / guest).
          // - Hidden if profile.card != null (user already has a card).
          // - Hidden while profile is loading for logged-in users to prevent flicker.
          // - Shown if user is logged in but has no discount card (card == null).
          BlocSelector<
            ProfileCubit,
            ProfileState,
            (UserCardEntity?, bool, bool)
          >(
            selector: (state) {
              final checkAuth = CoreDI.sl<CheckAuthUseCase>();
              final isUnauthenticated =
                  state.loadingStatus ==
                      profile_state.LoadingStatus.unauthenticated ||
                  !checkAuth();
              return (
                state.profileData?.profile.card,
                state.profileData != null,
                isUnauthenticated,
              );
            },
            builder: (context, data) {
              final card = data.$1;
              final hasProfileData = data.$2;
              final isUnauthenticated = data.$3;

              // CASE 1: User is NOT logged in -> Always show the get card section
              if (isUnauthenticated) {
                return ShopGuideCard(
                  onGetItTap: () async {
                    final bool? result = await showAuthBottomSheet(
                      context,
                      initialTab: AuthBottomSheetTab.register,
                    );
                    if (result == true && context.mounted) {
                      context.read<ProfileCubit>().refresh();
                    }
                  },
                );
              }

              // CASE 2: User is logged in and HAS a card -> Hide section completely
              if (card != null) {
                return const SizedBox.shrink();
              }

              // CASE 3: User is logged in, but profile is still loading and no card info yet -> Hide to prevent flicker
              if (!hasProfileData) {
                return const SizedBox.shrink();
              }

              // CASE 4: User is logged in and DOES NOT HAVE a card -> Show request card section
              return ShopGuideCard(
                onGetItTap: () async {
                  await showRequestCardBottomSheet(context);
                  if (context.mounted) {
                    context.read<ProfileCubit>().refresh();
                  }
                },
              );
            },
          ),
          const ScreenDivider(),

          // Newest Products
          NewestProductsSection(
            products: sortedNewest,
            selectedFilter: state.selectedFilter,
            onFilterChanged: (filter) => cubit.changeNewestFilter(filter),
            onProductTap: (id) => _navigateToProductDetails(context, id),
            onAddToCart: (id, title) => _navigateToProductDetails(context, id),
            onViewAllTap: () =>
                context.push('${AppRoutes.allProducts}?filter=newest'),
          ),

          // Bottom padding for navigation
          SizedBox(height: AppSpacing.huge.h),
        ],
      ),
    );
  }
}

class ScreenDivider extends StatelessWidget {
  const ScreenDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: context.colors.borderLight, thickness: 12.h);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.r,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.textOnPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxxl.w,
                  vertical: AppSpacing.md.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('إعادة المحاولة', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeShimmerLoading extends StatelessWidget {
  const _HomeShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.backgroundSecondary,
      highlightColor: context.colors.border,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Search bar placeholder
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg.r),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: context.colors.textOnPrimary,
                  borderRadius: BorderRadius.circular(AppSpacing.xxl.r),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            // Location banner placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Container(
                height: 60.h,
                decoration: BoxDecoration(
                  color: context.colors.textOnPrimary,
                  borderRadius: BorderRadius.circular(AppSpacing.md.r),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            // Offer slider placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Container(
                height: 180.h,
                decoration: BoxDecoration(
                  color: context.colors.textOnPrimary,
                  borderRadius: BorderRadius.circular(AppSpacing.md.r),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md.h),
            // Flash sale placeholder
            Container(height: 400.h, color: context.colors.flashSaleBlue),
            SizedBox(height: AppSpacing.md.h),
            // Categories placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: SizedBox(
                height: 90.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  separatorBuilder: (_, _) => SizedBox(width: AppSpacing.md.w),
                  itemBuilder: (_, _) => Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: BoxDecoration(
                      color: context.colors.textOnPrimary,
                      borderRadius: BorderRadius.circular(AppSpacing.md.r),
                    ),
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
