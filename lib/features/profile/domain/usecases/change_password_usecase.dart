// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/domain/repository/profile_repository.dart';

/// Use case for changing the user's password.
class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase({required ProfileRepository repository})
    : _repository = repository;

  /// Executes the change password request.
  Future<Either<String, String>> call(
    ChangePasswordRequestModel request,
  ) async {
    return await _repository.changePassword(request);
  }
}
