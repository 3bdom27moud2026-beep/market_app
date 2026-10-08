import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/domain/usecases/logout_usecase.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';
import 'package:market/features/profile/domain/repository/profile_repository.dart';
import 'package:market/features/profile/domain/usecases/get_profile_data.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:market/features/profile/presentation/cubit/profile_state.dart';

class MockCheckAuthUseCase extends Fake implements CheckAuthUseCase {
  bool isAuth = true;
  @override
  bool call() => isAuth;
}

class MockLogoutUseCase extends Fake implements LogoutUseCase {
  @override
  Future<Either<Failure, void>> call() async => const Right(null);
}

class MockProfileRepository implements ProfileRepository {
  Either<String, ProfileDataEntity>? getProfileResult;

  @override
  Future<Either<String, ProfileDataEntity>> getProfileData() async {
    return getProfileResult!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProfileCubit cubit;
  late MockProfileRepository mockRepo;
  late MockCheckAuthUseCase mockCheckAuth;
  late MockLogoutUseCase mockLogout;

  const newAvatarUrl =
      'https://shopguide.medguide.software/storage/avatars/5I93izgGORN5k4EoPBb4megenQPEgPJQH2ee4Zna.jpg';

  const tNewProfile = ProfileDataEntity(
    profile: ProfileEntity(
      id: 1,
      fullName: 'John Doe',
      email: 'john@example.com',
      avatarUrl: newAvatarUrl,
    ),
    statistics: StatisticsEntity(
      ordersCount: 1,
      favoritesCount: 1,
      subscriptionDaysRemaining: 10,
    ),
    savings: SavingsEntity(totalSavings: 100.0),
  );

  setUp(() {
    mockRepo = MockProfileRepository();
    mockCheckAuth = MockCheckAuthUseCase();
    mockLogout = MockLogoutUseCase();

    CoreDI.sl.reset();
    CoreDI.sl.registerLazySingleton<CheckAuthUseCase>(() => mockCheckAuth);
    CoreDI.sl.registerLazySingleton<LogoutUseCase>(() => mockLogout);

    final useCase = GetProfileData(repository: mockRepo);
    cubit = ProfileCubit(getProfileData: useCase);
  });

  tearDown(() {
    cubit.close();
    CoreDI.sl.reset();
  });

  group('ProfileCubit Stale State Prevention Tests', () {
    test(
      'loadProfile updates profile state with new avatar URL upon success',
      () async {
        mockRepo.getProfileResult = const Right(tNewProfile);

        expectLater(
          cubit.stream,
          emitsInOrder([
            const ProfileState(loadingStatus: LoadingStatus.loading),
            const ProfileState(
              loadingStatus: LoadingStatus.loaded,
              profileData: tNewProfile,
            ),
          ]),
        );

        await cubit.loadProfile();
        expect(cubit.state.profileData?.profile.avatarUrl, newAvatarUrl);
      },
    );

    test(
      'refresh replaces old profile state with new avatar URL immediately',
      () async {
        mockRepo.getProfileResult = const Right(tNewProfile);

        expectLater(
          cubit.stream,
          emitsInOrder([
            const ProfileState(loadingStatus: LoadingStatus.refreshing),
            const ProfileState(
              loadingStatus: LoadingStatus.loaded,
              profileData: tNewProfile,
            ),
          ]),
        );

        await cubit.refresh();
        expect(cubit.state.profileData?.profile.avatarUrl, newAvatarUrl);
      },
    );
  });
}
