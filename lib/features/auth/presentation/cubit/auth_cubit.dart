// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/features/auth/data/models/login_request_model.dart';
import 'package:market/features/auth/data/models/register_request_model.dart';
import 'package:market/features/auth/domain/entities/user_entity.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:market/features/auth/domain/usecases/login_usecase.dart';
import 'package:market/features/auth/domain/usecases/logout_usecase.dart';
import 'package:market/features/auth/domain/usecases/register_usecase.dart';
import 'package:market/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CheckAuthUseCase _checkAuthUseCase;

  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required CheckAuthUseCase checkAuthUseCase,
  }) : _registerUseCase = registerUseCase,
       _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _checkAuthUseCase = checkAuthUseCase,
       super(AuthInitial());

  UserEntity? get currentUser => _getCurrentUserUseCase();

  /// Startup authentication check.
  void checkAuthStatus() {
    emit(AuthChecking());
    final authenticated = _checkAuthUseCase();
    if (authenticated) {
      final user = _getCurrentUserUseCase();
      if (user != null) {
        if (user.isTokenExpired) {
          emit(const SessionExpired());
        } else {
          emit(AuthSuccess(user));
        }
      } else {
        emit(Unauthenticated());
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> register({
    required String name,
    String? email,
    required String phone,
    required String password,
    required int areaId,
    bool requestCard = false,
    String? referralCode,
  }) async {
    emit(AuthLoading());

    final request = RegisterRequestModel(
      name: name.trim(),
      email: email?.trim(),
      phone: phone.trim(),
      password: password,
      areaId: areaId,
      requestCard: requestCard,
      referralCode: referralCode?.trim(),
    );

    final result = await _registerUseCase(request);

    result.fold((failure) => emit(AuthError(failure)), (user) {
      AuthEventBus.instance.notifyLoggedIn(user);
      emit(AuthSuccess(user));
    });
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    emit(AuthLoading());

    final request = LoginRequestModel(
      identifier: identifier.trim(),
      password: password,
    );

    final result = await _loginUseCase(request);

    result.fold((failure) => emit(AuthError(failure)), (user) {
      AuthEventBus.instance.notifyLoggedIn(user);
      emit(AuthSuccess(user));
    });
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await _logoutUseCase();
    result.fold((failure) => emit(AuthError(failure)), (_) {
      AuthEventBus.instance.notifyLoggedOut();
      emit(AuthLoggedOut());
    });
  }

  void handleUnauthorized() {
    _logoutUseCase();
    AuthEventBus.instance.notifyLoggedOut();
    emit(const SessionExpired());
  }
}
