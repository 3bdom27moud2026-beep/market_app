import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/promotions/data/models/startup_promotion_model.dart';
import 'package:market/features/promotions/domain/entities/startup_promotion_entity.dart';
import 'package:market/features/promotions/domain/repository/startup_promotion_repository.dart';
import 'package:market/features/promotions/domain/usecases/get_startup_promotion_usecase.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_cubit.dart';

class MockStartupPromotionRepository implements StartupPromotionRepository {
  final StartupPromotionEntity? returnEntity;
  final String? returnError;

  MockStartupPromotionRepository({this.returnEntity, this.returnError});

  @override
  Future<Either<String, StartupPromotionEntity?>> getStartupPromotion() async {
    if (returnError != null) {
      return Left(returnError!);
    }
    return Right(returnEntity);
  }

  @override
  Future<bool> isPromotionShown() async => false;

  @override
  Future<void> setPromotionShown() async {}
}

void main() {
  group('StartupPromotionModel', () {
    test('correctly parses featured_ad structure', () {
      final json = {
        'id': 3,
        'name': 'وجبة برجر دبل تشيز صوص',
        'brand': 'برجر كينج',
        'price': 200,
        'member_price': 99,
        'original_price': 200,
        'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        'rating': 4.7,
        'reviews': 310,
        'headline': 'عرض حصري لفترة محدودة!',
        'tagline': 'اطلب الآن — الكمية محدودة',
      };

      final model = StartupPromotionModel.fromJson(json);

      expect(model.id, '3');
      expect(model.title, 'وجبة برجر دبل تشيز صوص');
      expect(model.store, 'برجر كينج');
      expect(model.price, 99.0);
      expect(model.oldPrice, 200.0);
      expect(model.discount, 51); // ((200-99)/200)*100 = 50.5 -> 51
      expect(model.rating, 4.7);
      expect(model.reviews, 310);
      expect(model.description, 'عرض حصري لفترة محدودة!');
      expect(model.specialOffer, 'عرض خاص');
    });

    test('converts to StartupPromotionEntity properly', () {
      const model = StartupPromotionModel(
        id: '1',
        title: 'عرض خاص',
        store: 'متجر التوفير',
        image: 'https://example.com/img.jpg',
        price: 150.0,
        oldPrice: 300.0,
        discount: 50,
        rating: 4.9,
        reviews: 120,
        description: 'أفضل عرض',
        stockMessage: 'الكمية محدودة',
        buttonText: 'احصل على العرض',
        specialOffer: 'أفضل عرض',
      );

      final entity = model.toEntity();

      expect(entity.id, '1');
      expect(entity.title, 'عرض خاص');
      expect(entity.discount, 50);
      expect(entity.specialOffer, 'أفضل عرض');
    });
  });

  group('StartupPromotionCubit', () {
    const testEntity = StartupPromotionEntity(
      id: '3',
      title: 'وجبة برجر دبل تشيز صوص',
      store: 'برجر كينج',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
      price: 99.0,
      oldPrice: 200.0,
      discount: 50,
      rating: 4.7,
      reviews: 310,
      description: 'عرض حصري لفترة محدودة!',
      stockMessage: 'اطلب الآن',
      buttonText: 'احصل على العرض',
      specialOffer: 'أفضل عرض',
    );

    test('initial state has no promotion and is not visible', () {
      final repository = MockStartupPromotionRepository(
        returnEntity: testEntity,
      );
      final useCase = GetStartupPromotion(repository: repository);
      final cubit = StartupPromotionCubit(getStartupPromotion: useCase);

      expect(cubit.state.promotion, isNull);
      expect(cubit.state.isVisible, isFalse);
      expect(cubit.state.isLoading, isFalse);
    });

    test('loadPromotion updates promotion state', () async {
      final repository = MockStartupPromotionRepository(
        returnEntity: testEntity,
      );
      final useCase = GetStartupPromotion(repository: repository);
      final cubit = StartupPromotionCubit(getStartupPromotion: useCase);

      await cubit.loadPromotion();

      expect(cubit.state.promotion, equals(testEntity));
      expect(cubit.state.isLoading, isFalse);
    });

    test('showPopup and closePopup toggle isVisible properly', () async {
      final repository = MockStartupPromotionRepository(
        returnEntity: testEntity,
      );
      final useCase = GetStartupPromotion(repository: repository);
      final cubit = StartupPromotionCubit(getStartupPromotion: useCase);

      await cubit.loadPromotion();
      expect(cubit.state.isVisible, isFalse);

      cubit.showPopup();
      expect(cubit.state.isVisible, isTrue);

      cubit.closePopup();
      expect(cubit.state.isVisible, isFalse);
    });
  });
}
