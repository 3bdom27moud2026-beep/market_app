import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.type,
    required super.icon,
    super.isAvailable,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    PaymentType parseType(String str) {
      switch (str) {
        case 'visaMastercard':
          return PaymentType.visaMastercard;
        case 'applePay':
          return PaymentType.applePay;
        case 'googlePay':
          return PaymentType.googlePay;
        case 'vodafoneCash':
          return PaymentType.vodafoneCash;
        case 'wallet':
          return PaymentType.wallet;
        case 'cashOnDelivery':
        default:
          return PaymentType.cashOnDelivery;
      }
    }

    return PaymentMethodModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      type: parseType(json['type'] as String? ?? ''),
      icon: json['icon'] as String? ?? '',
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type.name,
      'icon': icon,
      'is_available': isAvailable,
    };
  }
}
