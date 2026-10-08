import 'package:equatable/equatable.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

/// Result entity for annual subscription / renewal (POST /v1/card/subscribe).
class CardSubscriptionResultEntity extends Equatable {
  final bool status;
  final String message;
  final UserCardEntity? card;

  const CardSubscriptionResultEntity({
    required this.status,
    required this.message,
    this.card,
  });

  @override
  List<Object?> get props => [status, message, card];
}
