import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/end_points.dart';
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
import 'package:market/features/discount_card/presentation/pages/discount_card_screen.dart';
import 'package:market/features/discount_card/presentation/widgets/card_status_info_widget.dart';
import 'package:market/features/discount_card/presentation/widgets/discount_card_widget.dart';
import 'package:market/features/discount_card/presentation/widgets/no_card_state_widget.dart';
import 'package:market/features/discount_card/presentation/widgets/partner_discounts_section.dart';
import 'package:market/features/discount_card/presentation/widgets/qr_code_widget.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

class MockAuditRepo implements DiscountCardRepository {
  DiscountCardDataEntity? currentData;
  String? errorMessage;
  int getDiscountCardDataCallCount = 0;

  @override
  Future<Either<String, DiscountCardDataEntity>> getDiscountCardData() async {
    getDiscountCardDataCallCount++;
    if (errorMessage != null) {
      return Left(errorMessage!);
    }
    return Right(
      currentData ??
          const DiscountCardDataEntity(
            card: null,
            statistics: [],
            categories: [],
            benefits: [],
          ),
    );
  }

  @override
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  ) async => const Right(
    CardRequestResultEntity(status: true, message: 'تم استلام الطلب'),
  );

  @override
  Future<Either<String, UserCardEntity?>> getCardStatus() async =>
      Right(currentData?.card);

  @override
  Future<Either<String, UserCardEntity?>> getMembership() async =>
      Right(currentData?.card);

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

Widget buildAuditApp(MockAuditRepo repo) {
  final getUsecase = GetDiscountCardDataUseCase(repo);
  final reqUsecase = RequestCardUseCase(repo);
  final cubit = DiscountCardCubit(getUsecase, reqUsecase);

  return MaterialApp(
    home: BlocProvider<DiscountCardCubit>.value(
      value: cubit,
      child: const DiscountCardScreen(),
    ),
  );
}

void main() {
  late MockAuditRepo repo;

  setUp(() {
    repo = MockAuditRepo();
  });

  group('Discount Card State Machine Audit', () {
    testWidgets(
      'State 1: card == null renders NoCardStateWidget (Empty state)',
      (tester) async {
        repo.currentData = const DiscountCardDataEntity(
          card: null,
          statistics: [],
          categories: [],
          benefits: [],
        );

        await tester.pumpWidget(buildAuditApp(repo));
        await tester.pumpAndSettle();

        // State 1 assertions
        expect(find.byType(NoCardStateWidget), findsOneWidget);
        expect(find.text('ليس لديك كارت خصم حتى الآن'), findsOneWidget);
        expect(find.text('طلب كارت الخصم'), findsOneWidget);
        expect(find.byType(DiscountCardWidget), findsNothing);
        expect(find.byType(QrCodeWidget), findsNothing);
        expect(find.byType(CardStatusInfoWidget), findsNothing);
      },
    );

    testWidgets(
      'State 2: card != null && status == "active" renders DiscountCardWidget + QrCodeWidget with real card number',
      (tester) async {
        const activeCard = UserCardEntity(
          id: 12,
          userId: 14,
          cardNo: 'SG-2026-9479',
          type: 'annual',
          status: 'active',
          totalSavings: 150.0,
          activatedAt: '2026-08-14T16:06:46.000000Z',
          expiresAt: '2028-08-14T16:06:46.000000Z',
        );

        repo.currentData = const DiscountCardDataEntity(
          card: activeCard,
          statistics: [],
          categories: [],
          benefits: [],
        );

        await tester.pumpWidget(buildAuditApp(repo));
        await tester.pumpAndSettle();

        // State 2 assertions
        expect(find.byType(NoCardStateWidget), findsNothing);
        expect(find.byType(DiscountCardWidget), findsOneWidget);
        expect(find.text('SG-2026-9479'), findsOneWidget);
        expect(find.text('✓ مُفعل'), findsOneWidget);
        expect(find.text('اشتراك سنوي'), findsOneWidget);
        expect(find.byType(CardStatusInfoWidget), findsOneWidget);
        expect(find.textContaining('اشتراكك مفعل'), findsOneWidget);

        // QR Code removed per user request, PartnerDiscountsSection rendered
        expect(find.byType(QrCodeWidget), findsNothing);
        expect(find.byType(PartnerDiscountsSection), findsOneWidget);
      },
    );

    testWidgets(
      'State 3: card != null && status == "expired" renders Expired status & Renewal banner',
      (tester) async {
        const expiredCard = UserCardEntity(
          id: 12,
          userId: 14,
          cardNo: 'SG-2025-1111',
          type: 'monthly',
          status: 'expired',
          totalSavings: 50.0,
          activatedAt: '2025-01-01T00:00:00.000000Z',
          expiresAt: '2025-02-01T00:00:00.000000Z',
        );

        repo.currentData = const DiscountCardDataEntity(
          card: expiredCard,
          statistics: [],
          categories: [],
          benefits: [],
        );

        await tester.pumpWidget(buildAuditApp(repo));
        await tester.pumpAndSettle();

        // State 3 assertions
        expect(find.byType(NoCardStateWidget), findsNothing);
        expect(find.byType(DiscountCardWidget), findsOneWidget);
        expect(find.text('SG-2025-1111'), findsOneWidget);
        expect(find.text('منتهي الصلاحية'), findsOneWidget);
        expect(find.byType(CardStatusInfoWidget), findsOneWidget);
        expect(find.text('انتهت صلاحية الكارت'), findsOneWidget);
        expect(find.text('اشتراك سنوي — 12 شهر — 350 جنيه'), findsOneWidget);
      },
    );

    testWidgets(
      'State 4: card != null && unknown status (e.g. pending) does not crash and renders fallback status text',
      (tester) async {
        const unknownStatusCard = UserCardEntity(
          id: 18,
          userId: 25,
          cardNo: 'SG-2026-7777',
          type: 'annual',
          status: 'pending_verification',
          totalSavings: 0.0,
        );

        repo.currentData = const DiscountCardDataEntity(
          card: unknownStatusCard,
          statistics: [],
          categories: [],
          benefits: [],
        );

        await tester.pumpWidget(buildAuditApp(repo));
        await tester.pumpAndSettle();

        expect(find.byType(DiscountCardWidget), findsOneWidget);
        expect(find.text('pending_verification'), findsOneWidget);
        expect(unknownStatusCard.isActive, isFalse);
      },
    );

    testWidgets('Error state renders retry button and re-fetches on tap', (
      tester,
    ) async {
      repo.errorMessage = 'فشل في تحميل بيانات الكارت';

      await tester.pumpWidget(buildAuditApp(repo));
      await tester.pumpAndSettle();

      expect(find.text('فشل في تحميل بيانات الكارت'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);

      // Fix error and tap retry
      repo.errorMessage = null;
      repo.currentData = const DiscountCardDataEntity(
        card: null,
        statistics: [],
        categories: [],
        benefits: [],
      );

      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pumpAndSettle();

      expect(find.byType(NoCardStateWidget), findsOneWidget);
      expect(repo.getDiscountCardDataCallCount, 2);
    });

    test('Cubit isClosed safety: does not emit after close', () async {
      final getUsecase = GetDiscountCardDataUseCase(repo);
      final reqUsecase = RequestCardUseCase(repo);
      final cubit = DiscountCardCubit(getUsecase, reqUsecase);

      await cubit.close();

      // Calling loadDiscountCardData after close must not throw
      expect(() => cubit.loadDiscountCardData(), returnsNormally);
      expect(() => cubit.refresh(), returnsNormally);
    });

    test(
      'Zero-Trust Subscribe Isolation: Endpoint exists but no speculative payload is sent',
      () {
        expect(EndPoints.cardSubscribe, '/v1/card/subscribe');
      },
    );
  });
}
