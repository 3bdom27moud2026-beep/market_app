import 'package:market/features/products/data/models/product_model.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.qty,
    required super.lineTotal,
    required super.lineSavings,
    required super.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final int idVal = _parseInt(json['id']);
    final int qtyVal = _parseInt(json['qty'] ?? json['quantity'], 1);
    final num lineTotalVal = _parseNum(
      json['line_total'] ?? json['price'] ?? json['total_price'],
    );
    final num lineSavingsVal = _parseNum(
      json['line_savings'] ?? json['savings'],
    );

    final Map<String, dynamic> productMap =
        json['product'] is Map<String, dynamic>
        ? json['product'] as Map<String, dynamic>
        : json;

    final productModel = ProductModel.fromJson(productMap).toEntity();

    return CartItemModel(
      id: idVal,
      qty: qtyVal,
      lineTotal: lineTotalVal,
      lineSavings: lineSavingsVal,
      product: productModel,
    );
  }

  static int _parseInt(dynamic value, [int defaultValue = 0]) {
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ??
          (double.tryParse(value)?.toInt() ?? defaultValue);
    }
    return defaultValue;
  }

  static num _parseNum(dynamic value, [num defaultValue = 0.0]) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'line_total': lineTotal,
      'line_savings': lineSavings,
      'product': {
        'id': product.id,
        'name': product.name,
        'store': product.store,
        'image': product.image,
        'price': product.price,
        'old_price': product.oldPrice,
        'discount': product.discount,
        'rating': product.rating,
        'description': product.description,
        'brand': product.brand,
        'stock': product.stock,
      },
    };
  }
}
