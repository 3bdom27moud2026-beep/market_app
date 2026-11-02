import 'package:equatable/equatable.dart';

/// Represents an accepted payment method for card subscriptions (e.g. Cash Wallet, InstaPay).
class PaymentMethodEntity extends Equatable {
  final String id;
  final String name;
  final String number;
  final String icon;
  final String description;
  final String actionLabel;

  const PaymentMethodEntity({
    required this.id,
    required this.name,
    required this.number,
    required this.icon,
    required this.description,
    required this.actionLabel,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    number,
    icon,
    description,
    actionLabel,
  ];
}
