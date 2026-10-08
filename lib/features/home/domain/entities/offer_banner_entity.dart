import 'package:equatable/equatable.dart';

/// Represents a single offer banner/slider displayed in the home screen.
class OfferBannerEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String buttonText;
  final String discount;

  /// Navigation action type (e.g. 'flash_sale', 'merchants', 'category').
  final String actionType;

  /// Optional target ID for the action.
  final String? actionId;

  const OfferBannerEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
    required this.discount,
    this.actionType = '',
    this.actionId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    image,
    buttonText,
    discount,
    actionType,
    actionId,
  ];
}
