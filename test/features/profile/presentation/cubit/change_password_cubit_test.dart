import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:market/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:market/features/profile/presentation/cubit/change_password_state.dart';

import '../../domain/usecases/change_password_usecase_test.dart';

void main() {
  late MockProfileRepository mockRepo;
  late ChangePasswordUseCase useCase;
  late ChangePasswordCubit cubit;

  setUp(() {
    mockRepo = MockProfileRepository();
    useCase = ChangePasswordUseCase(repository: mockRepo);
    cubit = ChangePasswordCubit(changePasswordUseCase: useCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is ChangePasswordState with initial status', () {
    expect(cubit.state, const ChangePasswordState());
  });

  test('emits [submitting, success] when password change succeeds', () async {
    mockRepo.changePasswordResult = const Right('تم تغيير كلمة المرور بنجاح');

    expectLater(
      cubit.stream,
      emitsInOrder([
        const ChangePasswordState(status: ChangePasswordStatus.submitting),
        const ChangePasswordState(
          status: ChangePasswordStatus.success,
          successMessage: 'تم تغيير كلمة المرور بنجاح',
        ),
      ]),
    );

    final success = await cubit.submitChangePassword(
      currentPassword: '123456',
      newPassword: 'newpass123',
      newPasswordConfirmation: 'newpass123',
    );

    expect(success, true);
  });

  test('emits [submitting, failure] when password change fails', () async {
    mockRepo.changePasswordResult = const Left('كلمة المرور الحالية غير صحيحة');

    expectLater(
      cubit.stream,
      emitsInOrder([
        const ChangePasswordState(status: ChangePasswordStatus.submitting),
        const ChangePasswordState(
          status: ChangePasswordStatus.failure,
          errorMessage: 'كلمة المرور الحالية غير صحيحة',
        ),
      ]),
    );

    final success = await cubit.submitChangePassword(
      currentPassword: 'wrongpass',
      newPassword: 'newpass123',
      newPasswordConfirmation: 'newpass123',
    );

    expect(success, false);
  });
}
