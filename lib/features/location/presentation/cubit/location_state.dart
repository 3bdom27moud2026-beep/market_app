import 'package:equatable/equatable.dart';
import '../../domain/entities/governorate_entity.dart';
import '../../domain/entities/center_entity.dart';
import '../../domain/entities/area_entity.dart';

/// State for [LocationCubit].
class LocationState extends Equatable {
  final List<GovernorateEntity> governorates;
  final List<CenterEntity> centers;
  final List<AreaEntity> areas;
  final GovernorateEntity? selectedGovernorate;
  final CenterEntity? selectedCenter;
  final AreaEntity? selectedArea;
  final bool isLoadingGovernorates;
  final bool isLoadingCenters;
  final bool isLoadingAreas;
  final bool isSaving;
  final String? error;
  final bool isSuccess;

  const LocationState({
    this.governorates = const [],
    this.centers = const [],
    this.areas = const [],
    this.selectedGovernorate,
    this.selectedCenter,
    this.selectedArea,
    this.isLoadingGovernorates = false,
    this.isLoadingCenters = false,
    this.isLoadingAreas = false,
    this.isSaving = false,
    this.error,
    this.isSuccess = false,
  });

  LocationState copyWith({
    List<GovernorateEntity>? governorates,
    List<CenterEntity>? centers,
    List<AreaEntity>? areas,
    GovernorateEntity? selectedGovernorate,
    CenterEntity? selectedCenter,
    AreaEntity? selectedArea,
    bool? isLoadingGovernorates,
    bool? isLoadingCenters,
    bool? isLoadingAreas,
    bool? isSaving,
    String? error,
    bool? isSuccess,
  }) {
    return LocationState(
      governorates: governorates ?? this.governorates,
      centers: centers ?? this.centers,
      areas: areas ?? this.areas,
      selectedGovernorate: selectedGovernorate ?? this.selectedGovernorate,
      selectedCenter: selectedCenter ?? this.selectedCenter,
      selectedArea: selectedArea ?? this.selectedArea,
      isLoadingGovernorates:
          isLoadingGovernorates ?? this.isLoadingGovernorates,
      isLoadingCenters: isLoadingCenters ?? this.isLoadingCenters,
      isLoadingAreas: isLoadingAreas ?? this.isLoadingAreas,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
    governorates,
    centers,
    areas,
    selectedGovernorate,
    selectedCenter,
    selectedArea,
    isLoadingGovernorates,
    isLoadingCenters,
    isLoadingAreas,
    isSaving,
    error,
    isSuccess,
  ];
}
