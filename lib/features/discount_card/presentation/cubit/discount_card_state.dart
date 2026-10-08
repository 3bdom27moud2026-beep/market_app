import 'package:equatable/equatable.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';

/// States for the DiscountCardCubit.
abstract class DiscountCardState extends Equatable {
  const DiscountCardState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class DiscountCardInitial extends DiscountCardState {
  const DiscountCardInitial();
}

/// Unauthenticated state.
class DiscountCardUnauthenticated extends DiscountCardState {
  const DiscountCardUnauthenticated();
}

/// Loading state.
class DiscountCardLoading extends DiscountCardState {
  const DiscountCardLoading();
}

/// Loaded state with data.
class DiscountCardLoaded extends DiscountCardState {
  final DiscountCardDataEntity data;

  const DiscountCardLoaded({required this.data});

  DiscountCardLoaded copyWith({DiscountCardDataEntity? data}) {
    return DiscountCardLoaded(data: data ?? this.data);
  }

  @override
  List<Object?> get props => [data];
}

/// Error state.
class DiscountCardError extends DiscountCardState {
  final String message;

  const DiscountCardError({required this.message});

  @override
  List<Object?> get props => [message];
}
