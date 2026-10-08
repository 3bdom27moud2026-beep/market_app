import 'package:equatable/equatable.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

/// Result entity for card request submission.
class CardRequestResultEntity extends Equatable {
  final bool status;
  final String message;
  final UserCardEntity? card;

  const CardRequestResultEntity({
    required this.status,
    required this.message,
    this.card,
  });

  @override
  List<Object?> get props => [status, message, card];
}
