import 'package:equatable/equatable.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';

/// Entity representing search results containing products and merchants.
class SearchResultEntity extends Equatable {
  final List<ProductEntity> products;
  final List<MerchantEntity> merchants;

  const SearchResultEntity({
    this.products = const [],
    this.merchants = const [],
  });

  bool get isEmpty => products.isEmpty && merchants.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [products, merchants];
}
