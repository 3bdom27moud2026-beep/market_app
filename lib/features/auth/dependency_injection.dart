import 'package:get_it/get_it.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/features/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:market/features/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:market/features/auth/data/repository/auth_repository_impl.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:market/features/auth/domain/usecases/login_usecase.dart';
import 'package:market/features/auth/domain/usecases/logout_usecase.dart';
import 'package:market/features/auth/domain/usecases/register_usecase.dart';
import 'package:market/features/auth/presentation/cubit/auth_cubit.dart';

abstract final class AuthDI {
  static void init(GetIt sl) {
    // Data Sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<ApiClient>()),
    );
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    );

    // Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl<AuthRemoteDataSource>(),
        localDataSource: sl<AuthLocalDataSource>(),
      ),
    );

    // Use Cases
    sl.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<AuthRepository>()),
    );
    sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<AuthRepository>()),
    );
    sl.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<AuthRepository>()),
    );
    sl.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(sl<AuthRepository>()),
    );
    sl.registerLazySingleton<CheckAuthUseCase>(
      () => CheckAuthUseCase(sl<AuthRepository>()),
    );

    // Cubit
    sl.registerFactory<AuthCubit>(
      () => AuthCubit(
        registerUseCase: sl<RegisterUseCase>(),
        loginUseCase: sl<LoginUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
        getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
        checkAuthUseCase: sl<CheckAuthUseCase>(),
      ),
    );
  }
}
