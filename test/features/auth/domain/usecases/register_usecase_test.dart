import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/auth/domain/repository/auth_repository.dart';
import 'package:market/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository implements AuthRepository {
  Either<Failure, UserEntity>? result;

  @override
  Future<Either<Failure, UserEntity>> register(
    RegisterRequestModel request,
  ) async {
    return result!;
  }

  @override
  Future<Either<Failure, UserEntity>> login(LoginRequestModel request) async {
    return result!;
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return const Right(null);
  }

  @override
  UserEntity? getCurrentUser() => null;

  @override
  bool isLoggedIn() => false;
}

void main() {
  late MockAuthRepository mockRepository;
  late RegisterUseCase useCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  test(
    'should return UserEntity when repository registration is successful',
    () async {
      const user = UserEntity(
        id: '1',
        name: 'محمود أحمد',
        email: 'mahmoud@example.com',
        phone: '01099887766',
        token: 'jwt_token',
      );
      mockRepository.result = const Right(user);

      const request = RegisterRequestModel(
        name: 'محمود أحمد',
        email: 'mahmoud@example.com',
        phone: '01099887766',
        password: '123456',
        areaId: 1,
      );

      final res = await useCase(request);

      expect(res, const Right(user));
    },
  );
}
