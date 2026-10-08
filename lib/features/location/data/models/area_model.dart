import 'package:equatable/equatable.dart';
import '../../domain/entities/area_entity.dart';

class AreaModel extends Equatable {
  final int id;
  final String name;
  final int centerId;
  final String? slug;

  const AreaModel({
    required this.id,
    required this.name,
    required this.centerId,
    this.slug,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id']?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      centerId: json['center_id']?.toInt() ?? 0,
      slug: json['slug']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'center_id': centerId,
      if (slug != null) 'slug': slug,
    };
  }

  AreaEntity toEntity() {
    return AreaEntity(id: id, name: name, centerId: centerId);
  }

  @override
  List<Object?> get props => [id, name, centerId, slug];
}
