import 'package:equatable/equatable.dart';
import '../../domain/entities/startup_promotion_entity.dart';

/// State for [StartupPromotionCubit].
class StartupPromotionState extends Equatable {
  final StartupPromotionEntity? promotion;
  final bool isLoading;
  final bool isVisible;
  final String error;

  const StartupPromotionState({
    this.promotion,
    this.isLoading = false,
    this.isVisible = false,
    this.error = '',
  });

  StartupPromotionState copyWith({
    StartupPromotionEntity? promotion,
    bool? isLoading,
    bool? isVisible,
    String? error,
  }) {
    return StartupPromotionState(
      promotion: promotion ?? this.promotion,
      isLoading: isLoading ?? this.isLoading,
      isVisible: isVisible ?? this.isVisible,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [promotion, isLoading, isVisible, error];
}
