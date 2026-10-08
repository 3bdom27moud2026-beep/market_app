import 'package:equatable/equatable.dart';

/// Request payload model for POST /v1/card/request.
class CardRequestModel extends Equatable {
  final String deliveryAddress;
  final String phone;
  final String paymentMethod;

  const CardRequestModel({
    required this.deliveryAddress,
    required this.phone,
    this.paymentMethod = 'cash',
  });

  Map<String, dynamic> toJson() => {
    'delivery_address': deliveryAddress,
    'phone': phone,
    'payment_method': paymentMethod,
  };

  factory CardRequestModel.fromJson(Map<String, dynamic> json) {
    return CardRequestModel(
      deliveryAddress: json['delivery_address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? 'cash',
    );
  }

  @override
  List<Object?> get props => [deliveryAddress, phone, paymentMethod];
}
