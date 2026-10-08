import 'package:equatable/equatable.dart';
import 'package:market/core/utils/image_url_formatter.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/specification_entity.dart';
import 'specification_model.dart';

/// Model for product response from the API.
class ProductModel extends Equatable {
  final String id;
  final String name;
  final String store;
  final String image;
  final double price;
  final double oldPrice;
  final int discount;
  final double rating;
  final bool isFavorite;
  final String description;
  final List<SpecificationModel> specifications;

  /// The category_id from the product's merchant object (merchant.category_id).
  final String merchantCategoryId;

  /// List of images / thumbnails.
  final List<String> images;

  /// Brand name.
  final String brand;

  /// Number of reviews.
  final int reviewCount;

  /// Remaining stock.
  final int stock;

  /// Whether this product is part of a flash sale.
  final bool isFlashSale;

  /// Whether the user is a member.
  final bool isMember;

  /// Display price.
  final double displayPrice;

  /// Member price.
  final double memberPrice;

  /// Original price.
  final double originalPrice;

  /// Has discount flag.
  final bool hasDiscount;

  /// Amount saved.
  final double savingsAmount;

  /// Whether this is a technical service whose pricing depends on inspection.
  final bool isService;

  /// Whether this product/merchant supports installments.
  final bool supportsInstallment;

  /// Installment partner name (e.g. 'مايلو').
  final String installmentPartner;

  /// Minimum monthly installment amount.
  final double? monthlyInstallment;

  const ProductModel({
    required this.id,
    required this.name,
    required this.store,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    this.isFavorite = false,
    this.description = '',
    this.specifications = const [],
    this.merchantCategoryId = '',
    this.images = const [],
    this.brand = '',
    this.reviewCount = 0,
    this.stock = 0,
    this.isFlashSale = false,
    this.isMember = false,
    this.displayPrice = 0,
    this.memberPrice = 0,
    this.originalPrice = 0,
    this.hasDiscount = false,
    this.savingsAmount = 0,
    this.isService = false,
    this.supportsInstallment = false,
    this.installmentPartner = 'مايلو',
    this.monthlyInstallment,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final double displayPriceVal =
        (json['display_price'] as num?)?.toDouble() ?? 0.0;
    final double memberPriceVal =
        (json['member_price'] as num?)?.toDouble() ?? 0.0;
    final double rawPriceVal = (json['price'] as num?)?.toDouble() ?? 0.0;

    final double priceVal = rawPriceVal > 0
        ? rawPriceVal
        : (displayPriceVal > 0 ? displayPriceVal : memberPriceVal);

    final double originalPriceVal =
        (json['original_price'] as num?)?.toDouble() ??
        (json['old_price'] as num?)?.toDouble() ??
        (json['oldPrice'] as num?)?.toDouble() ??
        (json['before_discount'] as num?)?.toDouble() ??
        (json['price_before'] as num?)?.toDouble() ??
        (json['regular_price'] as num?)?.toDouble() ??
        0.0;

    final int rawDiscount =
        (json['discount'] as num?)?.toInt() ??
        (json['discount_percentage'] as num?)?.toInt() ??
        (json['discount_percent'] as num?)?.toInt() ??
        (json['discount_rate'] as num?)?.toInt() ??
        0;

    double oldPriceVal = originalPriceVal > 0
        ? originalPriceVal
        : (displayPriceVal > priceVal ? displayPriceVal : priceVal);

    int calcDiscount = (oldPriceVal > priceVal && oldPriceVal > 0)
        ? (((oldPriceVal - priceVal) / oldPriceVal) * 100).round()
        : rawDiscount;

    if (oldPriceVal <= priceVal && calcDiscount > 0 && priceVal > 0) {
      oldPriceVal = (priceVal / (1 - (calcDiscount / 100))).roundToDouble();
    }

    // Parse merchant object for store name and category_id
    final merchant = json['merchant'] is Map<String, dynamic>
        ? json['merchant'] as Map<String, dynamic>
        : null;

    final String merchantName = merchant?['name']?.toString() ?? '';
    final String brandName = json['brand']?.toString() ?? '';
    final String storeName = merchantName.isNotEmpty
        ? merchantName
        : (brandName.isNotEmpty
              ? brandName
              : (json['store']?.toString() ?? ''));

    // Extract category_id from the merchant object
    final String merchantCategoryId =
        merchant?['category_id']?.toString() ?? '';

    final List<SpecificationModel> specsList = [];

    void addSpecIfAbsent(String title, dynamic val) {
      if (val == null) return;
      final str = val.toString().trim();
      if (str.isEmpty || str == 'null') return;
      if (!specsList.any((s) => s.title == title)) {
        specsList.add(SpecificationModel(title: title, value: str));
      }
    }

    if (json['specs'] is Map<String, dynamic>) {
      final specsMap = json['specs'] as Map<String, dynamic>;
      specsMap.forEach((key, value) => addSpecIfAbsent(key, value));
    } else if (json['specs'] is List<dynamic>) {
      for (final item in json['specs'] as List<dynamic>) {
        if (item is Map<String, dynamic>) {
          specsList.add(SpecificationModel.fromJson(item));
        }
      }
    }

    if (json['specifications'] is Map<String, dynamic>) {
      final specsMap = json['specifications'] as Map<String, dynamic>;
      specsMap.forEach((key, value) => addSpecIfAbsent(key, value));
    } else if (json['specifications'] is List<dynamic>) {
      for (final item in json['specifications'] as List<dynamic>) {
        if (item is Map<String, dynamic>) {
          specsList.add(SpecificationModel.fromJson(item));
        }
      }
    }

    if (json['attributes'] is Map<String, dynamic>) {
      final map = json['attributes'] as Map<String, dynamic>;
      map.forEach((key, value) => addSpecIfAbsent(key, value));
    } else if (json['attributes'] is List<dynamic>) {
      for (final item in json['attributes'] as List<dynamic>) {
        if (item is Map<String, dynamic>) {
          specsList.add(SpecificationModel.fromJson(item));
        }
      }
    }

    if (json['type'] != null && json['type'] != 'service') {
      addSpecIfAbsent('النوع', json['type']);
    }
    if (json['warranty'] != null) {
      addSpecIfAbsent('الضمان', json['warranty']);
    } else if (json['guarantee'] != null) {
      addSpecIfAbsent('الضمان', json['guarantee']);
    }
    if (json['expected_time'] != null) {
      addSpecIfAbsent('الوقت المتوقع', json['expected_time']);
    } else if (json['delivery_time'] != null) {
      addSpecIfAbsent('الوقت المتوقع', json['delivery_time']);
    }

    final String rawImg =
        json['image']?.toString() ??
        json['image_url']?.toString() ??
        json['photo']?.toString() ??
        json['avatar']?.toString() ??
        '';
    String imgUrl = ImageUrlFormatter.format(rawImg) ?? rawImg;

    final List<String> imagesList = [];
    if (json['gallery'] is List && (json['gallery'] as List).isNotEmpty) {
      imagesList.addAll(
        (json['gallery'] as List).map(
          (e) => ImageUrlFormatter.format(e?.toString()) ?? e.toString(),
        ),
      );
    } else if (json['thumbnails'] is List &&
        (json['thumbnails'] as List).isNotEmpty) {
      imagesList.addAll(
        (json['thumbnails'] as List).map(
          (e) => ImageUrlFormatter.format(e?.toString()) ?? e.toString(),
        ),
      );
    } else if (json['images'] is List && (json['images'] as List).isNotEmpty) {
      imagesList.addAll(
        (json['images'] as List).map(
          (e) => ImageUrlFormatter.format(e?.toString()) ?? e.toString(),
        ),
      );
    }

    if (imgUrl.isEmpty && imagesList.isNotEmpty) {
      imgUrl = imagesList.first;
    }
    if (imgUrl.isNotEmpty && !imagesList.contains(imgUrl)) {
      imagesList.insert(0, imgUrl);
    }

    final double savingsAmount =
        (json['savings_amount'] as num?)?.toDouble() ??
        (oldPriceVal > priceVal ? (oldPriceVal - priceVal) : 0.0);

    return ProductModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['title']?.toString() ?? '',
      store: storeName,
      image: imgUrl,
      price: priceVal,
      oldPrice: oldPriceVal,
      discount: calcDiscount,
      rating:
          (json['rating'] as num?)?.toDouble() ??
          (json['rate'] as num?)?.toDouble() ??
          0.0,
      isFavorite:
          json['is_favorited'] as bool? ??
          json['is_favorite'] as bool? ??
          json['isFavorite'] as bool? ??
          false,
      description: json['description']?.toString() ?? '',
      specifications: specsList,
      merchantCategoryId: merchantCategoryId,
      images: imagesList,
      brand: brandName,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isFlashSale: json['is_flash_sale'] == true,
      isMember: json['is_member'] == true,
      displayPrice: displayPriceVal,
      memberPrice: memberPriceVal,
      originalPrice: originalPriceVal,
      hasDiscount: json['has_discount'] == true || oldPriceVal > priceVal,
      savingsAmount: savingsAmount,
      isService:
          json['is_service'] == true ||
          json['price_type']?.toString().toLowerCase() == 'on_inspection' ||
          json['price_on_inspection'] == true ||
          json['type']?.toString().toLowerCase() == 'service' ||
          priceVal <= 0,
      supportsInstallment:
          json['supports_installment'] == true ||
          json['has_installment'] == true ||
          (merchant != null && merchant['supports_installment'] == true),
      installmentPartner:
          json['installment_partner']?.toString() ??
          json['partner']?.toString() ??
          'مايلو',
      monthlyInstallment:
          (json['monthly_installment'] as num?)?.toDouble() ??
          (json['installment_amount'] as num?)?.toDouble() ??
          (json['min_installment'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'store': store,
      'image': image,
      'price': price,
      'old_price': oldPrice,
      'discount': discount,
      'rating': rating,
      'is_favorite': isFavorite,
      'description': description,
      'specifications': specifications.map((e) => e.toJson()).toList(),
      'merchant_category_id': merchantCategoryId,
      'images': images,
      'brand': brand,
      'review_count': reviewCount,
      'stock': stock,
      'is_flash_sale': isFlashSale,
      'is_member': isMember,
      'display_price': displayPrice,
      'member_price': memberPrice,
      'original_price': originalPrice,
      'has_discount': hasDiscount,
      'savings_amount': savingsAmount,
      'is_service': isService,
      'supports_installment': supportsInstallment,
      'installment_partner': installmentPartner,
      'monthly_installment': monthlyInstallment,
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      store: store,
      image: image,
      price: price,
      oldPrice: oldPrice,
      discount: discount,
      rating: rating,
      isFavorite: isFavorite,
      description: description,
      specifications: specifications
          .map((e) => SpecificationEntity(title: e.title, value: e.value))
          .toList(),
      merchantCategoryId: merchantCategoryId,
      images: images,
      brand: brand,
      reviewCount: reviewCount,
      stock: stock,
      isFlashSale: isFlashSale,
      isMember: isMember,
      displayPrice: displayPrice,
      memberPrice: memberPrice,
      originalPrice: originalPrice,
      hasDiscount: hasDiscount,
      savingsAmount: savingsAmount,
      isService: isService,
      supportsInstallment: supportsInstallment,
      installmentPartner: installmentPartner,
      monthlyInstallment: monthlyInstallment,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    store,
    image,
    price,
    oldPrice,
    discount,
    rating,
    isFavorite,
    description,
    specifications,
    merchantCategoryId,
    images,
    brand,
    reviewCount,
    stock,
    isFlashSale,
    isMember,
    displayPrice,
    memberPrice,
    originalPrice,
    hasDiscount,
    savingsAmount,
    isService,
    supportsInstallment,
    installmentPartner,
    monthlyInstallment,
  ];
}
