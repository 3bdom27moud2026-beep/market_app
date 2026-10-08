import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/location/domain/entities/area_entity.dart';
import 'package:market/features/location/domain/entities/center_entity.dart';
import 'package:market/features/location/domain/entities/governorate_entity.dart';
import 'package:market/features/location/domain/repository/location_repository.dart';
import 'package:market/features/location/domain/usecases/get_areas_usecase.dart';
import 'package:market/features/location/domain/usecases/get_centers_usecase.dart';
import 'package:market/features/location/domain/usecases/get_governorates_usecase.dart';
import 'package:market/features/location/domain/usecases/save_selected_location_usecase.dart';
import 'package:market/features/location/presentation/cubit/location_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocationRepository implements LocationRepository {
  Either<String, List<GovernorateEntity>> getGovernoratesResult = const Right(
    [],
  );
  Either<String, List<CenterEntity>> getCentersResult = const Right([]);
  Either<String, List<AreaEntity>> getAreasResult = const Right([]);
  Either<String, void> saveLocationResult = const Right(null);

  @override
  Future<Either<String, List<GovernorateEntity>>> getGovernorates() async =>
      getGovernoratesResult;

  @override
  Future<Either<String, List<CenterEntity>>> getCenters(
    int governorateId,
  ) async => getCentersResult;

  @override
  Future<Either<String, List<AreaEntity>>> getAreas(int centerId) async =>
      getAreasResult;

  @override
  Future<Either<String, void>> saveUserLocation({
    required int governorateId,
    required int centerId,
    required int areaId,
  }) async => saveLocationResult;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLocationRepository mockRepository;
  late LocationCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();

    mockRepository = MockLocationRepository();
    cubit = LocationCubit(
      getGovernoratesUseCase: GetGovernoratesUseCase(mockRepository),
      getCentersUseCase: GetCentersUseCase(mockRepository),
      getAreasUseCase: GetAreasUseCase(mockRepository),
      saveSelectedLocationUseCase: SaveSelectedLocationUseCase(mockRepository),
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('LocationCubit Tests', () {
    const tGov = GovernorateEntity(id: 1, name: 'البحيرة');
    const tCenter = CenterEntity(id: 10, name: 'دمنهور', governorateId: 1);
    const tArea = AreaEntity(id: 101, name: 'شبرا', centerId: 10);

    test('loadGovernorates emits loaded governorates', () async {
      mockRepository.getGovernoratesResult = const Right([tGov]);

      await cubit.loadGovernorates();

      expect(cubit.state.governorates, equals([tGov]));
      expect(cubit.state.isLoadingGovernorates, isFalse);
    });

    test('selectGovernorate loads centers and updates selection', () async {
      mockRepository.getCentersResult = const Right([tCenter]);

      await cubit.selectGovernorate(tGov);

      expect(cubit.state.selectedGovernorate, equals(tGov));
      expect(cubit.state.centers, equals([tCenter]));
      expect(cubit.state.isLoadingCenters, isFalse);
    });

    test('selectCenter loads areas and updates selection', () async {
      mockRepository.getAreasResult = const Right([tArea]);

      await cubit.selectCenter(tCenter);

      expect(cubit.state.selectedCenter, equals(tCenter));
      expect(cubit.state.areas, equals([tArea]));
      expect(cubit.state.isLoadingAreas, isFalse);
    });

    test('selectArea updates selectedArea in state', () {
      cubit.selectArea(tArea);

      expect(cubit.state.selectedArea, equals(tArea));
    });

    test(
      'confirmLocation persists selection to CacheHelper and succeeds',
      () async {
        cubit.emit(
          cubit.state.copyWith(
            selectedGovernorate: tGov,
            selectedCenter: tCenter,
            selectedArea: tArea,
          ),
        );

        await cubit.confirmLocation();

        expect(cubit.state.isSuccess, isTrue);
        expect(cubit.state.isSaving, isFalse);
        expect(CacheHelper.selectedGovernorateId, equals(1));
        expect(CacheHelper.selectedCenterId, equals(10));
        expect(CacheHelper.selectedAreaId, equals(101));
        expect(CacheHelper.selectedLocationName, equals('البحيرة، دمنهور'));
      },
    );

    test(
      'confirmLocation persists locally even if remote use case returns error',
      () async {
        mockRepository.saveLocationResult = const Left('Server error');

        cubit.emit(
          cubit.state.copyWith(
            selectedGovernorate: tGov,
            selectedCenter: tCenter,
            selectedArea: tArea,
          ),
        );

        await cubit.confirmLocation();

        expect(cubit.state.isSuccess, isTrue);
        expect(cubit.state.isSaving, isFalse);
        expect(CacheHelper.selectedGovernorateId, equals(1));
        expect(CacheHelper.selectedCenterId, equals(10));
        expect(CacheHelper.selectedAreaId, equals(101));
        expect(CacheHelper.selectedLocationName, equals('البحيرة، دمنهور'));
      },
    );
  });
}
