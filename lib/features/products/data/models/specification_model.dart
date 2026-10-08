import 'package:equatable/equatable.dart';
import '../../domain/entities/specification_entity.dart';

/// Model for a product specification.
class SpecificationModel extends Equatable {
  final String title;
  final String value;

  const SpecificationModel({required this.title, required this.value});

  factory SpecificationModel.fromJson(Map<String, dynamic> json) {
    return SpecificationModel(
      title: json['title']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'value': value};
  }

  SpecificationEntity toEntity() {
    return SpecificationEntity(title: title, value: value);
  }

  @override
  List<Object?> get props => [title, value];
}
