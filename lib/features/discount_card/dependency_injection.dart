import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/discount_card/domain/repository/discount_card_repository.dart';
import 'package:market/features/discount_card/domain/usecases/get_discount_card_data_usecase.dart';
import 'package:market/features/discount_card/domain/usecases/request_card_usecase.dart';
import 'package:market/features/discount_card/data/datasource/remote/discount_card_remote_datasource.dart';
import 'package:market/features/discount_card/data/repository/discount_card_repository_impl.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';

/// Dependency injection for the discount card feature.
abstract final class DiscountCardDI {
  /// Initializes the discount card feature dependencies.
  static void init() {
    // Dependencies are created lazily in providers
  }

  /// Creates a [DiscountCardCubit] with all its dependencies.
  static DiscountCardCubit createDiscountCardCubit() {
    final apiClient = CoreDI.sl<ApiClient>();

    final remoteDataSource = DiscountCardRemoteDataSource(apiClient: apiClient);
    final repository =
        DiscountCardRepositoryImpl(remoteDataSource: remoteDataSource)
            as DiscountCardRepository;
    final getDiscountCardDataUseCase = GetDiscountCardDataUseCase(repository);
    final requestCardUseCase = RequestCardUseCase(repository);
    final checkAuthUseCase = CoreDI.sl.isRegistered<CheckAuthUseCase>()
        ? CoreDI.sl<CheckAuthUseCase>()
        : null;

    return DiscountCardCubit(
      getDiscountCardDataUseCase,
      requestCardUseCase,
      checkAuthUseCase,
    );
  }
}
