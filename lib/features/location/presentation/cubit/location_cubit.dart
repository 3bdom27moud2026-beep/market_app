import 'dart:async';
// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/utils/cache_helper.dart';
import '../../domain/entities/governorate_entity.dart';
import '../../domain/entities/center_entity.dart';
import '../../domain/entities/area_entity.dart';
import '../../domain/usecases/get_governorates_usecase.dart';
import '../../domain/usecases/get_centers_usecase.dart';
import '../../domain/usecases/get_areas_usecase.dart';
import '../../domain/usecases/save_selected_location_usecase.dart';
import 'location_state.dart';

/// Cubit for managing location selection state.
class LocationCubit extends Cubit<LocationState> {
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCentersUseCase _getCentersUseCase;
  final GetAreasUseCase _getAreasUseCase;
  final SaveSelectedLocationUseCase _saveSelectedLocationUseCase;

  LocationCubit({
    required GetGovernoratesUseCase getGovernoratesUseCase,
    required GetCentersUseCase getCentersUseCase,
    required GetAreasUseCase getAreasUseCase,
    required SaveSelectedLocationUseCase saveSelectedLocationUseCase,
  }) : _getGovernoratesUseCase = getGovernoratesUseCase,
       _getCentersUseCase = getCentersUseCase,
       _getAreasUseCase = getAreasUseCase,
       _saveSelectedLocationUseCase = saveSelectedLocationUseCase,
       super(const LocationState());

  /// Load all governorates on bottom sheet open.
  Future<void> loadGovernorates() async {
    emit(state.copyWith(isLoadingGovernorates: true, error: null));
    final result = await _getGovernoratesUseCase();
    result.fold(
      (error) =>
          emit(state.copyWith(isLoadingGovernorates: false, error: error)),
      (governorates) => emit(
        state.copyWith(
          isLoadingGovernorates: false,
          governorates: governorates,
        ),
      ),
    );
  }

  /// Select a governorate and load its centers.
  Future<void> selectGovernorate(GovernorateEntity governorate) async {
    emit(
      state.copyWith(
        selectedGovernorate: governorate,
        selectedCenter: null,
        selectedArea: null,
        centers: const [],
        areas: const [],
        isLoadingCenters: true,
        error: null,
      ),
    );

    final result = await _getCentersUseCase(governorate.id);
    result.fold(
      (error) => emit(state.copyWith(isLoadingCenters: false, error: error)),
      (centers) =>
          emit(state.copyWith(isLoadingCenters: false, centers: centers)),
    );
  }

  /// Select a center and load its areas.
  Future<void> selectCenter(CenterEntity center) async {
    emit(
      state.copyWith(
        selectedCenter: center,
        selectedArea: null,
        areas: const [],
        isLoadingAreas: true,
        error: null,
      ),
    );

    final result = await _getAreasUseCase(center.id);
    result.fold(
      (error) => emit(state.copyWith(isLoadingAreas: false, error: error)),
      (areas) => emit(state.copyWith(isLoadingAreas: false, areas: areas)),
    );
  }

  /// Select an area.
  void selectArea(AreaEntity area) {
    emit(state.copyWith(selectedArea: area, error: null));
  }

  /// Confirm and save the selected location.
  Future<void> confirmLocation() async {
    final governorate = state.selectedGovernorate;
    final center = state.selectedCenter;
    final area = state.selectedArea;

    if (governorate == null || center == null || area == null) {
      return;
    }

    emit(state.copyWith(isSaving: true, error: null));

    // Persist to local storage
    await CacheHelper.setSelectedGovernorateId(governorate.id);
    await CacheHelper.setSelectedCenterId(center.id);
    await CacheHelper.setSelectedAreaId(area.id);
    await CacheHelper.setSelectedLocationName(
      '${governorate.name}، ${center.name}',
    );

    final result = await _saveSelectedLocationUseCase(
      governorateId: governorate.id,
      centerId: center.id,
      areaId: area.id,
    );

    result.fold(
      (error) {
        // Even if remote sync fails (e.g. offline or unmapped endpoint),
        // local selection was already saved successfully.
        emit(state.copyWith(isSaving: false, isSuccess: true));
      },
      (_) {
        emit(state.copyWith(isSaving: false, isSuccess: true));
      },
    );
  }

  /// Clear error message.
  void clearError() {
    emit(state.copyWith(error: null));
  }
}
