import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

/// Enum for product details loading states.
enum ProductDetailsStatus { initial, loading, loaded, error }

/// State for [ProductDetailsCubit].
class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final String errorMessage;
  final ProductEntity? product;
  final bool isAddingToCart;
  final bool isAddedToCart;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.errorMessage = '',
    this.product,
    this.isAddingToCart = false,
    this.isAddedToCart = false,
  });

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    String? errorMessage,
    ProductEntity? product,
    bool? isAddingToCart,
    bool? isAddedToCart,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      product: product ?? this.product,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
      isAddedToCart: isAddedToCart ?? this.isAddedToCart,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        product,
        isAddingToCart,
        isAddedToCart,
      ];
}
