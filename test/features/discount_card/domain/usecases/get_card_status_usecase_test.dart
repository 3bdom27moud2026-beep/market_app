import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/discount_card/domain/usecases/get_card_status_usecase.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';

class MockDiscountCardRepository implements DiscountCardRepository {
  Either<String, UserCardEntity?>? mockCardStatusResult;

  @override
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  ) async =>
      const Right(CardRequestResultEntity(status: true, message: 'طلب ناجح'));

  @override
  Future<Either<String, UserCardEntity?>> getCardStatus() async {
    return mockCardStatusResult!;
  }

  @override
  Future<Either<String, UserCardEntity?>> getMembership() async =>
      mockCardStatusResult!;

  @override
  Future<Either<String, DiscountCardDataEntity>> getDiscountCardData() async =>
      throw UnimplementedError();

  @override
  Future<Either<String, List<BenefitEntity>>> getBenefits() async =>
      const Right([]);

  @override
  Future<Either<String, List<DiscountCategoryEntity>>> getCategories() async =>
      const Right([]);

  @override
  Future<Either<String, List<MerchantEntity>>> getMerchants(
    String categoryId,
  ) async => const Right([]);

  @override
  Future<Either<String, List<StatisticsEntity>>> getStatistics() async =>
      const Right([]);

  @override
  Future<Either<String, bool>> cancelSubscription() async => const Right(true);
}

void main() {
  late MockDiscountCardRepository mockRepository;
  late GetCardStatusUseCase useCase;

  setUp(() {
    mockRepository = MockDiscountCardRepository();
    useCase = GetCardStatusUseCase(mockRepository);
  });

  test(
    'returns Right(UserCardEntity) when user has an active card on GET /v1/card/status',
    () async {
      const card = UserCardEntity(
        id: 12,
        userId: 14,
        cardNo: 'SG-2026-9479',
        type: 'annual',
        status: 'active',
        totalSavings: 0,
        activatedAt: '2026-08-14T16:06:46.000000Z',
        expiresAt: '2027-08-14T16:06:46.000000Z',
      );

      mockRepository.mockCardStatusResult = const Right(card);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Should succeed'), (userCard) {
        expect(userCard, isNotNull);
        expect(userCard!.cardNo, 'SG-2026-9479');
        expect(userCard.status, 'active');
        expect(userCard.isActive, isTrue);
      });
    },
  );

  test(
    'returns Right(null) when user has NO card on GET /v1/card/status',
    () async {
      mockRepository.mockCardStatusResult = const Right(null);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Should succeed'),
        (userCard) => expect(userCard, isNull),
      );
    },
  );

  test('returns Left(errorMessage) on API failure', () async {
    mockRepository.mockCardStatusResult = const Left('Server error 500');

    final result = await useCase();

    expect(result.isLeft(), isTrue);
    result.fold(
      (error) => expect(error, 'Server error 500'),
      (_) => fail('Should fail'),
    );
  });
}
