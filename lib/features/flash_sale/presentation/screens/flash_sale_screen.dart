import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/features/flash_sale/domain/entities/flash_sale_entity.dart';
import 'package:market/features/flash_sale/presentation/cubit/flash_sale_cubit.dart';
import 'package:market/features/flash_sale/presentation/cubit/flash_sale_state.dart';
import 'package:market/features/flash_sale/presentation/widgets/category_filter_section.dart';
import 'package:market/features/flash_sale/presentation/widgets/sort_filter_section.dart';
import 'package:market/features/flash_sale/presentation/widgets/flash_sale_header.dart';
import 'package:market/features/flash_sale/presentation/widgets/flash_sale_grid.dart';
import 'package:market/features/flash_sale/presentation/widgets/loading_view.dart';
import 'package:market/features/flash_sale/presentation/widgets/error_view.dart';

/// Flash Sale Screen - displays flash sale products with filters and sorting.
class FlashSaleScreen extends StatefulWidget {
  const FlashSaleScreen({super.key});

  @override
  State<FlashSaleScreen> createState() => _FlashSaleScreenState();
}

class _FlashSaleScreenState extends State<FlashSaleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlashSaleCubit>().loadFlashSale();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocBuilder<FlashSaleCubit, FlashSaleState>(
        builder: (context, state) {
          switch (state.status) {
            case FlashSaleLoadingStatus.initial:
            case FlashSaleLoadingStatus.loading:
              return const FlashSaleLoadingView();
            case FlashSaleLoadingStatus.error:
              return FlashSaleErrorView(
                message: state.errorMessage,
                onRetry: () => context.read<FlashSaleCubit>().loadFlashSale(),
              );
            case FlashSaleLoadingStatus.loaded:
            case FlashSaleLoadingStatus.refreshing:
            case FlashSaleLoadingStatus.loadingMore:
              return _FlashSaleContent(state: state);
          }
        },
      ),
    );
  }
}

class _FlashSaleContent extends StatelessWidget {
  final FlashSaleState state;

  const _FlashSaleContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FlashSaleCubit>();

    return RefreshIndicator(
      onRefresh: () => cubit.refresh(),
      child: CustomScrollView(
        slivers: [
          // Header with countdown
          SliverToBoxAdapter(
            child: FlashSaleHeader(
              onBack: () => context.pop(),
              countdown:
                  state.countdown ??
                  const CountdownEntity(
                    days: 0,
                    hours: 0,
                    minutes: 0,
                    seconds: 0,
                  ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg.h)),
          // Category filter
          SliverToBoxAdapter(
            child: CategoryFilterSection(
              categories: state.categories,
              selectedCategory: state.selectedCategory,
              onCategoryChanged: (category) => cubit.changeCategory(category),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg.h)),
          // Sort filter
          SliverToBoxAdapter(
            child: SortFilterSection(
              selectedSort: state.selectedSort,
              onSortChanged: (sort) => cubit.changeSort(sort),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg.h)),
          // Products count
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Text(
                '${state.total} منتج',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md.h)),
          // Products grid
          SliverToBoxAdapter(
            child: FlashSaleGrid(
              products: state.products,
              onLoadMore: cubit.loadMore,
              hasMore: state.hasMore,
              isLoadingMore: state.status == FlashSaleLoadingStatus.loadingMore,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppSpacing.huge.h)),
        ],
      ),
    );
  }
}
