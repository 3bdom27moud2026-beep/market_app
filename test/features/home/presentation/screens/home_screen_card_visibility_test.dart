import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/domain/usecases/logout_usecase.dart';
import 'package:market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:market/features/cart/presentation/cubit/cart_state.dart';
import 'package:market/features/home/presentation/cubit/home_cubit.dart';
import 'package:market/features/home/presentation/cubit/home_state.dart';
import 'package:market/features/home/presentation/screens/home_screen.dart';
import 'package:market/features/home/presentation/widgets/shopguide_card.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/domain/repository/profile_repository.dart';
import 'package:market/features/profile/domain/usecases/get_profile_data.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_cubit.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_state.dart';

class MockCheckAuthUseCase extends Fake implements CheckAuthUseCase {
  bool isAuth = true;
  @override
  bool call() => isAuth;
}

class MockLogoutUseCase extends Fake implements LogoutUseCase {
  @override
  Future<Either<Failure, void>> call() async => const Right(null);
}

class MockProfileRepository extends Fake implements ProfileRepository {
  Either<String, ProfileDataEntity>? profileResult;

  @override
  Future<Either<String, ProfileDataEntity>> getProfileData() async {
    return profileResult ?? const Left('Not initialized');
  }
}

class FakeHomeCubit extends Cubit<HomeState> implements HomeCubit {
  FakeHomeCubit() : super(const HomeState(loadingStatus: LoadingStatus.loaded));

  @override
  Future<void> loadHome() async {}

  @override
  Future<void> refresh() async {}

  @override
  void changeBanner(int index) {}

  @override
  void changeNewestFilter(NewestFilter filter) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCartCubit extends Cubit<CartState> implements CartCubit {
  FakeCartCubit() : super(CartInitial());

  @override
  Future<void> loadCart() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeStartupPromotionCubit extends Cubit<StartupPromotionState>
    implements StartupPromotionCubit {
  FakeStartupPromotionCubit() : super(const StartupPromotionState());

  @override
  Future<void> loadPromotion() async {}

  @override
  void showPopup() {}

  @override
  void closePopup() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockCheckAuthUseCase mockCheckAuthUseCase;
  late MockProfileRepository mockProfileRepo;
  late ProfileCubit profileCubit;
  late FakeHomeCubit fakeHomeCubit;
  late FakeCartCubit fakeCartCubit;
  late FakeStartupPromotionCubit fakePromotionCubit;

  const tCard = UserCardEntity(
    id: 1,
    userId: 1,
    cardNo: '12345',
    type: 'annual',
    status: 'active',
    totalSavings: 50.0,
  );

  const tProfileWithCard = ProfileDataEntity(
    profile: ProfileEntity(
      id: 1,
      fullName: 'John Doe',
      email: 'john@example.com',
      card: tCard,
    ),
    statistics: StatisticsEntity(
      ordersCount: 1,
      favoritesCount: 1,
      subscriptionDaysRemaining: 10,
    ),
    savings: SavingsEntity(totalSavings: 50.0),
  );

  const tProfileWithoutCard = ProfileDataEntity(
    profile: ProfileEntity(
      id: 1,
      fullName: 'Jane Doe',
      email: 'jane@example.com',
      card: null,
    ),
    statistics: StatisticsEntity(
      ordersCount: 0,
      favoritesCount: 0,
      subscriptionDaysRemaining: 0,
    ),
    savings: SavingsEntity(totalSavings: 0.0),
  );

  setUp(() {
    mockCheckAuthUseCase = MockCheckAuthUseCase();
    if (CoreDI.sl.isRegistered<CheckAuthUseCase>()) {
      CoreDI.sl.unregister<CheckAuthUseCase>();
    }
    if (CoreDI.sl.isRegistered<LogoutUseCase>()) {
      CoreDI.sl.unregister<LogoutUseCase>();
    }

    CoreDI.sl.registerSingleton<CheckAuthUseCase>(mockCheckAuthUseCase);
    CoreDI.sl.registerSingleton<LogoutUseCase>(MockLogoutUseCase());

    mockProfileRepo = MockProfileRepository();
    final getProfileUseCase = GetProfileData(repository: mockProfileRepo);
    profileCubit = ProfileCubit(getProfileData: getProfileUseCase);

    fakeHomeCubit = FakeHomeCubit();
    fakeCartCubit = FakeCartCubit();
    fakePromotionCubit = FakeStartupPromotionCubit();
  });

  tearDown(() {
    profileCubit.close();
    fakeHomeCubit.close();
    fakeCartCubit.close();
    fakePromotionCubit.close();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<HomeCubit>.value(value: fakeHomeCubit),
          BlocProvider<CartCubit>.value(value: fakeCartCubit),
          BlocProvider<StartupPromotionCubit>.value(value: fakePromotionCubit),
        ],
        child: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen Discount Card Section Visibility Tests', () {
    testWidgets(
      'CASE A: profile with card (card != null) -> HIDES ShopGuideCard',
      (tester) async {
        mockProfileRepo.profileResult = const Right(tProfileWithCard);
        await profileCubit.loadProfile();

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ShopGuideCard), findsNothing);
      },
    );

    testWidgets(
      'CASE B: profile without card (card == null) -> SHOWS ShopGuideCard',
      (tester) async {
        mockProfileRepo.profileResult = const Right(tProfileWithoutCard);
        await profileCubit.loadProfile();

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ShopGuideCard), findsOneWidget);
      },
    );

    testWidgets(
      'CASE C: profile loading (initial/loading) -> HIDES ShopGuideCard to prevent flicker',
      (tester) async {
        // ProfileCubit starts in initial status with no profile data
        await tester.pumpWidget(buildTestableWidget());
        await tester.pump();

        expect(find.byType(ShopGuideCard), findsNothing);
      },
    );

    testWidgets(
      'CASE D: unauthenticated user (not logged in) -> SHOWS ShopGuideCard',
      (tester) async {
        mockCheckAuthUseCase.isAuth = false;
        await profileCubit.loadProfile();

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ShopGuideCard), findsOneWidget);
      },
    );

    testWidgets(
      'STEP 4: updating profile state from null to non-null card hides section dynamically',
      (tester) async {
        mockProfileRepo.profileResult = const Right(tProfileWithoutCard);
        await profileCubit.loadProfile();

        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ShopGuideCard), findsOneWidget);

        // Now user requests card, profile refreshes with card != null
        mockProfileRepo.profileResult = const Right(tProfileWithCard);
        await profileCubit.refresh();
        await tester.pumpAndSettle();

        expect(find.byType(ShopGuideCard), findsNothing);
      },
    );
  });
}
