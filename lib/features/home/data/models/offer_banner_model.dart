import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_formatter.dart';
import '../../domain/entities/offer_banner_entity.dart';

/// Data model for a home screen slider/banner. Maps the `sliders` API key.
class OfferBannerModel extends Equatable {
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

  const OfferBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
    required this.discount,
    this.actionType = '',
    this.actionId,
  });

  factory OfferBannerModel.fromJson(Map<String, dynamic> json) {
    final rawImg = json['image']?.toString() ?? '';
    return OfferBannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      image: ImageUrlFormatter.format(rawImg) ?? rawImg,
      buttonText:
          json['button_text']?.toString() ??
          json['buttonText']?.toString() ??
          '',
      discount: json['discount']?.toString() ?? '',
      actionType:
          json['action_type']?.toString() ??
          json['actionType']?.toString() ??
          '',
      actionId: json['action_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'buttonText': buttonText,
      'discount': discount,
      'action_type': actionType,
      if (actionId != null) 'action_id': actionId,
    };
  }

  /// Convert to entity.
  OfferBannerEntity toEntity() {
    return OfferBannerEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      image: image,
      buttonText: buttonText,
      discount: discount,
      actionType: actionType,
      actionId: actionId,
    );
  }

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
