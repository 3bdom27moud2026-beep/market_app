import 'package:dartz/dartz.dart';
import '../entities/coupon_entity.dart';
import '../repository/cart_repository.dart';

class ApplyCouponUseCase {
  final CartRepository _repository;

  const ApplyCouponUseCase(this._repository);

  Future<Either<String, CouponEntity>> call(String code) {
    return _repository.applyCoupon(code);
  }
}
