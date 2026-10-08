import 'package:dartz/dartz.dart';
// ignore_for_file: prefer_initializing_formals
import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

/// Use case for fetching the user's profile data.
class GetProfileData {
  final ProfileRepository _repository;

  GetProfileData({required ProfileRepository repository})
    : _repository = repository;

  /// Executes the use case to fetch profile data.
  Future<Either<String, ProfileDataEntity>> call() async {
    return await _repository.getProfileData();
  }
}
