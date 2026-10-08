import 'package:equatable/equatable.dart';

enum PaymentType {
  cashOnDelivery,
  visaMastercard,
  applePay,
  googlePay,
  vodafoneCash,
  wallet,
}

/// Entity representing payment options.
class PaymentMethodEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final PaymentType type;
  final String icon;
  final bool isAvailable;

  const PaymentMethodEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [id, title, subtitle, type, icon, isAvailable];
}
