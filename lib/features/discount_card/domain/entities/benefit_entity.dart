import 'package:equatable/equatable.dart';

/// Represents a single benefit of the ShopGuide card.
class BenefitEntity extends Equatable {
  final String id;
  final String icon;
  final String title;
  final String description;

  const BenefitEntity({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, icon, title, description];
}
