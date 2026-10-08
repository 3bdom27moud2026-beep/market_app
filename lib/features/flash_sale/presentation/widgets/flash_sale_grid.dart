import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/features/home/domain/entities/flash_sale_product_entity.dart';
import 'flash_sale_product_card.dart';

/// Responsive grid view for flash sale products.
class FlashSaleGrid extends StatelessWidget {
  final List<FlashSaleProductEntity> products;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoadingMore;

  const FlashSaleGrid({
    super.key,
    required this.products,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const FlashSaleEmptyView();
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.60,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: products.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final product = products[index];
          return FlashSaleProductCard(product: product);
        },
      ),
    );
  }
}

class FlashSaleEmptyView extends StatelessWidget {
  const FlashSaleEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'لا توجد عروض حالياً',
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
