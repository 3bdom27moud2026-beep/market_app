import 'package:equatable/equatable.dart';

/// Represents the user's card details.
class UserCardEntity extends Equatable {
  final int id;
  final int userId;
  final String cardNo;
  final String type;
  final String status;
  final double totalSavings;
  final String? activatedAt;
  final String? expiresAt;
  final String? createdAt;
  final String? updatedAt;

  const UserCardEntity({
    required this.id,
    required this.userId,
    required this.cardNo,
    required this.type,
    required this.status,
    required this.totalSavings,
    this.activatedAt,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  bool get isActive => status.toLowerCase() == 'active';
  bool get isPending => status.toLowerCase() == 'pending';

  int get daysRemaining {
    if (expiresAt == null) return 0;
    final dt = DateTime.tryParse(expiresAt!);
    if (dt == null) return 0;
    final diff = dt.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    cardNo,
    type,
    status,
    totalSavings,
    activatedAt,
    expiresAt,
    createdAt,
    updatedAt,
  ];
}

/// Represents the user's profile information.
class ProfileEntity extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final UserCardEntity? card;
  final int pointsBalance;
  final double pointsValueEgp;
  final String? referralCode;

  const ProfileEntity({
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

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber,
    avatarUrl,
    card,
    pointsBalance,
    pointsValueEgp,
    referralCode,
  ];
}

/// Represents the user's statistics.
class StatisticsEntity extends Equatable {
  final int ordersCount;
  final int favoritesCount;
  final int subscriptionDaysRemaining;

  const StatisticsEntity({
    required this.ordersCount,
    required this.favoritesCount,
    required this.subscriptionDaysRemaining,
  });

  @override
  List<Object?> get props => [
    ordersCount,
    favoritesCount,
    subscriptionDaysRemaining,
  ];
}

/// Represents the user's savings information.
class SavingsEntity extends Equatable {
  final double totalSavings;
  final String currency;

  const SavingsEntity({required this.totalSavings, this.currency = 'ج.م'});

  @override
  List<Object?> get props => [totalSavings, currency];
}

/// Aggregate entity that holds all profile screen data.
class ProfileDataEntity extends Equatable {
  final ProfileEntity profile;
  final StatisticsEntity statistics;
  final SavingsEntity savings;

  const ProfileDataEntity({
    required this.profile,
    required this.statistics,
    required this.savings,
  });

  @override
  List<Object?> get props => [profile, statistics, savings];
}
