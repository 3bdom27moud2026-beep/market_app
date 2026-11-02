import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.id,
    required super.name,
    required super.number,
    required super.icon,
    required super.description,
    required super.actionLabel,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'wallet',
      description: json['description']?.toString() ?? '',
      actionLabel: json['action_label']?.toString() ?? 'نسخ الرقم',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'icon': icon,
      'description': description,
      'action_label': actionLabel,
    };
  }
}
