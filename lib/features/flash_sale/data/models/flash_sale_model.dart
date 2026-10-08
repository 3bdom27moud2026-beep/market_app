import 'package:equatable/equatable.dart';
import '../../../home/data/models/flash_sale_product_model.dart';
import '../../domain/entities/flash_sale_entity.dart';

/// Model for the flash sale API response.
class FlashSaleResponseModel extends Equatable {
  final CountdownModel countdown;
  final int total;
  final List<String> categories;
  final List<FlashSaleProductModel> products;
  final PaginationModel pagination;

  const FlashSaleResponseModel({
    required this.countdown,
    required this.total,
    required this.categories,
    required this.products,
    required this.pagination,
  });

  factory FlashSaleResponseModel.fromJson(Map<String, dynamic> json) {
    final countdownMap = json['countdown'] is Map<String, dynamic>
        ? json['countdown'] as Map<String, dynamic>
        : <String, dynamic>{};

    final paginationMap = json['pagination'] is Map<String, dynamic>
        ? json['pagination'] as Map<String, dynamic>
        : <String, dynamic>{};

    final List<dynamic>? rawProducts =
        (json['products'] as List<dynamic>?) ??
        (json['flash_sales'] as List<dynamic>?) ??
        (json['flash_sale'] as List<dynamic>?) ??
        (json['data'] is List<dynamic> ? json['data'] as List<dynamic> : null);

    return FlashSaleResponseModel(
      countdown: CountdownModel.fromJson(countdownMap),
      total: (json['total'] as num?)?.toInt() ?? (rawProducts?.length ?? 0),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      products:
          rawProducts
              ?.map(
                (e) =>
                    FlashSaleProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(paginationMap),
    );
  }

  FlashSaleEntity toEntity() {
    return FlashSaleEntity(
      countdown: countdown.toEntity(),
      total: total,
      categories: categories,
      products: products.map((e) => e.toEntity()).toList(),
      pagination: pagination.toEntity(),
    );
  }

  @override
  List<Object?> get props => [
    countdown,
    total,
    categories,
    products,
    pagination,
  ];
}

/// Countdown model.
class CountdownModel extends Equatable {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const CountdownModel({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  factory CountdownModel.fromJson(Map<String, dynamic> json) {
    return CountdownModel(
      days: (json['days'] as num?)?.toInt() ?? 0,
      hours: (json['hours'] as num?)?.toInt() ?? 0,
      minutes: (json['minutes'] as num?)?.toInt() ?? 0,
      seconds: (json['seconds'] as num?)?.toInt() ?? 0,
    );
  }

  CountdownEntity toEntity() {
    return CountdownEntity(
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }

  @override
  List<Object?> get props => [days, hours, minutes, seconds];
}

/// Pagination model.
class PaginationModel extends Equatable {
  final int page;
  final int lastPage;
  final bool hasMore;

  const PaginationModel({
    required this.page,
    required this.lastPage,
    required this.hasMore,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: (json['page'] as num?)?.toInt() ?? 1,
      lastPage:
          (json['last_page'] as num?)?.toInt() ??
          (json['lastPage'] as num?)?.toInt() ??
          1,
      hasMore: json['has_more'] as bool? ?? json['hasMore'] as bool? ?? false,
    );
  }

  PaginationEntity toEntity() {
    return PaginationEntity(page: page, lastPage: lastPage, hasMore: hasMore);
  }

  @override
  List<Object?> get props => [page, lastPage, hasMore];
}
