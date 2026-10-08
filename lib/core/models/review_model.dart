import 'package:equatable/equatable.dart';

/// Single user review model
class ReviewItemModel extends Equatable {
  final int id;
  final int? userId;
  final String userName;
  final double rating;
  final String comment;
  final bool isVerifiedBuyer;
  final String createdAt;

  const ReviewItemModel({
    required this.id,
    this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.isVerifiedBuyer,
    required this.createdAt,
  });

  factory ReviewItemModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;

    final dynamic rawUserId =
        json['user_id'] ??
        json['userId'] ??
        userMap?['id'] ??
        json['customer_id'];

    final int? parsedUserId = rawUserId is num
        ? rawUserId.toInt()
        : int.tryParse(rawUserId?.toString() ?? '');

    return ReviewItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: parsedUserId,
      userName:
          json['user_name']?.toString() ??
          userMap?['name']?.toString() ??
          json['name']?.toString() ??
          'عميل',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment']?.toString() ?? json['review']?.toString() ?? '',
      isVerifiedBuyer:
          json['is_verified_buyer'] == true ||
          json['is_verified'] == true ||
          json['verified'] == true,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    rating,
    comment,
    isVerifiedBuyer,
    createdAt,
  ];
}

/// Reviews response aggregate model
class ReviewsResponseModel extends Equatable {
  final bool status;
  final double averageRating;
  final int reviewCount;
  final Map<int, int> ratingBreakdown;
  final List<ReviewItemModel> reviews;
  final bool hasReviewed;
  final bool canReview;

  const ReviewsResponseModel({
    required this.status,
    required this.averageRating,
    required this.reviewCount,
    required this.ratingBreakdown,
    required this.reviews,
    this.hasReviewed = false,
    this.canReview = true,
  });

  factory ReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataMap = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : null;

    final Map<int, int> breakdown = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    final rawBreakdown =
        json['rating_breakdown'] ?? dataMap?['rating_breakdown'];
    if (rawBreakdown is Map) {
      rawBreakdown.forEach((k, v) {
        final keyInt = int.tryParse(k.toString());
        final valInt = (v as num?)?.toInt() ?? 0;
        if (keyInt != null) {
          breakdown[keyInt] = valInt;
        }
      });
    }

    final rawReviews = json['reviews'] ?? dataMap?['reviews'];
    final List<ReviewItemModel> reviewsList = [];
    if (rawReviews is List) {
      for (final r in rawReviews) {
        if (r is Map<String, dynamic>) {
          reviewsList.add(ReviewItemModel.fromJson(r));
        }
      }
    }

    final bool hasReviewed =
        json['has_reviewed'] == true ||
        json['has_reviewed'] == 1 ||
        json['user_has_reviewed'] == true ||
        json['user_has_reviewed'] == 1 ||
        json['already_reviewed'] == true ||
        json['already_reviewed'] == 1 ||
        json['hasReviewed'] == true ||
        dataMap?['has_reviewed'] == true ||
        dataMap?['has_reviewed'] == 1 ||
        dataMap?['user_has_reviewed'] == true ||
        dataMap?['user_has_reviewed'] == 1;

    final bool canReview =
        json['can_review'] != false &&
        json['can_review'] != 0 &&
        dataMap?['can_review'] != false &&
        dataMap?['can_review'] != 0;

    final double avg =
        (json['average_rating'] as num?)?.toDouble() ??
        (dataMap?['average_rating'] as num?)?.toDouble() ??
        0.0;

    final int count =
        (json['review_count'] as num?)?.toInt() ??
        (dataMap?['review_count'] as num?)?.toInt() ??
        reviewsList.length;

    return ReviewsResponseModel(
      status:
          json['status'] == true || json['status'] == 'true' || dataMap != null,
      averageRating: avg,
      reviewCount: count,
      ratingBreakdown: breakdown,
      reviews: reviewsList,
      hasReviewed: hasReviewed,
      canReview: canReview,
    );
  }

  @override
  List<Object?> get props => [
    status,
    averageRating,
    reviewCount,
    ratingBreakdown,
    reviews,
    hasReviewed,
    canReview,
  ];
}
