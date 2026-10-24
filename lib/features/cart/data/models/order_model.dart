import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import 'cart_item_model.dart';
import 'delivery_address_model.dart';
import 'merchant_model.dart';
import 'payment_method_model.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    super.orderNo,
    super.userId,
    super.merchantId,
    super.totalPrice,
    super.savings,
    super.paymentMethodType,
    super.status,
    required super.createdAt,
    required super.updatedAt,
    super.merchant,
    super.items,
    super.address,
    super.paymentMethod,
    super.pointsDiscount = 0.0,
    super.earnedPoints = 0,
    super.savedAmount = 0.0,
    super.shareMessage = '',
    super.shareUrl = '',
    super.trackingUrl,
    super.trackingNumber,
  });

  /// Factory to parse from the root API response (handles {"status": true, "orders": [...]})
  factory OrderModel.fromApiResponse(Map<String, dynamic> json) {
    if (json['orders'] is List && (json['orders'] as List).isNotEmpty) {
      final firstOrder = (json['orders'] as List).first;
      if (firstOrder is Map<String, dynamic>) {
        return OrderModel.fromJson(firstOrder);
      }
    }
    return OrderModel.fromJson(json);
  }

  /// Factory to parse a single order JSON map
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final int idVal = _parseInt(json['id']);
    final String orderNoVal =
        json['order_no']?.toString() ??
        json['order_id']?.toString() ??
        (idVal > 0 ? idVal.toString() : '');
    final int userIdVal = _parseInt(json['user_id']);
    final int merchantIdVal = _parseInt(json['merchant_id']);
    final double totalPriceVal = _parseDouble(
      json['total_price'] ?? json['total'],
    );
    final double savingsVal = _parseDouble(
      json['savings'] ?? json['discount_amount'],
    );
    final String paymentMethodTypeVal =
        json['payment_method']?.toString() ?? 'cash';

    // Safely check if status is String (avoiding boolean cast error if root JSON is passed)
    final String statusVal = json['status'] is String
        ? json['status'] as String
        : 'pending';

    final DateTime createdDate =
        DateTime.tryParse(
          json['created_at']?.toString() ??
              json['order_date']?.toString() ??
              '',
        ) ??
        DateTime.now();

    final DateTime updatedDate =
        DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? createdDate;

    final merchantModel = json['merchant'] is Map<String, dynamic>
        ? MerchantModel.fromJson(json['merchant'] as Map<String, dynamic>)
        : null;

    final List<CartItemModel> itemsList =
        (json['items'] as List<dynamic>?)
            ?.map(
              (e) => CartItemModel.fromJson(
                e is Map<String, dynamic> ? e : <String, dynamic>{},
              ),
            )
            .toList() ??
        const [];

    final addressModel = json['address'] is Map<String, dynamic>
        ? DeliveryAddressModel.fromJson(json['address'] as Map<String, dynamic>)
        : null;

    final paymentMethodModel =
        json['payment_method_details'] is Map<String, dynamic>
        ? PaymentMethodModel.fromJson(
            json['payment_method_details'] as Map<String, dynamic>,
          )
        : PaymentMethodModel(
            id: paymentMethodTypeVal,
            title: paymentMethodTypeVal == 'cash'
                ? 'الدفع عند الاستلام'
                : paymentMethodTypeVal,
            subtitle: '',
            type: PaymentType.cashOnDelivery,
            icon: '',
          );

    final double pointsDiscountVal = _parseDouble(json['points_discount']);
    final int earnedPointsVal = _parseInt(
      json['earned_points'],
      (totalPriceVal / 10).floor(),
    );
    final double savedAmountVal = _parseDouble(
      json['saved_amount'] ?? savingsVal,
    );
    final String shareMessageVal =
        json['share_message']?.toString() ??
        'وفرت ${savedAmountVal.toStringAsFixed(0)} ج.م في طلبي من شوب جايد!';
    final String shareUrlVal =
        json['share_url']?.toString() ?? 'https://shopguide.medguide.software';

    String? trackingUrlVal;
    String? trackingNumberVal;
    if (json['shipping'] is Map) {
      trackingUrlVal = json['shipping']['tracking_url']?.toString();
      trackingNumberVal = json['shipping']['tracking_number']?.toString();
    }

    return OrderModel(
      id: idVal,
      orderNo: orderNoVal,
      userId: userIdVal,
      merchantId: merchantIdVal,
      totalPrice: totalPriceVal,
      savings: savingsVal,
      paymentMethodType: paymentMethodTypeVal,
      status: statusVal,
      createdAt: createdDate,
      updatedAt: updatedDate,
      merchant: merchantModel,
      items: itemsList,
      address: addressModel,
      paymentMethod: paymentMethodModel,
      pointsDiscount: pointsDiscountVal,
      earnedPoints: earnedPointsVal,
      savedAmount: savedAmountVal,
      shareMessage: shareMessageVal,
      shareUrl: shareUrlVal,
      trackingUrl: trackingUrlVal,
      trackingNumber: trackingNumberVal,
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

  static double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'user_id': userId,
      'merchant_id': merchantId,
      'total_price': totalPrice,
      'savings': savings,
      'payment_method': paymentMethodType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items
          .map(
            (e) => (e is CartItemModel)
                ? e.toJson()
                : {
                    'id': e.id,
                    'qty': e.qty,
                    'line_total': e.lineTotal,
                    'line_savings': e.lineSavings,
                  },
          )
          .toList(),
    };
  }
}
