import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/api_client.dart';
import 'data/datasource/remote/profile_remote_datasource.dart';
import 'data/datasource/local/profile_local_datasource.dart';
import 'data/repository/profile_repository_impl.dart';
import 'domain/repository/profile_repository.dart';
import 'domain/usecases/change_password_usecase.dart';
import 'domain/usecases/get_profile_data.dart';
import 'presentation/cubit/change_password_cubit.dart';
import 'presentation/cubit/profile_cubit.dart';

/// Dependency injection for the Profile feature.
abstract final class ProfileDI {
  /// Creates a [ProfileRepository] instance.
  static ProfileRepository createProfileRepository() {
    final apiClient = CoreDI.sl<ApiClient>();
    final remoteDataSource = ProfileRemoteDataSourceImpl(apiClient: apiClient);
    final localDataSource = ProfileLocalDataSourceImpl();
    return ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  }

  /// Creates a [ProfileCubit] with all its dependencies.
  static ProfileCubit createProfileCubit() {
    final repository = createProfileRepository();
    final useCase = GetProfileData(repository: repository);

    return ProfileCubit(getProfileData: useCase);
  }

  /// Creates a [ChangePasswordCubit] with all its dependencies.
  static ChangePasswordCubit createChangePasswordCubit() {
    final repository = createProfileRepository();
    final useCase = ChangePasswordUseCase(repository: repository);

    return ChangePasswordCubit(changePasswordUseCase: useCase);
  }
}
