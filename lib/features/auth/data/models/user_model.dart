import 'dart:convert';
import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/profile/data/models/profile_model.dart';

/// Data model extending [UserEntity] for JSON serialization/deserialization.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.token,
    super.areaId,
    super.isActive,
    super.card,
    super.refreshToken,
    super.expiresAt,
  });

  /// Factory constructor to create a [UserModel] from backend JSON response.
  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    final userData = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    final String extractedToken =
        token ??
        (json['token'] as String? ?? json['access_token'] as String? ?? '');

    final String? extractedRefreshToken =
        json['refresh_token'] as String? ?? json['refreshToken'] as String?;

    final String? expiresAtStr =
        json['expires_at'] as String? ?? json['expiresAt'] as String?;

    final int? areaId = userData['area_id'] is int
        ? userData['area_id'] as int
        : int.tryParse(userData['area_id']?.toString() ?? '');

    final bool? isActive = userData['is_active'] as bool?;

    final Map<String, dynamic>? cardJson =
        userData['card'] is Map<String, dynamic>
        ? userData['card'] as Map<String, dynamic>
        : null;

    final UserCardModel? cardModel = cardJson != null
        ? UserCardModel.fromJson(cardJson)
        : null;

    return UserModel(
      id: (userData['id'] ?? userData['_id'] ?? '').toString(),
      name: (userData['name'] ?? '').toString(),
      email: (userData['email'] ?? '').toString(),
      phone: (userData['phone'] ?? userData['phone_number'] ?? '').toString(),
      token: extractedToken,
      areaId: areaId,
      isActive: isActive,
      card: cardModel,
      refreshToken: extractedRefreshToken,
      expiresAt: expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null,
    );
  }

  /// Converts [UserModel] into a JSON map for local caching.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'token': token,
      if (areaId != null) 'area_id': areaId,
      if (isActive != null) 'is_active': isActive,
      if (card != null)
        'card': (card is UserCardModel)
            ? (card as UserCardModel).toJson()
            : {
                'id': card!.id,
                'user_id': card!.userId,
                'card_no': card!.cardNo,
                'type': card!.type,
                'status': card!.status,
                'total_savings': card!.totalSavings,
                'activated_at': card!.activatedAt,
                'expires_at': card!.expiresAt,
                'created_at': card!.createdAt,
                'updated_at': card!.updatedAt,
              },
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }

  /// Converts [UserModel] into a JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Creates [UserModel] from cached JSON string.
  factory UserModel.fromJsonString(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    final expiresAtStr = map['expires_at'] as String?;
    final int? areaId = map['area_id'] is int
        ? map['area_id'] as int
        : int.tryParse(map['area_id']?.toString() ?? '');

    final Map<String, dynamic>? cardMap = map['card'] is Map<String, dynamic>
        ? map['card'] as Map<String, dynamic>
        : null;

    final UserCardModel? cardModel = cardMap != null
        ? UserCardModel.fromJson(cardMap)
        : null;

    return UserModel(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      token: (map['token'] ?? '').toString(),
      areaId: areaId,
      isActive: map['is_active'] as bool?,
      card: cardModel,
      refreshToken: map['refresh_token'] as String?,
      expiresAt: expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null,
    );
  }
}
