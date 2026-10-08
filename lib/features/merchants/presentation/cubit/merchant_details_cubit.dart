// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/features/merchants/domain/usecases/get_merchant_details_usecase.dart';
import 'merchant_details_state.dart';

/// Cubit for managing merchant details screen state.
class MerchantDetailsCubit extends Cubit<MerchantDetailsState> {
  final GetMerchantDetailsUseCase _getMerchantDetails;

  MerchantDetailsCubit({required GetMerchantDetailsUseCase getMerchantDetails})
    : _getMerchantDetails = getMerchantDetails,
      super(const MerchantDetailsState());

  /// Load merchant details by [id].
  Future<void> loadMerchant(String id) async {
    if (isClosed) return;
    emit(state.copyWith(status: MerchantDetailsStatus.loading));

    final result = await _getMerchantDetails(id);
    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: MerchantDetailsStatus.error,
              errorMessage: error,
            ),
          );
        }
      },
      (data) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: MerchantDetailsStatus.loaded,
              merchant: data.$1,
              products: data.$2,
            ),
          );
        }
      },
    );
  }
}
