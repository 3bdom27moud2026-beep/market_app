import 'package:equatable/equatable.dart';

enum ChangePasswordStatus { initial, submitting, success, failure }

class ChangePasswordState extends Equatable {
  final ChangePasswordStatus status;
  final String? successMessage;
  final String? errorMessage;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? successMessage,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage];
}
