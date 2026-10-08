import 'package:market/features/discount_card/domain/entities/card_subscription_result_entity.dart';
import 'package:market/features/profile/data/models/profile_model.dart'
    show UserCardModel;

/// Response model for POST /v1/card/subscribe.
class CardSubscriptionResponseModel extends CardSubscriptionResultEntity {
  const CardSubscriptionResponseModel({
    required super.status,
    required super.message,
    super.card,
  });

  factory CardSubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawCard = json['card'];
    final cardJson = rawCard is Map<String, dynamic> ? rawCard : null;

    return CardSubscriptionResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      card: cardJson != null ? UserCardModel.fromJson(cardJson) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    if (card != null) 'card': (card as UserCardModel).toJson(),
  };
}
