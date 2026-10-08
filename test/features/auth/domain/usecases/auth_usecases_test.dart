import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:market/features/auth/domain/usecases/logout_usecase.dart';

class MockFullAuthRepository implements AuthRepository {
  bool isAuth = false;
  UserEntity? user;

  @override
  bool isLoggedIn() => isAuth;

  @override
  UserEntity? getCurrentUser() => user;

  @override
  Future<Either<Failure, void>> logout() async {
    isAuth = false;
    user = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginRequestModel request) async =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, UserEntity>> register(
    RegisterRequestModel request,
  ) async => throw UnimplementedError();
}

void main() {
  late MockFullAuthRepository repository;

  setUp(() {
    repository = MockFullAuthRepository();
  });

  test('CheckAuthUseCase returns boolean status from repository', () {
    final useCase = CheckAuthUseCase(repository);
    repository.isAuth = true;
    expect(useCase(), true);

    repository.isAuth = false;
    expect(useCase(), false);
  });

  test('GetCurrentUserUseCase returns active user entity from repository', () {
    final useCase = GetCurrentUserUseCase(repository);
    const mockUser = UserEntity(
      id: 'usr_1',
      name: 'محمود',
      email: 'm@example.com',
      phone: '01012345678',
      token: 'token_abc',
    );
    repository.user = mockUser;

    expect(useCase(), mockUser);
  });

  test('LogoutUseCase triggers logout on repository', () async {
    final useCase = LogoutUseCase(repository);
    repository.isAuth = true;

    final res = await useCase();
    expect(res, const Right(null));
    expect(repository.isAuth, false);
  });
}
