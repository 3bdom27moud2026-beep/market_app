import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/discount_card/domain/entities/benefit_entity.dart';
import 'package:market/features/discount_card/domain/entities/category_entity.dart';
import 'package:market/features/discount_card/domain/entities/merchant_entity.dart';
import 'package:market/features/discount_card/domain/entities/statistics_entity.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/discount_card/domain/usecases/get_discount_card_data_usecase.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_state.dart';
import 'package:market/features/discount_card/presentation/pages/discount_card_screen.dart';
import 'package:market/features/discount_card/presentation/widgets/discount_card_widget.dart';
import 'package:market/features/discount_card/presentation/widgets/no_card_state_widget.dart';
import 'package:market/features/discount_card/presentation/widgets/partner_discounts_section.dart';
import 'package:market/features/discount_card/presentation/widgets/qr_code_widget.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';
import 'package:market/features/discount_card/domain/usecases/request_card_usecase.dart';

class MockDiscountCardRepo implements DiscountCardRepository {
  final DiscountCardDataEntity data;
  MockDiscountCardRepo(this.data);

  @override
  Future<Either<String, DiscountCardDataEntity>> getDiscountCardData() async =>
      Right(data);

  @override
  Future<Either<String, CardRequestResultEntity>> requestCard(
    CardRequestModel request,
  ) async =>
      const Right(CardRequestResultEntity(status: true, message: 'طلب ناجح'));

  @override
  Future<Either<String, UserCardEntity?>> getCardStatus() async =>
      Right(data.card);

  @override
  Future<Either<String, UserCardEntity?>> getMembership() async =>
      Right(data.card);

  @override
  Future<Either<String, List<BenefitEntity>>> getBenefits() async =>
      Right(data.benefits);

  @override
  Future<Either<String, List<DiscountCategoryEntity>>> getCategories() async =>
      Right(data.categories);

  @override
  Future<Either<String, List<MerchantEntity>>> getMerchants(
    String categoryId,
  ) async => const Right([]);

  @override
  Future<Either<String, List<StatisticsEntity>>> getStatistics() async =>
      Right(data.statistics);

  @override
  Future<Either<String, bool>> cancelSubscription() async => const Right(true);
}

Widget buildTestableWidget({required DiscountCardDataEntity data}) {
  final repo = MockDiscountCardRepo(data);
  final usecase = GetDiscountCardDataUseCase(repo);
  final requestUseCase = RequestCardUseCase(repo);
  final cubit = DiscountCardCubit(usecase, requestUseCase);

  return MaterialApp(
    home: BlocProvider<DiscountCardCubit>.value(
      value: cubit,
      child: const DiscountCardScreen(),
    ),
  );
}

void main() {
  group('DiscountCardScreen UI Verification', () {
    testWidgets('Renders NoCardStateWidget when card is null (State B)', (
      tester,
    ) async {
      const data = DiscountCardDataEntity(
        card: null,
        statistics: [],
        categories: [],
        benefits: [],
      );

      await tester.pumpWidget(buildTestableWidget(data: data));
      await tester.pumpAndSettle();

      // Verify empty state is displayed
      expect(find.byType(NoCardStateWidget), findsOneWidget);
      expect(find.text('ليس لديك كارت خصم حتى الآن'), findsOneWidget);
      expect(find.text('طلب كارت الخصم'), findsOneWidget);

      // Verify Card and QR are NOT displayed
      expect(find.byType(DiscountCardWidget), findsNothing);
      expect(find.byType(QrCodeWidget), findsNothing);
    });

    testWidgets(
      'Renders DiscountCardWidget and QrCodeWidget when card is active (State A)',
      (tester) async {
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

        await tester.pumpWidget(buildTestableWidget(data: data));
        await tester.pumpAndSettle();

        // Verify Card is displayed, QR is removed, and PartnerDiscountsSection is displayed
        expect(find.byType(DiscountCardWidget), findsOneWidget);
        expect(find.text('SG-2026-9479'), findsOneWidget);
        expect(find.text('✓ مُفعل'), findsOneWidget);
        expect(find.byType(QrCodeWidget), findsNothing);
        expect(find.byType(PartnerDiscountsSection), findsOneWidget);

        // Verify NoCardStateWidget is NOT displayed
        expect(find.byType(NoCardStateWidget), findsNothing);
      },
    );

    testWidgets('Renders expired status when card is expired', (tester) async {
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

      await tester.pumpWidget(buildTestableWidget(data: data));
      await tester.pumpAndSettle();

      // Verify Expired Card is visible and shows expired indicators
      expect(find.byType(DiscountCardWidget), findsOneWidget);
      expect(find.text('SG-2026-9479'), findsOneWidget);
      expect(find.text('منتهي الصلاحية'), findsOneWidget);
      expect(find.text('انتهت صلاحية الكارت'), findsOneWidget);
    });

    testWidgets(
      'Renders statistics dynamically without overflow when count > 3',
      (tester) async {
        const stats = [
          StatisticsEntity(
            id: '1',
            title: 'أعلى خصم',
            value: '50%',
            icon: '🔥',
          ),
          StatisticsEntity(
            id: '2',
            title: 'شركاء النجاح',
            value: '150+',
            icon: '🏬',
          ),
          StatisticsEntity(
            id: '3',
            title: 'متوسط الخصم',
            value: '25%',
            icon: '🏷️',
          ),
          StatisticsEntity(
            id: '4',
            title: 'توفير تراكمي',
            value: '500+',
            icon: '💰',
          ),
        ];
        const data = DiscountCardDataEntity(
          card: null,
          statistics: stats,
          categories: [],
          benefits: [],
        );

        await tester.pumpWidget(buildTestableWidget(data: data));
        await tester.pumpAndSettle();

        expect(find.byType(PartnerDiscountsSection), findsOneWidget);
        expect(find.text('خصومات التجار الشركاء'), findsOneWidget);
      },
    );

    testWidgets('Renders error view and retry button when state is error', (
      tester,
    ) async {
      final repo = MockDiscountCardRepo(
        const DiscountCardDataEntity(
          card: null,
          statistics: [],
          categories: [],
          benefits: [],
        ),
      );
      final usecase = GetDiscountCardDataUseCase(repo);
      final reqUsecase = RequestCardUseCase(repo);
      final cubit = DiscountCardCubit(usecase, reqUsecase);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DiscountCardCubit>.value(
            value: cubit,
            child: const DiscountCardScreen(),
          ),
        ),
      );

      // Emit error
      cubit.emit(const DiscountCardError(message: 'خطأ في الاتصال'));
      await tester.pumpAndSettle();

      expect(find.text('خطأ في الاتصال'), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    testWidgets(
      'Renders Unauthenticated view when state is DiscountCardUnauthenticated',
      (tester) async {
        final repo = MockDiscountCardRepo(
          const DiscountCardDataEntity(
            card: null,
            statistics: [],
            categories: [],
            benefits: [],
          ),
        );
        final usecase = GetDiscountCardDataUseCase(repo);
        final reqUsecase = RequestCardUseCase(repo);
        final cubit = DiscountCardCubit(usecase, reqUsecase);

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider<DiscountCardCubit>.value(
              value: cubit,
              child: const DiscountCardScreen(),
            ),
          ),
        );

        // Emit unauthenticated
        cubit.emit(const DiscountCardUnauthenticated());
        await tester.pumpAndSettle();

        expect(find.text('سجّل دخولك أولاً'), findsOneWidget);
        expect(find.text('تسجيل الدخول للحصول على الكارت'), findsOneWidget);
        expect(find.text('اضغط هنا للتسجيل'), findsOneWidget);
      },
    );
  });
}
