import 'package:equatable/equatable.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;
import 'statistics_entity.dart';
import 'category_entity.dart';
import 'benefit_entity.dart';

/// Aggregates all data for the discount card screen.
class DiscountCardDataEntity extends Equatable {
  final UserCardEntity? card;
  final List<StatisticsEntity> statistics;
  final List<DiscountCategoryEntity> categories;
  final List<BenefitEntity> benefits;

  const DiscountCardDataEntity({
    this.card,
    required this.statistics,
    required this.categories,
    required this.benefits,
  });

  bool get isSubscribed => card != null && card!.isActive;

  @override
  List<Object?> get props => [card, statistics, categories, benefits];
}
