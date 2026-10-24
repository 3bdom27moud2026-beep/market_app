import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:market/features/categories/presentation/cubit/categories_state.dart';
import 'package:market/features/categories/presentation/widgets/categories_banner.dart';
import 'package:market/features/categories/presentation/widgets/categories_grid.dart';
import 'package:market/features/categories/presentation/widgets/categories_error.dart';
import 'package:market/features/categories/presentation/widgets/categories_loading.dart';
import 'package:market/features/categories/presentation/widgets/category_search_field.dart';
import 'package:market/features/categories/presentation/widgets/category_type_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/home/presentation/widgets/home_app_bar.dart';

/// Categories Screen - displays all categories in a grid layout.
///
/// This screen is accessed from the home screen by tapping "عرض الكل"
/// in the categories section.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Load categories only if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final cubit = context.read<CategoriesCubit>();
      if (cubit.state is CategoriesInitial) {
        cubit.loadCategories();
      }
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? context.colors.background : const Color(0xFFF8FAFC),
      appBar: const HomeAppBar(),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const CategoriesLoadingWidget();
          }

          if (state is CategoriesError) {
            return CategoriesErrorWidget(
              message: state.errorMessage,
              onRetry: () => context.read<CategoriesCubit>().loadCategories(),
            );
          }

          if (state is CategoriesEmpty) {
            return const _EmptyView();
          }

          if (state is CategoriesLoaded) {
            return _CategoriesContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  final CategoriesLoaded state;

  const _CategoriesContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor =
        isDark ? context.colors.border : const Color(0xFFE2E8F0);
    final cardBg = isDark ? context.colors.surface : Colors.white;

    return CustomScrollView(
      slivers: [
        // Banner Section
        SliverToBoxAdapter(
          child: CategoriesBanner(
            banner: state.banner,
            purchaseMode: state.purchaseMode,
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 16.h)),

        // Purchase Mode Switch
        SliverToBoxAdapter(
          child: CategoryTypeSwitch(
            selectedMode: state.purchaseMode,
            onModeChanged: (mode) => cubit.changePurchaseMode(mode),
          ),
        ),

        // Divider between Switch and Search Field matching screenshot
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Divider(
              color: cardBorderColor,
              thickness: 1.h,
              height: 1.h,
            ),
          ),
        ),

        // Search Field
        SliverToBoxAdapter(
          child: CategorySearchField(
            onSearch: cubit.searchCategories,
            initialValue: state.searchQuery,
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 16.h)),

        // Categories Card Container matching the screenshot
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: cardBorderColor, width: 1.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(10.w, 18.h, 10.w, 20.h),
              child: CategoriesGrid(
                categories: state.filteredCategories,
                onCategoryTap: (categoryId) {
                  final category = state.filteredCategories.firstWhere(
                    (c) => c.id == categoryId,
                    orElse: () => state.filteredCategories.first,
                  );
                  CacheHelper.setSelectedCategoryId(categoryId);
                  context.push(
                    '${AppRoutes.merchants}?categoryId=$categoryId&name=${Uri.encodeComponent(category.name)}',
                  );
                },
              ),
            ),
          ),
        ),

        // Bottom padding
        SliverToBoxAdapter(child: SizedBox(height: AppSpacing.huge.h)),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64.r,
              color: context.colors.textQuaternary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'لا توجد فئات متاحة',
              style: AppTextStyles.bodyLarge.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
