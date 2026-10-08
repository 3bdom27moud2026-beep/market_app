import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/favorites/domain/entities/favorite_entity.dart';
import 'package:market/features/favorites/domain/repository/favorites_repository.dart';
import 'package:market/features/favorites/domain/usecases/favorites_usecases.dart';
import 'package:market/features/merchants/domain/entities/merchant_entity.dart';
import 'package:market/features/merchants/domain/entities/merchant_product_entity.dart';
import 'package:market/features/merchants/domain/repository/merchants_repository.dart';
import 'package:market/features/merchants/presentation/cubit/merchants_cubit.dart';
import 'package:market/features/merchants/presentation/cubit/merchants_state.dart';

class MockMerchantsRepository implements MerchantsRepository {
  List<MerchantEntity> merchantsToReturn = [];
  String? errorToReturn;

  @override
  Future<Either<String, List<MerchantEntity>>> getMerchantsByCategory(
    String categoryId,
  ) async {
    if (errorToReturn != null) {
      return Left(errorToReturn!);
    }
    return Right(merchantsToReturn);
  }

  @override
  Future<Either<String, (MerchantEntity, List<MerchantProductEntity>)>>
  getMerchantDetails(String id) async {
    throw UnimplementedError();
  }
}

class MockFavoritesRepository implements FavoritesRepository {
  List<FavoriteMerchantEntity> favoriteMerchantsToReturn = [];
  bool? toggleResultToReturn;
  String? toggleErrorToReturn;

  @override
  Future<Either<String, List<FavoriteEntity>>> getFavorites() async {
    return const Right([]);
  }

  @override
  Future<Either<String, List<FavoriteMerchantEntity>>>
  getFavoriteMerchants() async {
    return Right(favoriteMerchantsToReturn);
  }

  @override
  Future<Either<String, bool>> toggleFavorite(
    String id, {
    String type = 'product',
  }) async {
    if (toggleErrorToReturn != null) {
      return Left(toggleErrorToReturn!);
    }
    return Right(toggleResultToReturn ?? true);
  }
}

void main() {
  late MockMerchantsRepository mockRepo;
  late MerchantsCubit cubit;

  const testMerchant1 = MerchantEntity(
    id: 1,
    name: 'مؤسسة السباك المحترف',
    description: 'شريك معتمد لـ شوب جايد',
    image: 'https://example.com/plumber.png',
    phone: '01000000000',
    whatsapp: '01012345678',
    email: 'plumber@example.com',
    address: 'مصر، الفرع الرئيسي',
    lat: 30.0444,
    lng: 31.2357,
    discount: '10%',
    type: 'retail',
    rating: 4.8,
    reviewCount: 120,
    orderCount: 45,
    supportsInstallment: true,
    isWholesale: false,
    status: 'active',
    distance: '2.5 كم',
    category: MerchantCategoryEntity(
      id: 10,
      name: 'سباكة',
      slug: 'plumbing',
      icon: 'plumbing.png',
      color: '#FFFFFF',
      iconColor: '#000000',
    ),
  );

  const testMerchant2 = MerchantEntity(
    id: 2,
    name: 'متجر الكهرباء الحديثة',
    description: 'صيانة وتوريدات كهرباء',
    image: 'https://example.com/electric.png',
    phone: '01100000000',
    whatsapp: '01112345678',
    email: 'electric@example.com',
    address: 'مصر، الجيزة',
    lat: 30.0,
    lng: 31.2,
    discount: '15%',
    type: 'retail',
    rating: 4.6,
    reviewCount: 80,
    orderCount: 30,
    supportsInstallment: false,
    isWholesale: false,
    status: 'active',
    distance: '3.0 كم',
    category: MerchantCategoryEntity(
      id: 11,
      name: 'كهرباء',
      slug: 'electricity',
      icon: 'electricity.png',
      color: '#FFFFFF',
      iconColor: '#000000',
    ),
  );

  setUp(() {
    mockRepo = MockMerchantsRepository();
    cubit = MerchantsCubit(repository: mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('MerchantsCubit Tests', () {
    test('initial state is MerchantsInitial', () {
      expect(cubit.state, const MerchantsInitial());
    });

    test(
      'loadMerchants emits loading then loaded when merchants exist',
      () async {
        mockRepo.merchantsToReturn = [testMerchant1, testMerchant2];

        final expectedStates = [
          const MerchantsLoading(),
          MerchantsLoaded(
            merchants: [testMerchant1, testMerchant2],
            filteredMerchants: [testMerchant1, testMerchant2],
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.loadMerchants();
      },
    );

    test(
      'loadMerchants with categoryId emits loaded with selectedCategoryId',
      () async {
        mockRepo.merchantsToReturn = [testMerchant1];

        final expectedStates = [
          const MerchantsLoading(),
          MerchantsLoaded(
            merchants: [testMerchant1],
            filteredMerchants: [testMerchant1],
            selectedCategoryId: '1',
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.loadMerchants(categoryId: '1');
      },
    );

    test('loadMerchants emits loading then empty when list is empty', () async {
      mockRepo.merchantsToReturn = [];

      final expectedStates = [const MerchantsLoading(), const MerchantsEmpty()];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadMerchants();
    });

    test('loadMerchants emits loading then error on failure', () async {
      mockRepo.errorToReturn = 'Failed to load merchants';

      final expectedStates = [
        const MerchantsLoading(),
        const MerchantsError(message: 'Failed to load merchants'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadMerchants();
    });

    test('searchMerchants filters merchants locally in real time', () async {
      mockRepo.merchantsToReturn = [testMerchant1, testMerchant2];
      await cubit.loadMerchants();

      cubit.searchMerchants('كهرباء');

      expect(cubit.state, isA<MerchantsLoaded>());
      final loaded = cubit.state as MerchantsLoaded;
      expect(loaded.filteredMerchants.length, 1);
      expect(loaded.filteredMerchants.first.name, 'متجر الكهرباء الحديثة');
      expect(loaded.searchQuery, 'كهرباء');

      // Clear search
      cubit.searchMerchants('');
      final cleared = cubit.state as MerchantsLoaded;
      expect(cleared.filteredMerchants.length, 2);
    });

    test('filterByCategory filters merchants by category ID', () async {
      mockRepo.merchantsToReturn = [testMerchant1, testMerchant2];
      await cubit.loadMerchants();

      // Filter by category 10 (testMerchant1)
      cubit.filterByCategory('10');
      var loaded = cubit.state as MerchantsLoaded;
      expect(loaded.filteredMerchants.length, 1);
      expect(loaded.filteredMerchants.first.id, 1);
      expect(loaded.selectedCategoryId, '10');

      // Clear filter
      cubit.filterByCategory(null);
      loaded = cubit.state as MerchantsLoaded;
      expect(loaded.filteredMerchants.length, 2);
      expect(loaded.selectedCategoryId, isNull);
    });

    test('searchMerchants respects active selectedCategoryId', () async {
      mockRepo.merchantsToReturn = [testMerchant1, testMerchant2];
      await cubit.loadMerchants(categoryId: '10');

      // Search for something that matches testMerchant2 but not in category 10
      cubit.searchMerchants('كهرباء');
      var loaded = cubit.state as MerchantsLoaded;
      expect(loaded.filteredMerchants.isEmpty, isTrue);

      // Search for something matching testMerchant1 in category 10
      cubit.searchMerchants('سباك');
      loaded = cubit.state as MerchantsLoaded;
      expect(loaded.filteredMerchants.length, 1);
      expect(loaded.filteredMerchants.first.id, 1);
    });

    test('toggleFavorite toggles merchant ID in favorite set', () async {
      mockRepo.merchantsToReturn = [testMerchant1, testMerchant2];
      await cubit.loadMerchants();

      cubit.toggleFavorite(1);
      var loaded = cubit.state as MerchantsLoaded;
      expect(loaded.favoriteMerchantIds.contains(1), isTrue);

      cubit.toggleFavorite(1);
      loaded = cubit.state as MerchantsLoaded;
      expect(loaded.favoriteMerchantIds.contains(1), isFalse);
    });

    test(
      'does not throw or emit when closed while loadMerchants is executing',
      () async {
        mockRepo.merchantsToReturn = [testMerchant1];
        final future = cubit.loadMerchants();
        await cubit.close();
        await expectLater(future, completes);
      },
    );

    test(
      'loadMerchants populates favoriteMerchantIds when usecase is provided',
      () async {
        final mockFavRepo = MockFavoritesRepository();
        mockFavRepo.favoriteMerchantsToReturn = [
          const FavoriteMerchantEntity(
            id: 2,
            name: 'متجر الكهرباء الحديثة',
            image: '',
            category: 'كهرباء',
            rating: 4.6,
            discount: '',
          ),
        ];

        final customCubit = MerchantsCubit(
          repository: mockRepo,
          getFavoriteMerchantsUseCase: GetFavoriteMerchantsUseCase(mockFavRepo),
        );

        mockRepo.merchantsToReturn = [testMerchant1, testMerchant2];
        await customCubit.loadMerchants();

        expect(customCubit.state, isA<MerchantsLoaded>());
        final loaded = customCubit.state as MerchantsLoaded;
        expect(loaded.favoriteMerchantIds.contains(2), isTrue);
        expect(loaded.favoriteMerchantIds.contains(1), isFalse);

        await customCubit.close();
      },
    );

    test(
      'toggleFavorite reverts state if ToggleFavoriteUseCase returns an error',
      () async {
        final mockFavRepo = MockFavoritesRepository();
        mockFavRepo.toggleErrorToReturn = 'Network error';

        final customCubit = MerchantsCubit(
          repository: mockRepo,
          toggleFavoriteUseCase: ToggleFavoriteUseCase(mockFavRepo),
        );

        mockRepo.merchantsToReturn = [testMerchant1, testMerchant2];
        await customCubit.loadMerchants();

        await customCubit.toggleFavorite(1);

        expect(customCubit.state, isA<MerchantsLoaded>());
        final loaded = customCubit.state as MerchantsLoaded;
        // Should have reverted to false
        expect(loaded.favoriteMerchantIds.contains(1), isFalse);

        await customCubit.close();
      },
    );
  });
}
