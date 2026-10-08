import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:market/features/auth/domain/usecases/login_usecase.dart';
import 'package:market/features/auth/domain/usecases/logout_usecase.dart';
import 'package:market/features/auth/domain/usecases/register_usecase.dart';
import 'package:market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:market/features/auth/presentation/cubit/auth_state.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  Either<Failure, UserEntity>? response;
  bool isAuth = false;
  UserEntity? activeUser;

  @override
  Future<Either<Failure, UserEntity>> register(
    RegisterRequestModel request,
  ) async {
    return response!;
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginRequestModel request) async {
    return response!;
  }

  @override
  Future<Either<Failure, void>> logout() async {
    isAuth = false;
    activeUser = null;
    return const Right(null);
  }

  @override
  UserEntity? getCurrentUser() => activeUser;

  @override
  bool isLoggedIn() => isAuth;
}

void main() {
  late MockAuthRepositoryImpl mockRepo;
  late RegisterUseCase registerUseCase;
  late LoginUseCase loginUseCase;
  late LogoutUseCase logoutUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;
  late CheckAuthUseCase checkAuthUseCase;
  late AuthCubit cubit;

  setUp(() {
    mockRepo = MockAuthRepositoryImpl();
    registerUseCase = RegisterUseCase(mockRepo);
    loginUseCase = LoginUseCase(mockRepo);
    logoutUseCase = LogoutUseCase(mockRepo);
    getCurrentUserUseCase = GetCurrentUserUseCase(mockRepo);
    checkAuthUseCase = CheckAuthUseCase(mockRepo);

    cubit = AuthCubit(
      registerUseCase: registerUseCase,
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      checkAuthUseCase: checkAuthUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is AuthInitial', () {
    expect(cubit.state, equals(AuthInitial()));
  });

  test(
    'emits [AuthChecking, Unauthenticated] when checking unauthenticated status',
    () {
      mockRepo.isAuth = false;
      expectLater(
        cubit.stream,
        emitsInOrder([AuthChecking(), Unauthenticated()]),
      );
      cubit.checkAuthStatus();
    },
  );

  test('emits [AuthLoading, AuthSuccess] when registration succeeds', () async {
    const user = UserEntity(
      id: '123',
      name: 'محمود أحمد',
      email: 'mahmoud@example.com',
      phone: '01099887766',
      token: 'test_token',
    );
    mockRepo.response = const Right(user);

    expectLater(
      cubit.stream,
      emitsInOrder([AuthLoading(), const AuthSuccess(user)]),
    );

    await cubit.register(
      name: 'محمود أحمد',
      email: 'mahmoud@example.com',
      phone: '01099887766',
      password: '123456',
      areaId: 1,
    );
  });

  test('emits [AuthLoading, AuthSuccess] when login succeeds', () async {
    const user = UserEntity(
      id: '123',
      name: 'محمود أحمد',
      email: 'mahmoud@example.com',
      phone: '01099887766',
      token: 'test_token',
    );
    mockRepo.response = const Right(user);

    expectLater(
      cubit.stream,
      emitsInOrder([AuthLoading(), const AuthSuccess(user)]),
    );

    await cubit.login(identifier: 'mahmoud@example.com', password: '123456');
  });
}
