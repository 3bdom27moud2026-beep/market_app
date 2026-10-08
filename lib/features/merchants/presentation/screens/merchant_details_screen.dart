import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:market/core/constants/app_assets.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';
import 'package:market/features/merchants/domain/entities/merchant_product_entity.dart';
import 'package:market/core/widgets/reviews_section_widget.dart';
import 'package:market/features/home/presentation/widgets/home_app_bar.dart';
import 'package:market/core/utils/auth_helper.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/favorites/domain/usecases/favorites_usecases.dart';
import 'package:market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:market/features/cart/presentation/cubit/cart_state.dart';
import 'package:market/features/merchants/presentation/cubit/merchant_details_cubit.dart';
import 'package:market/features/merchants/presentation/cubit/merchant_details_state.dart';

/// Merchant details screen — shows merchant info and product catalog matching the new design.
class MerchantDetailsScreen extends StatefulWidget {
  final String merchantId;

  const MerchantDetailsScreen({super.key, required this.merchantId});

  @override
  State<MerchantDetailsScreen> createState() => _MerchantDetailsScreenState();
}

class _MerchantDetailsScreenState extends State<MerchantDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MerchantDetailsCubit>().loadMerchant(widget.merchantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const HomeAppBar(),
      body: BlocBuilder<MerchantDetailsCubit, MerchantDetailsState>(
        builder: (context, state) {
          switch (state.status) {
            case MerchantDetailsStatus.initial:
            case MerchantDetailsStatus.loading:
              return const _MerchantDetailsLoading();

            case MerchantDetailsStatus.error:
              return _MerchantDetailsError(
                message: state.errorMessage ?? 'حدث خطأ في تحميل بيانات المتجر',
                onRetry: () => context
                    .read<MerchantDetailsCubit>()
                    .loadMerchant(widget.merchantId),
              );

            case MerchantDetailsStatus.loaded:
              if (state.merchant == null) return const SizedBox.shrink();
              return _MerchantDetailsBody(
                merchant: state.merchant!,
                products: state.products,
              );
          }
        },
      ),
    );
  }
}

// ─────────────────────────── Loading ────────────────────────────

class _MerchantDetailsLoading extends StatelessWidget {
  const _MerchantDetailsLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.primary,
        strokeWidth: 3.r,
      ),
    );
  }
}

// ─────────────────────────── Error ──────────────────────────────

class _MerchantDetailsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MerchantDetailsError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.r,
              color: context.colors.accentRed.withValues(alpha: 0.7),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'تعذّر تحميل بيانات المتجر',
              style: AppTextStyles.headingMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl.w,
                  vertical: AppSpacing.md.h,
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Body ───────────────────────────────

class _MerchantDetailsBody extends StatefulWidget {
  final MerchantEntity merchant;
  final List<MerchantProductEntity> products;

  const _MerchantDetailsBody({required this.merchant, required this.products});

  @override
  State<_MerchantDetailsBody> createState() => _MerchantDetailsBodyState();
}

class _MerchantDetailsBodyState extends State<_MerchantDetailsBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'كل المنتجات';
  String _selectedSort = 'الأحدث';

  final List<String> _sortOptions = [
    'الأحدث',
    'الأعلى خصماً',
    'الأقل سعراً',
    'الأعلى سعراً',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final set = <String>{'كل المنتجات'};
    for (final p in widget.products) {
      if (p.specs.containsKey('category') && p.specs['category']!.isNotEmpty) {
        set.add(p.specs['category']!);
      } else if (p.brand.isNotEmpty) {
        set.add(p.brand);
      }
    }
    // If no distinct categories were found, provide cafe/store friendly defaults if matching
    if (set.length == 1) {
      final nameLower = widget.merchant.name.toLowerCase();
      if (nameLower.contains('كافيه') ||
          nameLower.contains('cafe') ||
          nameLower.contains('قهوة')) {
        set.add('المشروبات الساخنة ☕');
        set.add('المشروبات الباردة ☕');
      }
    }
    return set.toList();
  }

  List<MerchantProductEntity> get _filteredAndSortedProducts {
    var list = widget.products.where((p) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == 'كل المنتجات' ||
          (p.specs['category'] == _selectedCategory) ||
          (p.brand == _selectedCategory) ||
          (_selectedCategory.contains('الساخنة') &&
              (p.name.contains('شاي') ||
                  p.name.contains('قهوة') ||
                  p.name.contains('لاتيه') ||
                  p.name.contains('اسبريسو'))) ||
          (_selectedCategory.contains('الباردة') &&
              (p.name.contains('عصير') ||
                  p.name.contains('مثلج') ||
                  p.name.contains('شوكولاتة') ||
                  p.name.contains('فرابتشينو') ||
                  p.name.contains('سموذي')));

      return matchesSearch && matchesCategory;
    }).toList();

    switch (_selectedSort) {
      case 'الأعلى خصماً':
        list.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
        break;
      case 'الأقل سعراً':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'الأعلى سعراً':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'الأحدث':
      default:
        // maintain default list order
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = _filteredAndSortedProducts;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        slivers: [
          // ── Merchant Header Banner ──
          SliverToBoxAdapter(
            child: _MerchantHeaderBanner(merchant: widget.merchant),
          ),

          // ── Search Field ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: context.colors.borderLight,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  textDirection: TextDirection.rtl,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    hintStyle: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13.sp,
                      color: context.colors.textSecondary,
                    ),
                    suffixIcon: Icon(
                      Icons.search_rounded,
                      color: context.colors.textSecondary,
                      size: 22.r,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Categories Filter Chips ──
          if (_categories.length > 1)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFFF7ED)
                              : context.colors.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFEF8226)
                                : context.colors.borderLight,
                            width: isSelected ? 1.4 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 12.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF1B4270)
                                  : context.colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          SizedBox(height: 8.h).toSliverBox,

          // ── Sort Options Pills ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _sortOptions.length,
                separatorBuilder: (_, _) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final sort = _sortOptions[index];
                  final isSelected = sort == _selectedSort;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSort = sort;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1B4270)
                            : context.colors.surface,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1B4270)
                              : context.colors.borderLight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          sort,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Product Count Row ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
              child: Text(
                '${displayedProducts.length} منتج',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
          ),

          // ── Products Grid ──
          if (displayedProducts.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40.r),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48.r,
                        color: context.colors.textSecondary,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'لا توجد منتجات مطابقة للبحث',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _ProductGridCard(
                    product: displayedProducts[index],
                    merchantId: widget.merchant.id.toString(),
                  ),
                  childCount: displayedProducts.length,
                ),
              ),
            ),

          // ── Store Information, Contacts & Reviews Collapsible Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: _StoreInfoCollapsibleCard(merchant: widget.merchant),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        ],
      ),
    );
  }
}

// ─────────────────────────── Header Banner ──────────────────────────

class _MerchantHeaderBanner extends StatelessWidget {
  final MerchantEntity merchant;

  const _MerchantHeaderBanner({required this.merchant});

  String get _fullLocation {
    final parts = <String>[];
    if (merchant.area != null) {
      parts.add(merchant.area!.name);
      if (merchant.area!.center != null) {
        parts.add(merchant.area!.center!.name);
        if (merchant.area!.center!.governorate != null) {
          parts.add(merchant.area!.center!.governorate!.name);
        }
      }
    }
    return parts.isEmpty ? merchant.address : parts.join('، ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? context.colors.surface : const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          image: const AssetImage(AppAssets.categoriesBackground),
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
          colorFilter: isDark
              ? ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.7),
                  BlendMode.darken,
                )
              : null,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: context.colors.borderLight, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Controls: Back Button on right, Share & Favorite on left
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button (White Circle)
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      color: const Color(0xFF1B4270),
                      size: 20.r,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ),

                // Share & Favorite Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Share Button (White Circle)
                    Container(
                      width: 38.r,
                      height: 38.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.share_outlined,
                          color: const Color(0xFF1B4270),
                          size: 19.r,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: merchant.name));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم نسخ رابط المتجر'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Favorite Button (White Circle)
                    _MerchantFavoriteCircleButton(merchantId: merchant.id),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Merchant Name & Discount Badge & Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Merchant Image avatar if available
                if (merchant.image.isNotEmpty) ...[
                  Container(
                    width: 58.r,
                    height: 58.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: merchant.image,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          color: const Color(0xFFF1F5F9),
                          child: Icon(
                            Icons.storefront_rounded,
                            color: const Color(0xFF1B4270),
                            size: 26.r,
                          ),
                        ),
                        errorWidget: (_, _, _) => Container(
                          color: const Color(0xFFF1F5F9),
                          child: Icon(
                            Icons.storefront_rounded,
                            color: const Color(0xFF1B4270),
                            size: 26.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Discount Row
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8.w,
                        runSpacing: 4.h,
                        children: [
                          Text(
                            merchant.name,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? context.colors.textPrimary
                                  : const Color(0xFF1B4270),
                            ),
                          ),
                          if (merchant.discount.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF8226),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                merchant.discount.contains('خصم')
                                    ? merchant.discount
                                    : 'خصم ${merchant.discount}',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 4.h),

                      // Location text
                      Text(
                        _fullLocation.isNotEmpty
                            ? _fullLocation
                            : 'روكسي، مصر الجديدة، القاهرة',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Favorite Buttons ──────────────────────────

class _MerchantFavoriteCircleButton extends StatefulWidget {
  final int merchantId;

  const _MerchantFavoriteCircleButton({required this.merchantId});

  @override
  State<_MerchantFavoriteCircleButton> createState() =>
      _MerchantFavoriteCircleButtonState();
}

class _MerchantFavoriteCircleButtonState
    extends State<_MerchantFavoriteCircleButton> {
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final checkAuth = CoreDI.sl<CheckAuthUseCase>();
    if (!checkAuth()) return;

    if (CoreDI.sl.isRegistered<GetFavoriteMerchantsUseCase>()) {
      final result = await CoreDI.sl<GetFavoriteMerchantsUseCase>()();
      result.fold((_) {}, (merchants) {
        if (mounted) {
          setState(() {
            _isFavorite = merchants.any((m) => m.id == widget.merchantId);
          });
        }
      });
    }
  }

  Future<void> _toggleFavorite() async {
    AuthHelper.ensureAuthenticated(
      context,
      onAuthenticated: () async {
        if (_isLoading) return;
        setState(() {
          _isFavorite = !_isFavorite;
          _isLoading = true;
        });

        if (CoreDI.sl.isRegistered<ToggleFavoriteUseCase>()) {
          final result = await CoreDI.sl<ToggleFavoriteUseCase>()(
            widget.merchantId.toString(),
            type: 'merchant',
          );
          if (!mounted) return;
          result.fold(
            (_) {
              setState(() {
                _isFavorite = !_isFavorite;
                _isLoading = false;
              });
            },
            (isAdded) {
              setState(() {
                _isFavorite = isAdded;
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAdded
                        ? 'تمت إضافة المتجر إلى المفضلة'
                        : 'تمت إزالة المتجر من المفضلة',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        } else {
          setState(() => _isLoading = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: _isFavorite ? Colors.red : const Color(0xFF1B4270),
          size: 20.r,
        ),
        onPressed: _toggleFavorite,
      ),
    );
  }
}

// ─────────────────────────── Product Grid Card ──────────────────────────

class _ProductGridCard extends StatefulWidget {
  final MerchantProductEntity product;
  final String merchantId;

  const _ProductGridCard({required this.product, required this.merchantId});

  @override
  State<_ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<_ProductGridCard> {
  bool _isFavorite = false;
  bool _isFavLoading = false;

  Future<void> _toggleProductFavorite() async {
    AuthHelper.ensureAuthenticated(
      context,
      onAuthenticated: () async {
        if (_isFavLoading) return;
        setState(() {
          _isFavorite = !_isFavorite;
          _isFavLoading = true;
        });

        if (CoreDI.sl.isRegistered<ToggleFavoriteUseCase>()) {
          final result = await CoreDI.sl<ToggleFavoriteUseCase>()(
            widget.product.id.toString(),
            type: 'product',
          );
          if (!mounted) return;
          result.fold(
            (_) {
              setState(() {
                _isFavorite = !_isFavorite;
                _isFavLoading = false;
              });
            },
            (isAdded) {
              setState(() {
                _isFavorite = isAdded;
                _isFavLoading = false;
              });
            },
          );
        } else {
          setState(() => _isFavLoading = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push('/product-details/${product.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.colors.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image with Floating Favorite Button
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      placeholder: (_, _) =>
                          Container(color: context.colors.backgroundSecondary),
                      errorWidget: (_, _, _) => Container(
                        color: context.colors.backgroundSecondary,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: context.colors.textSecondary,
                          size: 32.r,
                        ),
                      ),
                    ),
                  ),

                  // Floating Favorite Button (Circle)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: GestureDetector(
                      onTap: _toggleProductFavorite,
                      child: Container(
                        width: 30.r,
                        height: 30.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: _isFavorite
                              ? Colors.red
                              : const Color(0xFF64748B),
                          size: 17.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details (Title, Price, Button)
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title (Centered)
                  Text(
                    product.name,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? context.colors.textPrimary
                          : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Price Row (Centered)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (product.oldPrice > product.price) ...[
                        Text(
                          product.oldPrice.toStringAsFixed(
                            product.oldPrice.truncateToDouble() ==
                                    product.oldPrice
                                ? 0
                                : 2,
                          ),
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 11.sp,
                            color: const Color(0xFF94A3B8),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 6.w),
                      ],
                      Text(
                        '${product.price.toStringAsFixed(product.price.truncateToDouble() == product.price ? 0 : 2)} جنية',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? context.colors.primaryLight
                              : const Color(0xFF1B4270),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Cart Action Button / Quantity Selector
                  BlocBuilder<CartCubit, CartState>(
                    builder: (context, cartState) {
                      int cartQty = 0;
                      int? cartItemId;

                      if (cartState is CartLoaded) {
                        for (final item in cartState.cartData.cart) {
                          if (item.product.id.toString() ==
                              product.id.toString()) {
                            cartQty = item.qty;
                            cartItemId = item.id;
                            break;
                          }
                        }
                      }

                      if (cartQty == 0) {
                        // "إضافة" Dark Navy Button
                        return Material(
                          color: const Color(0xFF1B4270),
                          borderRadius: BorderRadius.circular(10.r),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.r),
                            onTap: () {
                              context.read<CartCubit>().addToCart(
                                productId: product.id,
                                quantity: 1,
                              );
                            },
                            child: Container(
                              height: 36.h,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                    size: 15.r,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'إضافة',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Quantity Controller [Trash/Minus  Qty  Plus]
                        return Container(
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? context.colors.backgroundSecondary
                                : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: context.colors.borderLight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Decrement or Delete
                              InkWell(
                                onTap: () {
                                  if (cartItemId != null) {
                                    if (cartQty > 1) {
                                      context.read<CartCubit>().updateQuantity(
                                        cartItemId,
                                        cartQty - 1,
                                      );
                                    } else {
                                      context.read<CartCubit>().removeItem(
                                        cartItemId,
                                      );
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 6.h,
                                  ),
                                  child: Icon(
                                    cartQty == 1
                                        ? Icons.delete_outline_rounded
                                        : Icons.remove_rounded,
                                    color: cartQty == 1
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF1B4270),
                                    size: 18.r,
                                  ),
                                ),
                              ),

                              // Qty Text
                              Text(
                                '$cartQty',
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                  color: context.colors.textPrimary,
                                ),
                              ),

                              // Increment
                              InkWell(
                                onTap: () {
                                  if (cartItemId != null) {
                                    context.read<CartCubit>().updateQuantity(
                                      cartItemId,
                                      cartQty + 1,
                                    );
                                  } else {
                                    context.read<CartCubit>().addToCart(
                                      productId: product.id,
                                      quantity: 1,
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 6.h,
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: const Color(0xFF1B4270),
                                    size: 18.r,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Store Info Collapsible Card ────────────

class _StoreInfoCollapsibleCard extends StatelessWidget {
  final MerchantEntity merchant;

  const _StoreInfoCollapsibleCard({required this.merchant});

  Future<void> _openWhatsApp(BuildContext context, String number) async {
    try {
      CoreDI.sl<ApiClient>().post(
        EndPoints.merchantTrackContact(merchant.id),
        data: {'type': 'whatsapp'},
      );
    } catch (_) {}

    var cleaned = number.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.startsWith('00')) {
      cleaned = cleaned.substring(2);
    }
    // Handle Egyptian phone number formatting
    if (!cleaned.startsWith('20') && cleaned.startsWith('0')) {
      cleaned = '2$cleaned'; // 010... -> 2010...
    } else if (!cleaned.startsWith('20') &&
        !cleaned.startsWith('2') &&
        cleaned.length == 10) {
      cleaned = '20$cleaned';
    }

    final webUri = Uri.parse('https://wa.me/$cleaned');
    final appUri = Uri.parse('whatsapp://send?phone=$cleaned');

    try {
      final launched = await launchUrl(
        webUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر فتح تطبيق واتساب')),
          );
        }
      }
    }
  }

  Future<void> _call(BuildContext context, String number) async {
    try {
      CoreDI.sl<ApiClient>().post(
        EndPoints.merchantTrackContact(merchant.id),
        data: {'type': 'phone'},
      );
    } catch (_) {}

    final cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر فتح تطبيق الاتصال')),
          );
        }
      }
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final cleanEmail = email.trim();
    final uri = Uri(scheme: 'mailto', path: cleanEmail);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (_) {
      try {
        await launchUrl(uri);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر فتح تطبيق البريد')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasContacts =
        merchant.phone.isNotEmpty ||
        merchant.whatsapp.isNotEmpty ||
        merchant.email.isNotEmpty;

    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.colors.borderLight),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            iconColor: const Color(0xFF1B4270),
            collapsedIconColor: context.colors.textSecondary,
            title: Row(
              children: [
                Icon(
                  Icons.storefront_rounded,
                  color: const Color(0xFF1B4270),
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'معلومات المتجر والتواصل والتقييمات',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: context.colors.divider),
                    SizedBox(height: 8.h),

                    // Store Image if available
                    if (merchant.image.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: merchant.image,
                          width: double.infinity,
                          height: 140.h,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => Container(
                            height: 140.h,
                            color: context.colors.backgroundSecondary,
                          ),
                          errorWidget: (_, _, _) => const SizedBox.shrink(),
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // Quick Action Buttons
                    Row(
                      children: [
                        if (merchant.phone.isNotEmpty) ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _call(context, merchant.phone),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B4270),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                              ),
                              icon: Icon(Icons.call_rounded, size: 16.r),
                              label: const Text('اتصال'),
                            ),
                          ),
                          if (merchant.whatsapp.isNotEmpty ||
                              merchant.email.isNotEmpty)
                            SizedBox(width: 8.w),
                        ],
                        if (merchant.whatsapp.isNotEmpty) ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _openWhatsApp(context, merchant.whatsapp),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF25D366),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                              ),
                              icon: Icon(Icons.chat_rounded, size: 16.r),
                              label: const Text('واتساب'),
                            ),
                          ),
                          if (merchant.email.isNotEmpty) SizedBox(width: 8.w),
                        ],
                        if (merchant.email.isNotEmpty) ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _sendEmail(context, merchant.email),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B82F6),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                              ),
                              icon: Icon(Icons.email_rounded, size: 16.r),
                              label: const Text('إيميل'),
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Detailed Contact Information Rows
                    if (hasContacts) ...[
                      SizedBox(height: 14.h),
                      Text(
                        'بيانات التواصل:',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      if (merchant.phone.isNotEmpty)
                        _ContactInfoRow(
                          icon: Icons.phone_android_rounded,
                          label: 'الهاتف: ${merchant.phone}',
                          onTap: () => _call(context, merchant.phone),
                        ),
                      if (merchant.whatsapp.isNotEmpty)
                        _ContactInfoRow(
                          icon: Icons.chat_outlined,
                          label: 'الواتساب: ${merchant.whatsapp}',
                          onTap: () =>
                              _openWhatsApp(context, merchant.whatsapp),
                        ),
                      if (merchant.email.isNotEmpty)
                        _ContactInfoRow(
                          icon: Icons.email_outlined,
                          label: 'البريد: ${merchant.email}',
                          onTap: () => _sendEmail(context, merchant.email),
                        ),
                    ],

                    // Description if present
                    if (merchant.description.isNotEmpty) ...[
                      SizedBox(height: 14.h),
                      Text(
                        'عن المتجر:',
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        merchant.description,
                        style: TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          fontSize: 12.sp,
                          color: context.colors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],

                    SizedBox(height: 16.h),

                    // Reviews
                    ReviewsSectionWidget(
                      endpoint: EndPoints.merchantReviews(merchant.id),
                      title: 'تقييمات وآراء العملاء بالمتجر',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1B4270), size: 16.r),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 12.sp,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.colors.textSecondary,
              size: 11.r,
            ),
          ],
        ),
      ),
    );
  }
}

extension _SliverBoxExtension on Widget {
  Widget get toSliverBox => SliverToBoxAdapter(child: this);
}
