import 'package:equatable/equatable.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';

/// Business entity representing an authenticated user with token lifecycle data.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;
  final int? areaId;
  final bool? isActive;
  final UserCardEntity? card;
  final String? refreshToken;
  final DateTime? expiresAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    this.areaId,
    this.isActive,
    this.card,
    this.refreshToken,
    this.expiresAt,
  });

  bool get isTokenExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    token,
    areaId,
    isActive,
    card,
    refreshToken,
    expiresAt,
  ];
}
