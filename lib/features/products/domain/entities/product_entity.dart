import 'package:equatable/equatable.dart';
import 'specification_entity.dart';

/// Represents a product with full details.
class ProductEntity extends Equatable {
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
  final List<SpecificationEntity> specifications;

  /// The category_id from the product's merchant object.
  /// Used to filter products by category on the client side.
  final String merchantCategoryId;

  /// List of image thumbnails/URLs for gallery display.
  final List<String> images;

  /// Brand name (e.g. 'الشركة الهندسية', 'Nike').
  final String brand;

  /// Number of reviews.
  final int reviewCount;

  /// Remaining stock.
  final int stock;

  /// Whether this product is part of a flash sale.
  final bool isFlashSale;

  /// Whether the user is a member.
  final bool isMember;

  /// Price shown to user.
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

  bool get isPriceOnInspection => isService || price <= 0;

  /// Whether this product/merchant supports installments.
  final bool supportsInstallment;

  /// Installment partner name (e.g. 'مايلو').
  final String installmentPartner;

  /// Minimum monthly installment amount.
  final double? monthlyInstallment;

  const ProductEntity({
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

  ProductEntity copyWith({
    String? id,
    String? name,
    String? store,
    String? image,
    double? price,
    double? oldPrice,
    int? discount,
    double? rating,
    bool? isFavorite,
    String? description,
    List<SpecificationEntity>? specifications,
    String? merchantCategoryId,
    List<String>? images,
    String? brand,
    int? reviewCount,
    int? stock,
    bool? isFlashSale,
    bool? isMember,
    double? displayPrice,
    double? memberPrice,
    double? originalPrice,
    bool? hasDiscount,
    double? savingsAmount,
    bool? isService,
    bool? supportsInstallment,
    String? installmentPartner,
    double? monthlyInstallment,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      store: store ?? this.store,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      specifications: specifications ?? this.specifications,
      merchantCategoryId: merchantCategoryId ?? this.merchantCategoryId,
      images: images ?? this.images,
      brand: brand ?? this.brand,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      isFlashSale: isFlashSale ?? this.isFlashSale,
      isMember: isMember ?? this.isMember,
      displayPrice: displayPrice ?? this.displayPrice,
      memberPrice: memberPrice ?? this.memberPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      savingsAmount: savingsAmount ?? this.savingsAmount,
      isService: isService ?? this.isService,
      supportsInstallment: supportsInstallment ?? this.supportsInstallment,
      installmentPartner: installmentPartner ?? this.installmentPartner,
      monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
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
