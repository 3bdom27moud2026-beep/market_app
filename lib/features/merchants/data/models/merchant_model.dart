import 'package:market/core/utils/image_url_formatter.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';

/// Data model for merchant response from the API.
class MerchantModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String phone;
  final String whatsapp;
  final String email;
  final String address;
  final double lat;
  final double lng;
  final String discount;
  final String type;
  final double rating;
  final int reviewCount;
  final int orderCount;
  final bool supportsInstallment;
  final bool isWholesale;
  final String status;
  final String distance;
  final String categoryId;
  final Map<String, dynamic>? categoryJson;
  final Map<String, dynamic>? areaJson;
  final String? mapUrl;
  final List<String> gallery;

  const MerchantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.phone,
    required this.whatsapp,
    required this.email,
    required this.address,
    required this.lat,
    required this.lng,
    required this.discount,
    required this.type,
    required this.rating,
    required this.reviewCount,
    required this.orderCount,
    required this.supportsInstallment,
    required this.isWholesale,
    required this.status,
    required this.distance,
    this.categoryId = '',
    this.categoryJson,
    this.areaJson,
    this.mapUrl,
    this.gallery = const [],
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    // Extract category ID from all possible keys
    final String parsedCategoryId =
        json['category_id']?.toString() ??
        json['categoryId']?.toString() ??
        json['merchant_category_id']?.toString() ??
        (json['category'] is Map
            ? ((json['category'] as Map)['id']?.toString() ??
                  (json['category'] as Map)['category_id']?.toString() ??
                  '')
            : (json['category'] != null ? json['category'].toString() : ''));

    // Safely parse category map
    Map<String, dynamic>? parsedCategoryJson;
    if (json['category'] is Map<String, dynamic>) {
      parsedCategoryJson = json['category'] as Map<String, dynamic>;
    } else if (json['category'] is Map) {
      parsedCategoryJson = Map<String, dynamic>.from(json['category'] as Map);
    }

    return MerchantModel(
      id:
          (json['id'] as num?)?.toInt() ??
          int.tryParse(json['id']?.toString() ?? '') ??
          0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image:
          ImageUrlFormatter.format(
            json['image']?.toString() ??
                json['logo']?.toString() ??
                json['photo']?.toString() ??
                json['avatar']?.toString(),
          ) ??
          '',
      phone: json['phone']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      discount: json['discount']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      orderCount: (json['order_count'] as num?)?.toInt() ?? 0,
      supportsInstallment: json['supports_installment'] as bool? ?? false,
      isWholesale: json['is_wholesale'] as bool? ?? false,
      status: json['status']?.toString() ?? 'active',
      distance: json['distance']?.toString() ?? '',
      categoryId: parsedCategoryId,
      categoryJson: parsedCategoryJson,
      areaJson: json['area'] is Map<String, dynamic>
          ? json['area'] as Map<String, dynamic>
          : (json['area'] is Map
                ? Map<String, dynamic>.from(json['area'] as Map)
                : null),
      mapUrl: json['map_url']?.toString(),
      gallery: (json['gallery'] is List
          ? (json['gallery'] as List)
                .map(
                  (e) =>
                      ImageUrlFormatter.format(e?.toString()) ?? e.toString(),
                )
                .where((e) => e.isNotEmpty)
                .toList()
          : (json['images'] is List
                ? (json['images'] as List)
                      .map(
                        (e) =>
                            ImageUrlFormatter.format(e?.toString()) ??
                            e.toString(),
                      )
                      .where((e) => e.isNotEmpty)
                      .toList()
                : const <String>[])),
    );
  }

  MerchantEntity toEntity() {
    MerchantCategoryEntity? category;
    if (categoryJson != null) {
      category = MerchantCategoryEntity(
        id:
            (categoryJson!['id'] as num?)?.toInt() ??
            int.tryParse(categoryJson!['id']?.toString() ?? '') ??
            int.tryParse(categoryId) ??
            0,
        name: categoryJson!['name']?.toString() ?? '',
        slug: categoryJson!['slug']?.toString() ?? '',
        icon: categoryJson!['icon']?.toString() ?? '',
        color: categoryJson!['color']?.toString() ?? '',
        iconColor: categoryJson!['icon_color']?.toString() ?? '',
      );
    } else if (categoryId.isNotEmpty) {
      category = MerchantCategoryEntity(
        id: int.tryParse(categoryId) ?? 0,
        name: '',
        slug: '',
        icon: '',
        color: '',
        iconColor: '',
      );
    }

    AreaEntity? area;
    if (areaJson != null) {
      final centerJson = areaJson!['center'] as Map<String, dynamic>?;
      CenterEntity? center;
      if (centerJson != null) {
        final govJson = centerJson['governorate'] as Map<String, dynamic>?;
        GovernorateEntity? governorate;
        if (govJson != null) {
          governorate = GovernorateEntity(
            id: (govJson['id'] as num?)?.toInt() ?? 0,
            name: govJson['name']?.toString() ?? '',
            slug: govJson['slug']?.toString() ?? '',
          );
        }
        center = CenterEntity(
          id: (centerJson['id'] as num?)?.toInt() ?? 0,
          name: centerJson['name']?.toString() ?? '',
          slug: centerJson['slug']?.toString() ?? '',
          governorate: governorate,
        );
      }
      area = AreaEntity(
        id: (areaJson!['id'] as num?)?.toInt() ?? 0,
        name: areaJson!['name']?.toString() ?? '',
        slug: areaJson!['slug']?.toString() ?? '',
        center: center,
      );
    }

    return MerchantEntity(
      id: id,
      name: name,
      description: description,
      image: image,
      phone: phone,
      whatsapp: whatsapp,
      email: email,
      address: address,
      lat: lat,
      lng: lng,
      discount: discount,
      type: type,
      rating: rating,
      reviewCount: reviewCount,
      orderCount: orderCount,
      supportsInstallment: supportsInstallment,
      isWholesale: isWholesale,
      status: status,
      distance: distance,
      categoryId: categoryId,
      category: category,
      area: area,
      mapUrl: mapUrl,
      gallery: gallery,
    );
  }
}
