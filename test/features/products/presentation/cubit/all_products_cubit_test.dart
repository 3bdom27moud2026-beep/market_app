import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/products/domain/entities/product_entity.dart';
import 'package:market/features/products/domain/repository/products_repository.dart';
import 'package:market/features/products/presentation/cubit/all_products_cubit.dart';
import 'package:market/features/products/presentation/cubit/all_products_state.dart';

class MockProductsRepository implements ProductsRepository {
  List<ProductEntity> productsToReturn = [];
  String? errorToReturn;
  bool toggleResult = true;

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

  @override
  Future<Either<String, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<String, bool>> toggleFavorite(String productId) async {
    return Right(toggleResult);
  }

  @override
  Future<Either<String, void>> shareProduct(String productId) async {
    return const Right(null);
  }
}

void main() {
  late MockProductsRepository mockRepo;
  late AllProductsCubit cubit;

  const testProduct1 = ProductEntity(
    id: '1',
    name: 'سماعات بلوتوث لاسلكية',
    store: 'متجر التكنولوجيا',
    image: 'https://example.com/p1.jpg',
    price: 150.0,
    oldPrice: 200.0,
    discount: 25,
    rating: 4.8,
    isFavorite: false,
    merchantCategoryId: '10',
    isFlashSale: true,
  );

  const testProduct2 = ProductEntity(
    id: '2',
    name: 'شاحن سريع جداري',
    store: 'متجر الهواتف',
    image: 'https://example.com/p2.jpg',
    price: 80.0,
    oldPrice: 80.0,
    discount: 0,
    rating: 4.2,
    isFavorite: true,
    merchantCategoryId: '10',
    isFlashSale: false,
  );

  const testProduct3 = ProductEntity(
    id: '3',
    name: 'جراب هاتف جلد فاخر',
    store: 'متجر الإكسسوارات',
    image: 'https://example.com/p3.jpg',
    price: 50.0,
    oldPrice: 50.0,
    discount: 0,
    rating: 4.9,
    isFavorite: false,
    merchantCategoryId: '10',
    isFlashSale: false,
  );

  setUp(() {
    mockRepo = MockProductsRepository();
    cubit = AllProductsCubit(repository: mockRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('AllProductsCubit Tests', () {
    test('initial state is AllProductsInitial', () {
      expect(cubit.state, const AllProductsInitial());
    });

    test(
      'loadProducts emits loading then loaded when products exist',
      () async {
        mockRepo.productsToReturn = [testProduct1, testProduct2, testProduct3];

        final expectedStates = [
          const AllProductsLoading(),
          AllProductsLoaded(
            allProducts: [testProduct1, testProduct2, testProduct3],
            filteredProducts: [testProduct1, testProduct2, testProduct3],
            selectedFilter: ProductCatalogFilter.all,
            searchQuery: '',
            favoriteProductIds: const {'2'},
          ),
        ];

        expectLater(cubit.stream, emitsInOrder(expectedStates));

        await cubit.loadProducts();
      },
    );

    test('loadProducts emits loading then empty when list is empty', () async {
      mockRepo.productsToReturn = [];

      final expectedStates = [
        const AllProductsLoading(),
        const AllProductsEmpty(selectedFilter: ProductCatalogFilter.all),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadProducts();
    });

    test('loadProducts emits loading then error on failure', () async {
      mockRepo.errorToReturn = 'Network failure';

      final expectedStates = [
        const AllProductsLoading(),
        const AllProductsError(message: 'Network failure'),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.loadProducts();
    });

    test('setFilter filters and sorts products properly', () async {
      mockRepo.productsToReturn = [testProduct1, testProduct2, testProduct3];
      await cubit.loadProducts();

      // Switch to flashSale filter
      cubit.setFilter(ProductCatalogFilter.flashSale);
      var loaded = cubit.state as AllProductsLoaded;
      expect(loaded.selectedFilter, ProductCatalogFilter.flashSale);
      expect(loaded.filteredProducts.length, 1);
      expect(loaded.filteredProducts.first.id, '1');

      // Switch to bestSellers (sorted by rating descending: p3=4.9, p1=4.8, p2=4.2)
      cubit.setFilter(ProductCatalogFilter.bestSellers);
      loaded = cubit.state as AllProductsLoaded;
      expect(loaded.selectedFilter, ProductCatalogFilter.bestSellers);
      expect(loaded.filteredProducts.length, 3);
      expect(loaded.filteredProducts[0].id, '3');
      expect(loaded.filteredProducts[1].id, '1');
      expect(loaded.filteredProducts[2].id, '2');

      // Switch to newest (sorted by id desc: 3, 2, 1)
      cubit.setFilter(ProductCatalogFilter.newest);
      loaded = cubit.state as AllProductsLoaded;
      expect(loaded.selectedFilter, ProductCatalogFilter.newest);
      expect(loaded.filteredProducts[0].id, '3');
      expect(loaded.filteredProducts[1].id, '2');
      expect(loaded.filteredProducts[2].id, '1');
    });

    test('searchProducts filters products in real time', () async {
      mockRepo.productsToReturn = [testProduct1, testProduct2, testProduct3];
      await cubit.loadProducts();

      cubit.searchProducts('سماعات');

      expect(cubit.state, isA<AllProductsLoaded>());
      final loaded = cubit.state as AllProductsLoaded;
      expect(loaded.filteredProducts.length, 1);
      expect(loaded.filteredProducts.first.name, 'سماعات بلوتوث لاسلكية');
      expect(loaded.searchQuery, 'سماعات');
    });

    test('toggleFavorite toggles product ID in favorite set', () async {
      mockRepo.productsToReturn = [testProduct1, testProduct2, testProduct3];
      await cubit.loadProducts();

      mockRepo.toggleResult = true;
      await cubit.toggleFavorite('1');
      var loaded = cubit.state as AllProductsLoaded;
      expect(loaded.favoriteProductIds.contains('1'), isTrue);

      mockRepo.toggleResult = false;
      await cubit.toggleFavorite('1');
      loaded = cubit.state as AllProductsLoaded;
      expect(loaded.favoriteProductIds.contains('1'), isFalse);
    });
  });
}
