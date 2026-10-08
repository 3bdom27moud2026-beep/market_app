import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/flash_sale_product_entity.dart';

/// Represents the complete flash sale response from the API.
class FlashSaleEntity extends Equatable {
  final CountdownEntity countdown;
  final int total;
  final List<String> categories;
  final List<FlashSaleProductEntity> products;
  final PaginationEntity pagination;

  const FlashSaleEntity({
    required this.countdown,
    required this.total,
    required this.categories,
    required this.products,
    required this.pagination,
  });

  @override
  List<Object?> get props => [
    countdown,
    total,
    categories,
    products,
    pagination,
  ];
}

/// Countdown time entity.
class CountdownEntity extends Equatable {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const CountdownEntity({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  Duration get duration =>
      Duration(days: days, hours: hours, minutes: minutes, seconds: seconds);

  @override
  List<Object?> get props => [days, hours, minutes, seconds];
}

/// Pagination entity.
class PaginationEntity extends Equatable {
  final int page;
  final int lastPage;
  final bool hasMore;

  const PaginationEntity({
    required this.page,
    required this.lastPage,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [page, lastPage, hasMore];
}
