// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_profile_data.dart';
import 'profile_state.dart';

/// Cubit for the Profile Screen.
///
/// Manages the loading state and profile data.
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileData _getProfileData;
  StreamSubscription<AuthEvent>? _authSubscription;

  ProfileCubit({required GetProfileData getProfileData})
    : _getProfileData = getProfileData,
      super(const ProfileState()) {
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (event.type == AuthEventType.loggedIn ||
          event.type == AuthEventType.profileUpdated) {
        loadProfile();
      } else if (event.type == AuthEventType.loggedOut) {
        emit(state.copyWith(loadingStatus: LoadingStatus.unauthenticated));
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  /// Load profile data from the repository.
  /// Emits [unauthenticated] if the user is not logged in.
  Future<void> loadProfile() async {
    final checkAuth = CoreDI.sl<CheckAuthUseCase>();
    if (!checkAuth()) {
      if (!isClosed) {
        emit(state.copyWith(loadingStatus: LoadingStatus.unauthenticated));
      }
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));

    final result = await _getProfileData();
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              loadingStatus: LoadingStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (!isClosed) {
          emit(
            state.copyWith(
              loadingStatus: LoadingStatus.loaded,
              profileData: data,
            ),
          );
        }
      },
    );
  }

  /// Logout the user and emit unauthenticated state.
  Future<void> logout() async {
    final logoutUseCase = CoreDI.sl<LogoutUseCase>();
    await logoutUseCase();
    if (!isClosed) {
      emit(const ProfileState(loadingStatus: LoadingStatus.unauthenticated));
    }
  }

  /// Refresh profile data (pull-to-refresh).
  Future<void> refresh() async {
    final checkAuth = CoreDI.sl<CheckAuthUseCase>();
    if (!checkAuth()) {
      if (!isClosed) {
        emit(state.copyWith(loadingStatus: LoadingStatus.unauthenticated));
      }
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(loadingStatus: LoadingStatus.refreshing));

    final result = await _getProfileData();
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              loadingStatus: LoadingStatus.loaded,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (!isClosed) {
          emit(
            state.copyWith(
              loadingStatus: LoadingStatus.loaded,
              profileData: data,
            ),
          );
        }
      },
    );
  }
}
