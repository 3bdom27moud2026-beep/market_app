import '../../domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  const SubscriptionPlanModel({
    required super.id,
    required super.planId,
    required super.planType,
    required super.name,
    required super.durationMonths,
    super.durationDays,
    required super.durationLabel,
    required super.price,
    required super.priceLabel,
    required super.monthlyEquivalent,
    required super.description,
    required super.isActive,
    super.badge,
    required super.color,
    required super.icon,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id']?.toString() ?? '',
      planId: (json['plan_id'] as num?)?.toInt() ?? 0,
      planType: json['plan_type']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      durationMonths: (json['duration_months'] as num?)?.toInt() ?? 1,
      durationDays: (json['duration_days'] as num?)?.toInt(),
      durationLabel: json['duration_label']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceLabel: json['price_label']?.toString() ?? '',
      monthlyEquivalent:
          (json['monthly_equivalent'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? true,
      badge: json['badge']?.toString(),
      color: json['color']?.toString() ?? '#10b981',
      icon: json['icon']?.toString() ?? 'calendar',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'plan_type': planType,
      'name': name,
      'duration_months': durationMonths,
      'duration_days': durationDays,
      'duration_label': durationLabel,
      'price': price,
      'price_label': priceLabel,
      'monthly_equivalent': monthlyEquivalent,
      'description': description,
      'is_active': isActive,
      'badge': badge,
      'color': color,
      'icon': icon,
    };
  }
}
