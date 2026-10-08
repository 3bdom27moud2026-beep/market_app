import 'package:equatable/equatable.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';

/// Entity representing an individual authoritative item in the shopping cart.
class CartItemEntity extends Equatable {
  /// The unique backend cart line-item ID (e.g. 16).
  final int id;

  /// The quantity of this line-item in the cart.
  final int qty;

  /// Authoritative backend line subtotal.
  final num lineTotal;

  /// Authoritative backend line savings/discount amount.
  final num lineSavings;

  /// The nested canonical Product entity.
  final ProductEntity product;

  const CartItemEntity({
    required this.id,
    required this.qty,
    required this.lineTotal,
    required this.lineSavings,
    required this.product,
  });

  // Convenience getters mapping to nested canonical ProductEntity
  String get name => product.name;
  String get storeName => product.store;
  String get imageUrl => product.image;
  double get price =>
      product.displayPrice > 0 ? product.displayPrice : product.price;
  double? get oldPrice => product.oldPrice > 0 ? product.oldPrice : null;
  int get quantity => qty;
  int get maxStock => product.stock > 0 ? product.stock : 99;
  bool get inStock => product.stock > 0;
  double? get discountPercentage =>
      product.discount > 0 ? product.discount.toDouble() : null;

  CartItemEntity copyWith({
    int? id,
    int? qty,
    num? lineTotal,
    num? lineSavings,
    ProductEntity? product,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      qty: qty ?? this.qty,
      lineTotal: lineTotal ?? this.lineTotal,
      lineSavings: lineSavings ?? this.lineSavings,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [id, qty, lineTotal, lineSavings, product];
}
