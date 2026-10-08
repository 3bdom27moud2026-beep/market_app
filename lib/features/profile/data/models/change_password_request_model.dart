import 'package:equatable/equatable.dart';

/// Request model for POST /v1/profile/change-password
class ChangePasswordRequestModel extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    };
  }

  @override
  List<Object?> get props => [
    currentPassword,
    newPassword,
    newPasswordConfirmation,
  ];
}
