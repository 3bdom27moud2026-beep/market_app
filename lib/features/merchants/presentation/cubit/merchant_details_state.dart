import 'package:equatable/equatable.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';
import 'package:market/features/merchants/domain/entities/merchant_product_entity.dart';

enum MerchantDetailsStatus { initial, loading, loaded, error }

class MerchantDetailsState extends Equatable {
  final MerchantDetailsStatus status;
  final MerchantEntity? merchant;
  final List<MerchantProductEntity> products;
  final String? errorMessage;

  const MerchantDetailsState({
    this.status = MerchantDetailsStatus.initial,
    this.merchant,
    this.products = const [],
    this.errorMessage,
  });

  MerchantDetailsState copyWith({
    MerchantDetailsStatus? status,
    MerchantEntity? merchant,
    List<MerchantProductEntity>? products,
    String? errorMessage,
  }) {
    return MerchantDetailsState(
      status: status ?? this.status,
      merchant: merchant ?? this.merchant,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, merchant, products, errorMessage];
}
