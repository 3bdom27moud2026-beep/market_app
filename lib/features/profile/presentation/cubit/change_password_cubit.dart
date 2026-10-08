// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/profile/data/models/change_password_request_model.dart';
import 'package:market/features/profile/domain/usecases/change_password_usecase.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit({required ChangePasswordUseCase changePasswordUseCase})
    : _changePasswordUseCase = changePasswordUseCase,
      super(const ChangePasswordState());

  Future<bool> submitChangePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    if (isClosed) return false;
    emit(state.copyWith(status: ChangePasswordStatus.submitting));

    final request = ChangePasswordRequestModel(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

    final result = await _changePasswordUseCase(request);

    if (isClosed) return false;

    return result.fold(
      (error) {
        if (isClosed) return false;
        emit(
          state.copyWith(
            status: ChangePasswordStatus.failure,
            errorMessage: error,
          ),
        );
        return false;
      },
      (message) {
        if (isClosed) return true;
        emit(
          state.copyWith(
            status: ChangePasswordStatus.success,
            successMessage: message,
          ),
        );
        return true;
      },
    );
  }
}
