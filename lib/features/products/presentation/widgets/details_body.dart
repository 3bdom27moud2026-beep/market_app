import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';
import 'package:market/features/products/presentation/widgets/product_image_slider.dart';
import 'package:market/features/products/presentation/widgets/product_header.dart';
import 'package:market/features/products/presentation/widgets/product_price_card.dart';
import 'package:market/features/products/presentation/widgets/product_specifications_card.dart';
import 'package:market/core/widgets/reviews_section_widget.dart';
import 'package:market/core/utils/end_points.dart';

import 'package:market/features/products/presentation/widgets/product_installment_card.dart';

/// The main body content for product details when loaded.
class DetailsBody extends StatelessWidget {
  final ProductEntity product;

  const DetailsBody({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image framed in white card matching screenshot
          Hero(
            tag: 'product_image_${product.id}',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFEAECF0)),
                boxShadow: AppShadows.card,
              ),
              padding: EdgeInsets.all(10.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: AspectRatio(
                  aspectRatio: 16 / 11,
                  child: ProductImageSlider(
                    imageUrl: product.image,
                    images: product.images,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Product Header (Store, Title, Rating)
          ProductHeader(
            store: product.store,
            name: product.name,
            rating: product.rating,
            brand: product.brand,
            reviewCount: product.reviewCount,
          ),
          SizedBox(height: 14.h),

          // Price Card
          ProductPriceCard(
            price: product.price,
            oldPrice: product.oldPrice,
            discount: product.discount,
            savingsAmount: product.savingsAmount,
            isService: product.isPriceOnInspection,
          ),

          // Installment Card: Only shown if installment is supported in incoming data
          if (product.supportsInstallment) ...[
            SizedBox(height: 12.h),
            ProductInstallmentCard(product: product),
          ],

          // Technical Specifications Table
          if (product.specifications.isNotEmpty) ...[
            SizedBox(height: 16.h),
            ProductSpecificationsCard(specifications: product.specifications),
          ],

          // Description section
          if (product.description.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: const Color(0xFFEAECF0)),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الوصف',
                    style: TextStyle(
                      color: const Color(0xFF101828),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    product.description,
                    style: TextStyle(
                      color: const Color(0xFF475467),
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 16.h),

          // Customer Reviews Section
          ReviewsSectionWidget(
            endpoint: EndPoints.productReviews(product.id),
            title: 'تقييمات وآراء المشترين',
          ),

          // Bottom padding for the sticky button
          SizedBox(height: AppSpacing.xxxl.h),
        ],
      ),
    );
  }
}
