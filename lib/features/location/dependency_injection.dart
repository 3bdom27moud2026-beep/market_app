import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/location/data/datasource/remote/location_remote_datasource.dart';
import 'package:market/features/location/data/repository/location_repository_impl.dart';
import 'package:market/features/location/domain/repository/location_repository.dart';
import 'package:market/features/location/domain/usecases/get_areas_usecase.dart';
import 'package:market/features/location/domain/usecases/get_centers_usecase.dart';
import 'package:market/features/location/domain/usecases/get_governorates_usecase.dart';
import 'package:market/features/location/domain/usecases/save_selected_location_usecase.dart';
import 'package:market/features/location/presentation/cubit/location_cubit.dart';

/// Dependency injection for the location feature.
abstract final class LocationDI {
  /// Creates a [LocationCubit] with all its dependencies.
  static LocationCubit createLocationCubit() {
    final apiClient = CoreDI.sl<ApiClient>();

    final remoteDataSource = LocationRemoteDataSourceImpl(apiClient);
    final repository =
        LocationRepositoryImpl(remoteDataSource) as LocationRepository;

    final getGovernoratesUseCase = GetGovernoratesUseCase(repository);
    final getCentersUseCase = GetCentersUseCase(repository);
    final getAreasUseCase = GetAreasUseCase(repository);
    final saveSelectedLocationUseCase = SaveSelectedLocationUseCase(repository);

    return LocationCubit(
      getGovernoratesUseCase: getGovernoratesUseCase,
      getCentersUseCase: getCentersUseCase,
      getAreasUseCase: getAreasUseCase,
      saveSelectedLocationUseCase: saveSelectedLocationUseCase,
    );
  }
}
