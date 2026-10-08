import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';

/// JSON-serializable model for discount statistics.
class StatisticsModel extends StatisticsEntity {
  const StatisticsModel({
    required super.id,
    required super.title,
    required super.value,
    required super.icon,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      id: json['id']?.toString() ?? '',
      title: (json['title'] ?? json['name'] ?? json['label'] ?? '').toString(),
      value: (json['value'] ?? json['count'] ?? json['stat'] ?? json['number'] ?? '').toString(),
      icon: (json['icon'] ?? json['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'value': value,
    'icon': icon,
  };
}
