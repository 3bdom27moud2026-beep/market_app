import 'package:get_it/get_it.dart';
import '../../core/utils/api_client.dart';
import 'data/datasource/remote/orders_remote_datasource.dart';
import 'data/repository/orders_repository_impl.dart';
import 'domain/repository/orders_repository.dart';
import 'domain/usecases/cancel_order_usecase.dart';
import 'domain/usecases/get_order_details_usecase.dart';
import 'domain/usecases/get_orders_usecase.dart';
import 'presentation/cubit/orders_cubit.dart';

abstract final class OrdersDI {
  static void init(GetIt sl) {
    // Data source
    if (!sl.isRegistered<OrdersRemoteDataSource>()) {
      sl.registerLazySingleton<OrdersRemoteDataSource>(
        () => OrdersRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
      );
    }

    // Repository
    if (!sl.isRegistered<OrdersRepository>()) {
      sl.registerLazySingleton<OrdersRepository>(
        () => OrdersRepositoryImpl(
          remoteDataSource: sl<OrdersRemoteDataSource>(),
        ),
      );
    }

    // Use cases
    if (!sl.isRegistered<GetOrdersUseCase>()) {
      sl.registerLazySingleton<GetOrdersUseCase>(
        () => GetOrdersUseCase(repository: sl<OrdersRepository>()),
      );
    }

    if (!sl.isRegistered<GetOrderDetailsUseCase>()) {
      sl.registerLazySingleton<GetOrderDetailsUseCase>(
        () => GetOrderDetailsUseCase(repository: sl<OrdersRepository>()),
      );
    }

    if (!sl.isRegistered<CancelOrderUseCase>()) {
      sl.registerLazySingleton<CancelOrderUseCase>(
        () => CancelOrderUseCase(repository: sl<OrdersRepository>()),
      );
    }

    // Cubit
    if (!sl.isRegistered<OrdersCubit>()) {
      sl.registerFactory<OrdersCubit>(
        () => OrdersCubit(
          getOrdersUseCase: sl<GetOrdersUseCase>(),
          cancelOrderUseCase: sl<CancelOrderUseCase>(),
        ),
      );
    }
  }

  static OrdersCubit initCubit() {
    final sl = GetIt.instance;
    init(sl);
    return sl<OrdersCubit>();
  }
}
