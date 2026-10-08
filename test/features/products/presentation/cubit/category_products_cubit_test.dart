import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';
import 'package:market/features/products/domain/repository/products_repository.dart';
import 'package:market/features/products/presentation/cubit/category_products_cubit.dart';
import 'package:market/features/products/presentation/cubit/category_products_state.dart';

class MockProductsRepository implements ProductsRepository {
  List<ProductEntity> productsToReturn = [];
  String? errorToReturn;

  @override
  Future<Either<String, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) async {
    if (errorToReturn != null) {
      return Left(errorToReturn!);
    }
    return Right(productsToReturn);
  }

  @override
  Future<Either<String, List<ProductEntity>>> getProducts() async {
    if (errorToReturn != null) {
      return Left(errorToReturn!);
    }
    return Right(productsToReturn);
  }

  @override
  Future<Either<String, ProductEntity>> getProductDetails(String id) async {
    throw UnimplementedError();
  }

  bool nextFavoriteAction = true;

  @override
  Future<Either<String, bool>> toggleFavorite(String productId) async {
    final result = nextFavoriteAction;
    nextFavoriteAction = !nextFavoriteAction;
    return Right(result);
  }

  @override
  Future<Either<String, void>> shareProduct(String productId) async {
    return const Right(null);
  }
}

void main() {
  late MockProductsRepository mockRepo;
  late CategoryProductsCubit cubit;

  const testProduct1 = ProductEntity(
    id: '1',
    name: 'تأسيس وصيانة سباكة منزلية',
    store: 'مؤسسة السباك المحترف',
    image: 'https://images.unsplash.com/photo-1581092160562-40aa08e78837',
    price: 200,
    oldPrice: 350,
    discount: 43,
    rating: 4.9,
    merchantCategoryId: '10',
    brand: 'الشركة الهندسية',
    description: 'تأسيس وصيانة سباكة منزلية',
  );

  const testProduct2 = ProductEntity(
    id: '2',
    name: 'صيانة أدوات صحية وخلاطات',
    store: 'سباكة المحترفين',
    image: 'https://images.unsplash.com/photo-1585704032915',
    price: 150,
    oldPrice: 200,
    discount: 25,
    rating: 4.7,
    merchantCategoryId: '10',
    brand: 'السباك المعتمد',
    description: 'صيانة خلاطات ومحابس',
  );

  setUp(() {
    mockRepo = MockProductsRepository();
    cubit = CategoryProductsCubit(repository: mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('CategoryProductsCubit', () {
    test('initial state is CategoryProductsInitial', () {
      expect(cubit.state, const CategoryProductsInitial());
    });

    test(
      'loadProducts emits loading then loaded when products exist',
      () async {
        mockRepo.productsToReturn = [testProduct1, testProduct2];

        final expectedStates = [
          const CategoryProductsLoading(),
          CategoryProductsLoaded(
            products: [testProduct1, testProduct2],
            filteredProducts: [testProduct1, testProduct2],
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.loadProducts('10');
      },
    );

    test('loadProducts emits loading then empty when list is empty', () async {
      mockRepo.productsToReturn = [];

      final expectedStates = [
        const CategoryProductsLoading(),
        const CategoryProductsEmpty(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadProducts('10');
    });

    test('loadProducts emits loading then error on failure', () async {
      mockRepo.errorToReturn = 'Failed to load products';

      final expectedStates = [
        const CategoryProductsLoading(),
        const CategoryProductsError(message: 'Failed to load products'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadProducts('10');
    });

    test('searchProducts filters products locally in real-time', () async {
      mockRepo.productsToReturn = [testProduct1, testProduct2];
      await cubit.loadProducts('10');

      cubit.searchProducts('خلاطات');

      expect(cubit.state, isA<CategoryProductsLoaded>());
      final loadedState = cubit.state as CategoryProductsLoaded;
      expect(loadedState.filteredProducts.length, 1);
      expect(
        loadedState.filteredProducts.first.name,
        'صيانة أدوات صحية وخلاطات',
      );
      expect(loadedState.searchQuery, 'خلاطات');

      // Clear search
      cubit.searchProducts('');
      final resetState = cubit.state as CategoryProductsLoaded;
      expect(resetState.filteredProducts.length, 2);
    });

    test('toggleFavorite toggles product ID in favorite set', () async {
      mockRepo.productsToReturn = [testProduct1, testProduct2];
      await cubit.loadProducts('10');

      await cubit.toggleFavorite('1');
      var loadedState = cubit.state as CategoryProductsLoaded;
      expect(loadedState.favoriteProductIds.contains('1'), isTrue);

      await cubit.toggleFavorite('1');
      loadedState = cubit.state as CategoryProductsLoaded;
      expect(loadedState.favoriteProductIds.contains('1'), isFalse);
    });
  });
}
