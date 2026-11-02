import 'package:equatable/equatable.dart';

/// Represents a dynamic subscription plan for the discount card.
class SubscriptionPlanEntity extends Equatable {
  final String id;
  final int planId;
  final String planType;
  final String name;
  final int durationMonths;
  final int? durationDays;
  final String durationLabel;
  final double price;
  final String priceLabel;
  final double monthlyEquivalent;
  final String description;
  final bool isActive;
  final String? badge;
  final String color;
  final String icon;

  const SubscriptionPlanEntity({
    required this.id,
    required this.planId,
    required this.planType,
    required this.name,
    required this.durationMonths,
    this.durationDays,
    required this.durationLabel,
    required this.price,
    required this.priceLabel,
    required this.monthlyEquivalent,
    required this.description,
    required this.isActive,
    this.badge,
    required this.color,
    required this.icon,
  });

  @override
  List<Object?> get props => [
    id,
    planId,
    planType,
    name,
    durationMonths,
    durationDays,
    durationLabel,
    price,
    priceLabel,
    monthlyEquivalent,
    description,
    isActive,
    badge,
    color,
    icon,
  ];
}
