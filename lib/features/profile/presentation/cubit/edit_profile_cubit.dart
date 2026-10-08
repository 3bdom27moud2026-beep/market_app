// ignore_for_file: prefer_initializing_formals
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/profile/data/models/edit_profile_request_model.dart';
import 'package:market/features/profile/domain/repository/profile_repository.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ProfileRepository _repository;

  EditProfileCubit({required ProfileRepository repository})
    : _repository = repository,
      super(const EditProfileState());

  Future<bool> submitEditProfile({
    required String name,
    required String email,
    required String phone,
    required int areaId,
  }) async {
    if (isClosed) return false;
    emit(state.copyWith(status: EditProfileStatus.submitting));

    final request = EditProfileRequestModel(
      name: name,
      email: email,
      phone: phone,
      areaId: areaId,
    );

    final result = await _repository.editProfile(request);

    if (isClosed) return false;

    return result.fold(
      (error) {
        if (isClosed) return false;
        emit(
          state.copyWith(
            status: EditProfileStatus.failure,
            errorMessage: error,
          ),
        );
        return false;
      },
      (profileData) {
        if (isClosed) return true;
        emit(
          state.copyWith(
            status: EditProfileStatus.success,
            updatedProfile: profileData,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> uploadAvatar(File file) async {
    if (isClosed) return false;
    emit(
      state.copyWith(
        isUploadingAvatar: true,
        avatarErrorMessage: null,
        avatarSuccessMessage: null,
      ),
    );

    final result = await _repository.uploadAvatar(file);

    if (isClosed) return false;

    return result.fold(
      (error) {
        if (isClosed) return false;
        emit(
          state.copyWith(isUploadingAvatar: false, avatarErrorMessage: error),
        );
        return false;
      },
      (profileData) {
        if (isClosed) return true;
        emit(
          state.copyWith(
            isUploadingAvatar: false,
            updatedProfile: profileData,
            avatarSuccessMessage: 'تم تحديث الصورة الشخصية بنجاح',
          ),
        );
        return true;
      },
    );
  }
}
