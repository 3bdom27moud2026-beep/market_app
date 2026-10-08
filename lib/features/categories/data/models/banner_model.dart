import 'package:equatable/equatable.dart';
import '../../domain/entities/banner_entity.dart';

/// Model class for BannerEntity.
///
/// Handles JSON serialization and deserialization.
class BannerModel extends Equatable {
  final String title;
  final String subtitle;
  final String image;

  const BannerModel({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'subtitle': subtitle, 'image': image};
  }

  BannerEntity toEntity() {
    return BannerEntity(title: title, subtitle: subtitle, image: image);
  }

  @override
  List<Object?> get props => [title, subtitle, image];
}
