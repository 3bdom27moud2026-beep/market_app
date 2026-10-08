import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/discount_card/domain/usecases/request_card_usecase.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

class MockDiscountCardRepository implements DiscountCardRepository {
  Either<String, CardRequestResultEntity>? mockRequestCardResult;

  @override
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  ) async {
    return mockRequestCardResult!;
  }

  @override
  Future<Either<String, UserCardEntity?>> getCardStatus() async =>
      const Right(null);

  @override
  Future<Either<String, UserCardEntity?>> getMembership() async =>
      const Right(null);

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
  late RequestCardUseCase useCase;

  setUp(() {
    mockRepository = MockDiscountCardRepository();
    useCase = RequestCardUseCase(mockRepository);
  });

  const validRequest = CardRequestModel(
    deliveryAddress: 'المنصورة - شارع المشاية',
    phone: '01012345678',
    paymentMethod: 'cash',
  );

  test('successful card request returns Right(status: true)', () async {
    const successResult = CardRequestResultEntity(
      status: true,
      message: 'تم تقديم طلب الكارت بنجاح',
    );
    mockRepository.mockRequestCardResult = const Right(successResult);

    final result = await useCase(validRequest);

    expect(result.isRight(), isTrue);
    result.fold((_) => fail('Should succeed'), (res) {
      expect(res.status, isTrue);
      expect(res.message, 'تم تقديم طلب الكارت بنجاح');
      expect(res.card, isNull);
    });
  });

  test(
    'business rejection with status=false returns Right(status: false, message: ...)',
    () async {
      const rejectionResult = CardRequestResultEntity(
        status: false,
        message: 'لديك بالفعل كارت توفير ساري حتى 2028-08-14',
      );
      mockRepository.mockRequestCardResult = const Right(rejectionResult);

      final result = await useCase(validRequest);

      expect(result.isRight(), isTrue);
      result.fold((_) => fail('Should not be treated as transport failure'), (
        res,
      ) {
        expect(res.status, isFalse);
        expect(res.message, 'لديك بالفعل كارت توفير ساري حتى 2028-08-14');
      });
    },
  );

  test('rejection containing active card preserves the card entity', () async {
    const card = UserCardEntity(
      id: 12,
      userId: 14,
      cardNo: 'SG-2026-9479',
      type: 'annual',
      status: 'active',
      totalSavings: 0,
      activatedAt: '2026-08-14T16:06:46.000000Z',
      expiresAt: '2028-08-14T16:06:46.000000Z',
    );
    const rejectionWithCard = CardRequestResultEntity(
      status: false,
      message: 'لديك بالفعل كارت توفير ساري حتى 2028-08-14',
      card: card,
    );
    mockRepository.mockRequestCardResult = const Right(rejectionWithCard);

    final result = await useCase(validRequest);

    expect(result.isRight(), isTrue);
    result.fold((_) => fail('Should succeed'), (res) {
      expect(res.status, isFalse);
      expect(res.card, isNotNull);
      expect(res.card!.cardNo, 'SG-2026-9479');
      expect(res.card!.isActive, isTrue);
    });
  });

  test('transport / HTTP network error returns Left(errorMessage)', () async {
    mockRepository.mockRequestCardResult = const Left(
      'Network connection timeout',
    );

    final result = await useCase(validRequest);

    expect(result.isLeft(), isTrue);
    result.fold(
      (error) => expect(error, 'Network connection timeout'),
      (_) => fail('Should fail with transport error'),
    );
  });
}
