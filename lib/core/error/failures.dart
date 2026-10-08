// ignore_for_file: use_super_parameters
import 'package:equatable/equatable.dart';

/// Base Failure class for domain layer error handling.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Returned when server returns an error response.
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Returned when a network connection error occurs.
class NetworkFailure extends Failure {
  const NetworkFailure([
    String message = 'تعذر الاتصال بالشبكة، يرجى التحقق من اتصالك بالإنترنت',
    String? code,
  ]) : super(message, code: code);
}

/// Returned when input validation fails on backend or client.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Returned when token is invalid or expired.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    String message = 'انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول',
    String? code,
  ]) : super(message, code: code);
}
