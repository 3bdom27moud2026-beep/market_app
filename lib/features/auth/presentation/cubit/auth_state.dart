import 'package:equatable/equatable.dart';
import 'package:market/core/error/failures.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthChecking extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class SessionExpired extends AuthState {
  final String message;

  const SessionExpired([
    this.message = 'انتهت الجلسة، يرجى إعادة تسجيل الدخول',
  ]);

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final Failure failure;

  const AuthError(this.failure);

  String get message => failure.message;

  @override
  List<Object?> get props => [failure];
}

class AuthLoggedOut extends AuthState {}
