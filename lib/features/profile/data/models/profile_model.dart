import 'package:market/core/utils/image_url_formatter.dart';
import '../../domain/entities/profile_entity.dart';

/// Model for user card details from API.
class UserCardModel extends UserCardEntity {
  const UserCardModel({
    required super.id,
    required super.userId,
    required super.cardNo,
    required super.type,
    required super.status,
    required super.totalSavings,
    super.activatedAt,
    super.expiresAt,
    super.createdAt,
    super.updatedAt,
  });

  /// Creates a [UserCardModel] from JSON.
  factory UserCardModel.fromJson(Map<String, dynamic> json) {
    return UserCardModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      cardNo:
          json['card_no']?.toString() ?? json['coupon_code']?.toString() ?? '',
      type: json['type']?.toString() ?? 'monthly',
      status: json['status']?.toString() ?? 'inactive',
      totalSavings: (json['total_savings'] as num?)?.toDouble() ?? 0.0,
      activatedAt: json['activated_at']?.toString(),
      expiresAt: json['expires_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  /// Converts this [UserCardModel] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'card_no': cardNo,
      'type': type,
      'status': status,
      'total_savings': totalSavings,
      'activated_at': activatedAt,
      'expires_at': expiresAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserCardEntity toEntity() => this;
}

/// Model for user profile data from API.
class ProfileModel {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final UserCardModel? card;
  final int pointsBalance;
  final double pointsValueEgp;
  final String? referralCode;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.card,
    this.pointsBalance = 0,
    this.pointsValueEgp = 0.0,
    this.referralCode,
  });

  /// Creates a [ProfileModel] from JSON.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final cardJson = json['card'] is Map<String, dynamic>
        ? json['card'] as Map<String, dynamic>
        : null;

    final String? rawAvatar =
        json['avatar']?.toString() ?? json['avatar_url']?.toString();

    final int parsedPoints =
        (json['points_balance'] as num?)?.toInt() ??
        (json['points'] as num?)?.toInt() ??
        0;

    final double parsedPointsValue =
        (json['points_value_egp'] as num?)?.toDouble() ??
        (json['points_value'] as num?)?.toDouble() ??
        (parsedPoints * 0.1);

    return ProfileModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: json['name']?.toString() ?? json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber:
          json['phone']?.toString() ?? json['phone_number']?.toString(),
      avatarUrl: _formatAvatarUrl(rawAvatar),
      card: cardJson != null ? UserCardModel.fromJson(cardJson) : null,
      pointsBalance: parsedPoints,
      pointsValueEgp: parsedPointsValue,
      referralCode: json['referral_code']?.toString(),
    );
  }

  static String? _formatAvatarUrl(String? raw) => ImageUrlFormatter.format(raw);

  /// Converts this [ProfileModel] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'points_balance': pointsBalance,
      'points_value_egp': pointsValueEgp,
      if (referralCode != null) 'referral_code': referralCode,
      if (card != null) 'card': card!.toJson(),
    };
  }

  /// Converts this [ProfileModel] to a [ProfileEntity].
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      card: card?.toEntity(),
      pointsBalance: pointsBalance,
      pointsValueEgp: pointsValueEgp,
      referralCode: referralCode,
    );
  }
}

/// Model for statistics data from API.
class StatisticsModel {
  final int ordersCount;
  final int favoritesCount;
  final int subscriptionDaysRemaining;

  const StatisticsModel({
    required this.ordersCount,
    required this.favoritesCount,
    required this.subscriptionDaysRemaining,
  });

  StatisticsModel copyWith({
    int? ordersCount,
    int? favoritesCount,
    int? subscriptionDaysRemaining,
  }) {
    return StatisticsModel(
      ordersCount: ordersCount ?? this.ordersCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      subscriptionDaysRemaining:
          subscriptionDaysRemaining ?? this.subscriptionDaysRemaining,
    );
  }

  /// Creates a [StatisticsModel] from JSON.
  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    int daysRemaining = 0;
    if (json['card'] is Map<String, dynamic>) {
      final cardMap = json['card'] as Map<String, dynamic>;
      final expiresStr = cardMap['expires_at']?.toString();
      if (expiresStr != null) {
        final expiresAt = DateTime.tryParse(expiresStr);
        if (expiresAt != null) {
          final diff = expiresAt.difference(DateTime.now()).inDays;
          daysRemaining = diff > 0 ? diff : 0;
        }
      }
    } else if (json['subscription_days_remaining'] != null) {
      daysRemaining = (json['subscription_days_remaining'] as num).toInt();
    } else if (json['days_remaining'] != null) {
      daysRemaining = (json['days_remaining'] as num).toInt();
    }

    final int orders =
        (json['orders_count'] as num?)?.toInt() ??
        (json['requests_count'] as num?)?.toInt() ??
        (json['total_orders'] as num?)?.toInt() ??
        (json['total_requests'] as num?)?.toInt() ??
        (json['ordersCount'] as num?)?.toInt() ??
        (json['orders'] is List
            ? (json['orders'] as List).length
            : (json['orders'] as num?)?.toInt()) ??
        (json['requests'] is List
            ? (json['requests'] as List).length
            : (json['requests'] as num?)?.toInt()) ??
        0;

    final int favorites =
        (json['favorites_count'] as num?)?.toInt() ??
        (json['favourites_count'] as num?)?.toInt() ??
        (json['total_favorites'] as num?)?.toInt() ??
        (json['total_favourites'] as num?)?.toInt() ??
        (json['favoritesCount'] as num?)?.toInt() ??
        (json['favorites'] is List
            ? (json['favorites'] as List).length
            : (json['favorites'] as num?)?.toInt()) ??
        (json['favourites'] is List
            ? (json['favourites'] as List).length
            : (json['favourites'] as num?)?.toInt()) ??
        0;

    return StatisticsModel(
      ordersCount: orders,
      favoritesCount: favorites,
      subscriptionDaysRemaining: daysRemaining,
    );
  }

  /// Converts this [StatisticsModel] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'orders_count': ordersCount,
      'favorites_count': favoritesCount,
      'subscription_days_remaining': subscriptionDaysRemaining,
    };
  }

  /// Converts this [StatisticsModel] to a [StatisticsEntity].
  StatisticsEntity toEntity() {
    return StatisticsEntity(
      ordersCount: ordersCount,
      favoritesCount: favoritesCount,
      subscriptionDaysRemaining: subscriptionDaysRemaining,
    );
  }
}

/// Model for savings data from API.
class SavingsModel {
  final double totalSavings;
  final String currency;

  const SavingsModel({required this.totalSavings, this.currency = 'ج.م'});

  /// Creates a [SavingsModel] from JSON.
  factory SavingsModel.fromJson(Map<String, dynamic> json) {
    double savings = 0.0;
    if (json['card'] is Map<String, dynamic>) {
      final cardMap = json['card'] as Map<String, dynamic>;
      savings = (cardMap['total_savings'] as num?)?.toDouble() ?? 0.0;
    } else if (json['total_savings'] != null) {
      savings = (json['total_savings'] as num).toDouble();
    }

    return SavingsModel(
      totalSavings: savings,
      currency: json['currency']?.toString() ?? 'ج.م',
    );
  }

  /// Converts this [SavingsModel] to JSON.
  Map<String, dynamic> toJson() {
    return {'total_savings': totalSavings, 'currency': currency};
  }

  /// Converts this [SavingsModel] to a [SavingsEntity].
  SavingsEntity toEntity() {
    return SavingsEntity(totalSavings: totalSavings, currency: currency);
  }
}

/// Model for the complete profile data response from API.
class ProfileDataModel {
  final ProfileModel profile;
  final StatisticsModel statistics;
  final SavingsModel savings;

  const ProfileDataModel({
    required this.profile,
    required this.statistics,
    required this.savings,
  });

  ProfileDataModel copyWith({
    ProfileModel? profile,
    StatisticsModel? statistics,
    SavingsModel? savings,
  }) {
    return ProfileDataModel(
      profile: profile ?? this.profile,
      statistics: statistics ?? this.statistics,
      savings: savings ?? this.savings,
    );
  }

  /// Creates a [ProfileDataModel] from JSON payload.
  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final Map<String, dynamic> userMap = payload['user'] is Map<String, dynamic>
        ? payload['user'] as Map<String, dynamic>
        : (payload['profile'] is Map<String, dynamic>
              ? payload['profile'] as Map<String, dynamic>
              : payload);

    final Map<String, dynamic> statsSource = <String, dynamic>{
      ...payload,
      if (payload['statistics'] is Map<String, dynamic>)
        ...(payload['statistics'] as Map<String, dynamic>),
      if (payload['stats'] is Map<String, dynamic>)
        ...(payload['stats'] as Map<String, dynamic>),
      if (payload['counts'] is Map<String, dynamic>)
        ...(payload['counts'] as Map<String, dynamic>),
      ...userMap,
    };

    final Map<String, dynamic> savingsSource = <String, dynamic>{
      ...payload,
      if (payload['savings'] is Map<String, dynamic>)
        ...(payload['savings'] as Map<String, dynamic>),
      ...userMap,
    };

    return ProfileDataModel(
      profile: ProfileModel.fromJson(userMap),
      statistics: StatisticsModel.fromJson(statsSource),
      savings: SavingsModel.fromJson(savingsSource),
    );
  }

  /// Converts this [ProfileDataModel] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'user': profile.toJson(),
      'statistics': statistics.toJson(),
      'savings': savings.toJson(),
    };
  }

  /// Converts this [ProfileDataModel] to a [ProfileDataEntity].
  ProfileDataEntity toEntity() {
    return ProfileDataEntity(
      profile: profile.toEntity(),
      statistics: statistics.toEntity(),
      savings: savings.toEntity(),
    );
  }
}
