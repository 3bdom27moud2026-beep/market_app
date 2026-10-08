import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/discount_card/domain/usecases/get_discount_card_data_usecase.dart';
import 'package:market/features/discount_card/domain/usecases/request_card_usecase.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';
import 'package:market/features/discount_card/presentation/widgets/request_card_bottom_sheet.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

class MockDiscountCardRepoForSheet implements DiscountCardRepository {
  int requestCallCount = 0;
  int getDiscountCardDataCallCount = 0;
  Completer<Either<String, CardRequestResultEntity>>? completer;
  Either<String, CardRequestResultEntity>? immediateResult;

  @override
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  ) async {
    requestCallCount++;
    if (completer != null) {
      return completer!.future;
    }
    return immediateResult ??
        const Right(
          CardRequestResultEntity(
            status: true,
            message: 'تم استلام طلب الكارت بنجاح',
          ),
        );
  }

  @override
  Future<Either<String, DiscountCardDataEntity>> getDiscountCardData() async {
    getDiscountCardDataCallCount++;
    return const Right(
      DiscountCardDataEntity(
        card: null,
        statistics: [],
        categories: [],
        benefits: [],
      ),
    );
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
  late MockDiscountCardRepoForSheet mockRepo;
  late DiscountCardCubit cubit;

  setUp(() {
    mockRepo = MockDiscountCardRepoForSheet();
    final getUsecase = GetDiscountCardDataUseCase(mockRepo);
    final reqUsecase = RequestCardUseCase(mockRepo);
    cubit = DiscountCardCubit(getUsecase, reqUsecase);
  });

  tearDown(() {
    cubit.close();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<DiscountCardCubit>.value(
        value: cubit,
        child: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => showRequestCardBottomSheet(context),
                child: const Text('Open Sheet'),
              );
            },
          ),
        ),
      ),
    );
  }

  testWidgets(
    'Validation failure: Submitting empty form shows validation errors and prevents API call',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Open bottom sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('طلب كارت الخصومات'), findsOneWidget);
      final submitFinder = find.byKey(const Key('card_request_submit_button'));
      await tester.ensureVisible(submitFinder);
      await tester.pumpAndSettle();

      // Tap confirm with empty fields
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      // Validation errors must appear
      expect(find.text('يرجى إدخال عنوان التوصيل'), findsOneWidget);
      expect(find.text('يرجى إدخال رقم الهاتف'), findsOneWidget);
      expect(mockRepo.requestCallCount, 0);
    },
  );

  testWidgets(
    'Validation failure: Submitting short phone shows invalid phone error',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final addressFinder = find.descendant(
        of: find.byKey(const Key('card_request_address_field')),
        matching: find.byType(EditableText),
      );
      final phoneFinder = find.descendant(
        of: find.byKey(const Key('card_request_phone_field')),
        matching: find.byType(EditableText),
      );
      final submitFinder = find.byKey(const Key('card_request_submit_button'));

      await tester.ensureVisible(addressFinder);
      await tester.enterText(addressFinder, 'المنصورة');
      await tester.ensureVisible(phoneFinder);
      await tester.enterText(phoneFinder, '010');

      await tester.ensureVisible(submitFinder);
      await tester.pumpAndSettle();
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(find.text('يرجى إدخال رقم هاتف صالح'), findsOneWidget);
      expect(mockRepo.requestCallCount, 0);
    },
  );

  testWidgets(
    'Duplicate submit protection: Disables button and prevents double API calls while in-flight',
    (tester) async {
      mockRepo.completer = Completer();

      await tester.pumpWidget(buildTestWidget());

      // Open bottom sheet
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final addressFinder = find.descendant(
        of: find.byKey(const Key('card_request_address_field')),
        matching: find.byType(EditableText),
      );
      final phoneFinder = find.descendant(
        of: find.byKey(const Key('card_request_phone_field')),
        matching: find.byType(EditableText),
      );
      final submitFinder = find.byKey(const Key('card_request_submit_button'));

      await tester.ensureVisible(addressFinder);
      await tester.enterText(addressFinder, 'المنصورة - المشاية');
      await tester.ensureVisible(phoneFinder);
      await tester.enterText(phoneFinder, '01012345678');

      // Tap submit first time
      await tester.ensureVisible(submitFinder);
      await tester.pumpAndSettle();
      await tester.tap(submitFinder);
      await tester.pump(); // Start async work, loading spinner appears

      expect(mockRepo.requestCallCount, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Tap again while in flight
      await tester.tap(find.byType(CircularProgressIndicator));
      await tester.pump();

      // Should still be exactly 1 call
      expect(mockRepo.requestCallCount, 1);

      // Complete async response
      mockRepo.completer!.complete(
        const Right(
          CardRequestResultEntity(
            status: true,
            message: 'تم استلام طلب الكارت بنجاح',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // SnackBar shown and sheet closed
      expect(find.text('تم استلام طلب الكارت بنجاح'), findsOneWidget);
    },
  );

  testWidgets(
    'Business Rejection: Shows exact backend message with warning styling and does NOT pretend success',
    (tester) async {
      mockRepo.immediateResult = const Right(
        CardRequestResultEntity(
          status: false,
          message: 'لديك بالفعل كارت توفير ساري حتى 2028-08-14',
        ),
      );

      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      final addressFinder = find.descendant(
        of: find.byKey(const Key('card_request_address_field')),
        matching: find.byType(EditableText),
      );
      final phoneFinder = find.descendant(
        of: find.byKey(const Key('card_request_phone_field')),
        matching: find.byType(EditableText),
      );
      final submitFinder = find.byKey(const Key('card_request_submit_button'));

      await tester.ensureVisible(addressFinder);
      await tester.enterText(addressFinder, 'المنصورة');
      await tester.ensureVisible(phoneFinder);
      await tester.enterText(phoneFinder, '01012345678');

      await tester.ensureVisible(submitFinder);
      await tester.pumpAndSettle();
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(
        find.text('لديك بالفعل كارت توفير ساري حتى 2028-08-14'),
        findsOneWidget,
      );
      expect(find.text('تم استلام طلب الكارت بنجاح'), findsNothing);
    },
  );

  testWidgets('Transport Error: Shows error message in red SnackBar', (
    tester,
  ) async {
    mockRepo.immediateResult = const Left('فشل الاتصال بالخادم');

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    final addressFinder = find.descendant(
      of: find.byKey(const Key('card_request_address_field')),
      matching: find.byType(EditableText),
    );
    final phoneFinder = find.descendant(
      of: find.byKey(const Key('card_request_phone_field')),
      matching: find.byType(EditableText),
    );
    final submitFinder = find.byKey(const Key('card_request_submit_button'));

    await tester.ensureVisible(addressFinder);
    await tester.enterText(addressFinder, 'المنصورة');
    await tester.ensureVisible(phoneFinder);
    await tester.enterText(phoneFinder, '01012345678');

    await tester.ensureVisible(submitFinder);
    await tester.pumpAndSettle();
    await tester.tap(submitFinder);
    await tester.pumpAndSettle();

    expect(find.text('فشل الاتصال بالخادم'), findsOneWidget);
  });
}
