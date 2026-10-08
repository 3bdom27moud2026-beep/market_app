import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_startup_promotion_usecase.dart';
import 'startup_promotion_state.dart';

/// Cubit for managing the startup promotion popup.
class StartupPromotionCubit extends Cubit<StartupPromotionState> {
  final GetStartupPromotion _getStartupPromotion;
  Timer? _loadTimer;

  StartupPromotionCubit({required this.getStartupPromotion})
    : _getStartupPromotion = getStartupPromotion,
      super(const StartupPromotionState());

  final GetStartupPromotion getStartupPromotion;

  /// Loads the startup promotion from the API.
  Future<void> loadPromotion() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: ''));

    final result = await _getStartupPromotion();
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, error: error));
        }
      },
      (promotion) {
        if (!isClosed) {
          emit(state.copyWith(isLoading: false, promotion: promotion));
        }
      },
    );
  }

  /// Shows the promotion popup if conditions are met.
  void showPopup() {
    if (isClosed) return;
    if (state.promotion != null && !state.isVisible) {
      emit(state.copyWith(isVisible: true));
    }
  }

  /// Closes the promotion popup.
  void closePopup() {
    if (isClosed) return;
    emit(state.copyWith(isVisible: false));
  }

  @override
  Future<void> close() {
    _loadTimer?.cancel();
    return super.close();
  }
}
