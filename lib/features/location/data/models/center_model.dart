import 'package:equatable/equatable.dart';
import 'area_model.dart';
import '../../domain/entities/center_entity.dart';

class CenterModel extends Equatable {
  final int id;
  final String name;
  final int governorateId;
  final String? slug;
  final List<AreaModel> areas;

  const CenterModel({
    required this.id,
    required this.name,
    required this.governorateId,
    this.slug,
    this.areas = const [],
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    final int govId = json['governorate_id']?.toInt() ?? 0;
    final int centerId = json['id']?.toInt() ?? 0;

    return CenterModel(
      id: centerId,
      name: json['name']?.toString() ?? '',
      governorateId: govId,
      slug: json['slug']?.toString(),
      areas:
          (json['areas'] as List<dynamic>?)
              ?.map(
                (e) => AreaModel.fromJson({
                  ...(e as Map<String, dynamic>),
                  if (e['center_id'] == null) 'center_id': centerId,
                }),
              )
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'governorate_id': governorateId,
      if (slug != null) 'slug': slug,
      'areas': areas.map((e) => e.toJson()).toList(),
    };
  }

  CenterEntity toEntity() {
    return CenterEntity(id: id, name: name, governorateId: governorateId);
  }

  @override
  List<Object?> get props => [id, name, governorateId, slug, areas];
}
