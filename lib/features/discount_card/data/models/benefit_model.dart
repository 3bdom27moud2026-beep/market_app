import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';

/// JSON-serializable model for a benefit item.
class BenefitModel extends BenefitEntity {
  const BenefitModel({
    required super.id,
    required super.icon,
    required super.title,
    required super.description,
  });

  factory BenefitModel.fromJson(Map<String, dynamic> json) {
    return BenefitModel(
      id: json['id']?.toString() ?? '',
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'icon': icon,
    'title': title,
    'description': description,
  };
}
