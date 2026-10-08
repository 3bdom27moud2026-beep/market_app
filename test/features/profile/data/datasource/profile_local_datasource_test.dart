import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/profile/data/datasource/local/profile_local_datasource.dart';
import 'package:market/features/profile/data/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProfileLocalDataSourceImpl localDataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
    localDataSource = ProfileLocalDataSourceImpl();
  });

  group('ProfileLocalDataSourceImpl Caching Verification', () {
    test('returns null when no cached profile data exists', () {
      final cached = localDataSource.getCachedProfileData();
      expect(cached, isNull);
    });

    test(
      'caches profile data with new avatar URL and retrieves it accurately',
      () async {
        const sampleModel = ProfileDataModel(
          profile: ProfileModel(
            id: 10,
            fullName: 'Test User',
            email: 'test@example.com',
            avatarUrl:
                'https://shopguide.medguide.software/storage/avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
          ),
          statistics: StatisticsModel(
            ordersCount: 5,
            favoritesCount: 2,
            subscriptionDaysRemaining: 10,
          ),
          savings: SavingsModel(totalSavings: 150.0, currency: 'ج.م'),
        );

        await localDataSource.cacheProfileData(sampleModel);

        final cached = localDataSource.getCachedProfileData();
        expect(cached, isNotNull);
        expect(cached!.profile.id, 10);
        expect(cached.profile.fullName, 'Test User');
        expect(
          cached.profile.avatarUrl,
          'https://shopguide.medguide.software/public/storage/avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
        );
      },
    );

    test('overwrites old avatar URL when caching updated profile', () async {
      const oldModel = ProfileDataModel(
        profile: ProfileModel(
          id: 10,
          fullName: 'Test User',
          email: 'test@example.com',
          avatarUrl:
              'https://shopguide.medguide.software/public/storage/avatars/4jQ9pTUuojoHDmE2pjOApcTmnBjdtm6gEJ3a2P19.jpg',
        ),
        statistics: StatisticsModel(
          ordersCount: 0,
          favoritesCount: 0,
          subscriptionDaysRemaining: 0,
        ),
        savings: SavingsModel(totalSavings: 0),
      );

      const newModel = ProfileDataModel(
        profile: ProfileModel(
          id: 10,
          fullName: 'Test User',
          email: 'test@example.com',
          avatarUrl:
              'https://shopguide.medguide.software/public/storage/avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
        ),
        statistics: StatisticsModel(
          ordersCount: 0,
          favoritesCount: 0,
          subscriptionDaysRemaining: 0,
        ),
        savings: SavingsModel(totalSavings: 0),
      );

      await localDataSource.cacheProfileData(oldModel);
      expect(
        localDataSource.getCachedProfileData()?.profile.avatarUrl,
        'https://shopguide.medguide.software/public/storage/avatars/4jQ9pTUuojoHDmE2pjOApcTmnBjdtm6gEJ3a2P19.jpg',
      );

      await localDataSource.cacheProfileData(newModel);
      expect(
        localDataSource.getCachedProfileData()?.profile.avatarUrl,
        'https://shopguide.medguide.software/public/storage/avatars/fUOe61j96FT23LzLkoNn3lZx6f8l49oHg89p5dIe.jpg',
      );
    });

    test('clears cached profile data on clearCache', () async {
      const sampleModel = ProfileDataModel(
        profile: ProfileModel(
          id: 1,
          fullName: 'User',
          email: 'u@e.com',
          avatarUrl: 'avatars/sample.jpg',
        ),
        statistics: StatisticsModel(
          ordersCount: 0,
          favoritesCount: 0,
          subscriptionDaysRemaining: 0,
        ),
        savings: SavingsModel(totalSavings: 0),
      );

      await localDataSource.cacheProfileData(sampleModel);
      expect(localDataSource.getCachedProfileData(), isNotNull);

      await localDataSource.clearCache();
      expect(localDataSource.getCachedProfileData(), isNull);
    });
  });
}
