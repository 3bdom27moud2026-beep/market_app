import 'package:market/core/utils/api_client.dart';
import 'package:market/features/flash_sale/data/datasource/remote/flash_sale_remote_datasource.dart';
import 'package:market/features/flash_sale/data/repository/flash_sale_repository_impl.dart';
import 'package:market/features/flash_sale/domain/usecases/get_flash_sale_usecase.dart';
import 'package:market/features/flash_sale/presentation/cubit/flash_sale_cubit.dart';

/// Dependency injection for the Flash Sale feature.
class FlashSaleDI {
  /// Creates and provides the FlashSaleCubit.
  static FlashSaleCubit createFlashSaleCubit({required ApiClient apiClient}) {
    final remoteDataSource = FlashSaleRemoteDataSource(apiClient: apiClient);
    final repository = FlashSaleRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final useCase = GetFlashSaleUseCase(repository: repository);
    return FlashSaleCubit(getFlashSaleUseCase: useCase);
  }
}
