import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/profile/data/models/profile_model.dart'
    show UserCardModel;
import 'package:market/features/discount_card/data/models/statistics_model.dart';
import 'package:market/features/discount_card/data/models/category_model.dart';
import 'package:market/features/discount_card/data/models/benefit_model.dart';

/// JSON-serializable model wrapping all discount card data.
class DiscountCardDataModel extends DiscountCardDataEntity {
  const DiscountCardDataModel({
    super.card,
    required super.statistics,
    required super.categories,
    required super.benefits,
  });

  factory DiscountCardDataModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;

    final dynamic rawCard = userMap != null ? userMap['card'] : json['card'];

    final Map<String, dynamic>? cardJson = rawCard is Map<String, dynamic>
        ? rawCard
        : null;

    final UserCardModel? parsedCard = cardJson != null
        ? UserCardModel.fromJson(cardJson)
        : null;

    return DiscountCardDataModel(
      card: parsedCard,
      statistics:
          (json['statistics'] as List<dynamic>?)
              ?.map((e) => StatisticsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map(
                (e) =>
                    DiscountCategoryModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((e) => BenefitModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    if (card != null) 'card': (card as UserCardModel).toJson(),
    'statistics': statistics
        .map((e) => (e as StatisticsModel).toJson())
        .toList(),
    'categories': categories
        .map((e) => (e as DiscountCategoryModel).toJson())
        .toList(),
    'benefits': benefits.map((e) => (e as BenefitModel).toJson()).toList(),
    'is_subscribed': isSubscribed,
  };
}
