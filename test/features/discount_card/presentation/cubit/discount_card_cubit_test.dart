import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/data/models/discount_card_data_model.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/discount_card/domain/usecases/get_discount_card_data_usecase.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_state.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

import 'package:market/features/auth/domain/repository/auth_repository.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';
import 'package:market/features/discount_card/domain/usecases/request_card_usecase.dart';

class MockDiscountCardRepository implements DiscountCardRepository {
  Either<String, DiscountCardDataEntity>? mockResult;
  Either<String, CardRequestResultEntity>? mockRequestCardResult;

  @override
  Future<Either<String, DiscountCardDataEntity>> getDiscountCardData() async {
    return mockResult!;
  }

  @override
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  ) async {
    return mockRequestCardResult ??
        const Right(CardRequestResultEntity(status: true, message: 'طلب ناجح'));
  }

  @override
  Future<Either<String, UserCardEntity?>> getCardStatus() async =>
      const Right(null);

  @override
  Future<Either<String, UserCardEntity?>> getMembership() async =>
      const Right(null);

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
  group('DiscountCardDataModel JSON Parsing Verification', () {
    test(
      'Case A: No Card ("card": null) produces card == null and isSubscribed == false',
      () {
        final jsonInput = {
          "card": null,
          "statistics": [],
          "categories": [],
          "benefits": [],
        };

        final model = DiscountCardDataModel.fromJson(jsonInput);

        expect(model.card, isNull);
        expect(model.isSubscribed, isFalse);
      },
    );

    test(
      'Case B: Active Card produces card != null, cardNo matching, and isSubscribed == true',
      () {
        final jsonInput = {
          "card": {
            "id": 12,
            "user_id": 14,
            "card_no": "SG-2026-9479",
            "type": "annual",
            "status": "active",
            "total_savings": 0,
            "activated_at": "2026-08-14T16:06:46.000000Z",
            "expires_at": "2027-08-14T16:06:46.000000Z",
          },
          "statistics": [],
          "categories": [],
          "benefits": [],
        };

        final model = DiscountCardDataModel.fromJson(jsonInput);

        expect(model.card, isNotNull);
        expect(model.card!.cardNo, "SG-2026-9479");
        expect(model.card!.status, "active");
        expect(model.card!.isActive, isTrue);
        expect(model.isSubscribed, isTrue);
      },
    );

    test(
      'Case C: Expired Card produces card != null, cardNo matching, and isSubscribed == false',
      () {
        final jsonInput = {
          "card": {
            "id": 12,
            "user_id": 14,
            "card_no": "SG-2026-9479",
            "type": "annual",
            "status": "expired",
            "total_savings": 0,
            "activated_at": "2025-08-14T16:06:46.000000Z",
            "expires_at": "2026-08-14T16:06:46.000000Z",
          },
          "statistics": [],
          "categories": [],
          "benefits": [],
        };

        final model = DiscountCardDataModel.fromJson(jsonInput);

        expect(model.card, isNotNull);
        expect(model.card!.cardNo, "SG-2026-9479");
        expect(model.card!.status, "expired");
        expect(model.card!.isActive, isFalse);
        expect(model.isSubscribed, isFalse);
      },
    );
  });

  group('DiscountCardCubit State Management Verification', () {
    late MockDiscountCardRepository mockRepository;
    late GetDiscountCardDataUseCase useCase;
    late RequestCardUseCase requestCardUseCase;
    late DiscountCardCubit cubit;

    setUp(() {
      mockRepository = MockDiscountCardRepository();
      useCase = GetDiscountCardDataUseCase(mockRepository);
      requestCardUseCase = RequestCardUseCase(mockRepository);
      cubit = DiscountCardCubit(useCase, requestCardUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test(
      'Case A: Cubit emits [Loading, Loaded(No Card)] when card is null',
      () async {
        const data = DiscountCardDataEntity(
          card: null,
          statistics: [],
          categories: [],
          benefits: [],
        );
        mockRepository.mockResult = const Right(data);

        expectLater(
          cubit.stream,
          emitsInOrder([
            const DiscountCardLoading(),
            const DiscountCardLoaded(data: data),
          ]),
        );

        await cubit.loadDiscountCardData();
        expect(cubit.state, isA<DiscountCardLoaded>());
        final loaded = cubit.state as DiscountCardLoaded;
        expect(loaded.data.card, isNull);
        expect(loaded.data.isSubscribed, isFalse);
      },
    );

    test(
      'Case B: Cubit emits [Loading, Loaded(Has Card)] when card is active',
      () async {
        const card = UserCardEntity(
          id: 12,
          userId: 14,
          cardNo: 'SG-2026-9479',
          type: 'annual',
          status: 'active',
          totalSavings: 0,
        );
        const data = DiscountCardDataEntity(
          card: card,
          statistics: [],
          categories: [],
          benefits: [],
        );
        mockRepository.mockResult = const Right(data);

        expectLater(
          cubit.stream,
          emitsInOrder([
            const DiscountCardLoading(),
            const DiscountCardLoaded(data: data),
          ]),
        );

        await cubit.loadDiscountCardData();
        expect(cubit.state, isA<DiscountCardLoaded>());
        final loaded = cubit.state as DiscountCardLoaded;
        expect(loaded.data.card, isNotNull);
        expect(loaded.data.card!.cardNo, 'SG-2026-9479');
        expect(loaded.data.isSubscribed, isTrue);
      },
    );

    test(
      'Case C: Cubit emits [Loading, Loaded(Expired Card)] when card is expired',
      () async {
        const card = UserCardEntity(
          id: 12,
          userId: 14,
          cardNo: 'SG-2026-9479',
          type: 'annual',
          status: 'expired',
          totalSavings: 0,
        );
        const data = DiscountCardDataEntity(
          card: card,
          statistics: [],
          categories: [],
          benefits: [],
        );
        mockRepository.mockResult = const Right(data);

        expectLater(
          cubit.stream,
          emitsInOrder([
            const DiscountCardLoading(),
            const DiscountCardLoaded(data: data),
          ]),
        );

        await cubit.loadDiscountCardData();
        expect(cubit.state, isA<DiscountCardLoaded>());
        final loaded = cubit.state as DiscountCardLoaded;
        expect(loaded.data.card, isNotNull);
        expect(loaded.data.card!.status, 'expired');
        expect(loaded.data.isSubscribed, isFalse);
      },
    );

    test(
      'Case D: Cubit emits [Loading, Error] when API fails (never converts error to No Card)',
      () async {
        mockRepository.mockResult = const Left('Network connection timeout');

        expectLater(
          cubit.stream,
          emitsInOrder([
            const DiscountCardLoading(),
            const DiscountCardError(message: 'Network connection timeout'),
          ]),
        );

        await cubit.loadDiscountCardData();
        expect(cubit.state, isA<DiscountCardError>());
        final errorState = cubit.state as DiscountCardError;
        expect(errorState.message, 'Network connection timeout');
      },
    );

    test(
      'Case E: submitCardRequest returns Right on success and triggers reload',
      () async {
        const successResult = CardRequestResultEntity(
          status: true,
          message: 'تم استلام الطلب',
        );
        mockRepository.mockRequestCardResult = const Right(successResult);
        mockRepository.mockResult = const Right(
          DiscountCardDataEntity(
            card: null,
            statistics: [],
            categories: [],
            benefits: [],
          ),
        );

        final result = await cubit.submitCardRequest(
          deliveryAddress: 'المنصورة',
          phone: '01012345678',
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Should succeed'),
          (res) => expect(res.status, isTrue),
        );
      },
    );

    test(
      'Case F: submitCardRequest returns Right on business rejection',
      () async {
        const rejectionResult = CardRequestResultEntity(
          status: false,
          message: 'لديك بالفعل كارت ساري',
        );
        mockRepository.mockRequestCardResult = const Right(rejectionResult);

        final result = await cubit.submitCardRequest(
          deliveryAddress: 'المنصورة',
          phone: '01012345678',
        );

        expect(result.isRight(), isTrue);
        result.fold((_) => fail('Should succeed with business result'), (res) {
          expect(res.status, isFalse);
          expect(res.message, 'لديك بالفعل كارت ساري');
        });
      },
    );

    test(
      'Case G: Emits DiscountCardUnauthenticated when user is not logged in',
      () async {
        final fakeRepo = _FakeAuthRepo(loggedIn: false);
        final checkAuth = CheckAuthUseCase(fakeRepo);
        final unauthCubit = DiscountCardCubit(
          useCase,
          requestCardUseCase,
          checkAuth,
        );

        await unauthCubit.loadDiscountCardData();
        expect(unauthCubit.state, const DiscountCardUnauthenticated());
        await unauthCubit.close();
      },
    );
  });
}

class _FakeAuthRepo implements AuthRepository {
  final bool loggedIn;
  _FakeAuthRepo({required this.loggedIn});

  @override
  bool isLoggedIn() => loggedIn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
