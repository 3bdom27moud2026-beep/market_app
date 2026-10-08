import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import 'package:market/features/location/data/models/governorate_model.dart';
import 'package:market/features/location/data/models/center_model.dart';
import 'package:market/features/location/data/models/area_model.dart';

/// Remote data source for location-related API calls.
abstract class LocationRemoteDataSource {
  Future<List<GovernorateModel>> getGovernorates();
  Future<List<CenterModel>> getCenters(int governorateId);
  Future<List<AreaModel>> getAreas(int centerId);
  Future<void> saveUserLocation({
    required int governorateId,
    required int centerId,
    required int areaId,
  });
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiClient apiClient;
  List<GovernorateModel> _cachedGovernorates = [];

  LocationRemoteDataSourceImpl(this.apiClient);

  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is List) return responseData['data'] as List;
      if (responseData['governorates'] is List) {
        return responseData['governorates'] as List;
      }
      if (responseData['centers'] is List) {
        return responseData['centers'] as List;
      }
      if (responseData['areas'] is List) return responseData['areas'] as List;
    }
    return [];
  }

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    try {
      final response = await apiClient.get(EndPoints.location);
      final data = _extractList(response.data);
      _cachedGovernorates = data
          .map(
            (json) => GovernorateModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      return _cachedGovernorates;
    } catch (_) {
      return _cachedGovernorates;
    }
  }

  @override
  Future<List<CenterModel>> getCenters(int governorateId) async {
    try {
      final response = await apiClient.get(
        '${EndPoints.location}/$governorateId/centers',
      );
      final data = _extractList(response.data);
      final list = data
          .map((json) => CenterModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) return list;
    } catch (_) {}

    if (_cachedGovernorates.isEmpty) {
      await getGovernorates();
    }

    final gov = _cachedGovernorates.firstWhere(
      (g) => g.id == governorateId,
      orElse: () => GovernorateModel(id: governorateId, name: ''),
    );
    return gov.centers;
  }

  @override
  Future<List<AreaModel>> getAreas(int centerId) async {
    try {
      final response = await apiClient.get(
        '${EndPoints.location}/centers/$centerId/areas',
      );
      final data = _extractList(response.data);
      final list = data
          .map((json) => AreaModel.fromJson(json as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) return list;
    } catch (_) {}

    if (_cachedGovernorates.isEmpty) {
      await getGovernorates();
    }

    for (final gov in _cachedGovernorates) {
      for (final center in gov.centers) {
        if (center.id == centerId) {
          return center.areas;
        }
      }
    }
    return [];
  }

  @override
  Future<void> saveUserLocation({
    required int governorateId,
    required int centerId,
    required int areaId,
  }) async {
    try {
      await apiClient.post(
        '${EndPoints.location}/user',
        data: {
          'governorate_id': governorateId,
          'center_id': centerId,
          'area_id': areaId,
        },
      );
    } catch (_) {
      // The backend does not expose a dedicated endpoint for saving user location.
      // Selection is maintained and persisted client-side in local storage.
    }
  }
}
