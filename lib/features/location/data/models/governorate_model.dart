import 'package:equatable/equatable.dart';
import 'center_model.dart';
import '../../domain/entities/governorate_entity.dart';

class GovernorateModel extends Equatable {
  final int id;
  final String name;
  final String? slug;
  final List<CenterModel> centers;

  const GovernorateModel({
    required this.id,
    required this.name,
    this.slug,
    this.centers = const [],
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    final int govId = json['id']?.toInt() ?? 0;

    return GovernorateModel(
      id: govId,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      centers:
          ((json['cities'] ?? json['centers']) as List<dynamic>?)
              ?.map(
                (e) => CenterModel.fromJson({
                  ...(e as Map<String, dynamic>),
                  if (e['governorate_id'] == null) 'governorate_id': govId,
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
      if (slug != null) 'slug': slug,
      'centers': centers.map((e) => e.toJson()).toList(),
    };
  }

  GovernorateEntity toEntity() {
    return GovernorateEntity(id: id, name: name);
  }

  @override
  List<Object?> get props => [id, name, slug, centers];
}
