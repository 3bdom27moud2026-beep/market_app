import 'package:equatable/equatable.dart';

/// Represents a discount statistics item (max discount, average discount, partners).
class StatisticsEntity extends Equatable {
  final String id;
  final String title;
  final String value;
  final String icon;

  const StatisticsEntity({
    required this.id,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, value, icon];
}
