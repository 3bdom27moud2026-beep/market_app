import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/error/error_handler.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:market/features/discount_card/data/models/card_request_model.dart';
import 'package:market/features/discount_card/domain/entities/card_request_result_entity.dart';
import 'package:market/features/discount_card/domain/usecases/get_discount_card_data_usecase.dart';
import 'package:market/features/discount_card/domain/usecases/request_card_usecase.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_state.dart';

/// Cubit for managing the discount card screen state and card requests.
class DiscountCardCubit extends Cubit<DiscountCardState> {
  final GetDiscountCardDataUseCase _getDiscountCardDataUseCase;
  final RequestCardUseCase _requestCardUseCase;
  final CheckAuthUseCase? _checkAuthUseCase;
  StreamSubscription<AuthEvent>? _authSubscription;

  DiscountCardCubit(
    this._getDiscountCardDataUseCase,
    this._requestCardUseCase, [
    this._checkAuthUseCase,
  ]) : super(const DiscountCardInitial()) {
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (event.type == AuthEventType.loggedIn) {
        loadDiscountCardData();
      } else if (event.type == AuthEventType.loggedOut) {
        emit(const DiscountCardUnauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  bool _isAuthenticated() {
    try {
      final checkAuth =
          _checkAuthUseCase ??
          (CoreDI.sl.isRegistered<CheckAuthUseCase>()
              ? CoreDI.sl<CheckAuthUseCase>()
              : null);
      if (checkAuth != null) {
        return checkAuth();
      }
    } catch (_) {}
    return true;
  }

  /// Loads all discount card data from the repository.
  Future<void> loadDiscountCardData() async {
    if (!_isAuthenticated()) {
      emit(const DiscountCardUnauthenticated());
      return;
    }

    try {
      if (isClosed) return;
      emit(const DiscountCardLoading());
      final result = await _getDiscountCardDataUseCase();
      if (isClosed) return;
      result.fold(
        (error) => emit(DiscountCardError(message: error)),
        (data) => emit(DiscountCardLoaded(data: data)),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        DiscountCardError(
          message: AppErrorHandler.getMessage(
            e,
            defaultMessage: 'تعذر جلب بيانات كارت الخصم',
          ),
        ),
      );
    }
  }

  /// Submits a discount card request via POST /v1/card/request.
  ///
  /// On successful request or if a card is returned, refreshes the card status.
  Future<Either<String, CardRequestResultEntity>> submitCardRequest({
    required String deliveryAddress,
    required String phone,
    String paymentMethod = 'cash',
  }) async {
    final request = CardRequestModel(
      deliveryAddress: deliveryAddress,
      phone: phone,
      paymentMethod: paymentMethod,
    );

    final result = await _requestCardUseCase(request);

    result.fold((error) => null, (response) {
      if (response.status || response.card != null) {
        loadDiscountCardData();
      }
    });

    return result;
  }

  /// Refreshes data.
  Future<void> refresh() async {
    if (!_isAuthenticated()) {
      emit(const DiscountCardUnauthenticated());
      return;
    }
    await loadDiscountCardData();
  }
}
