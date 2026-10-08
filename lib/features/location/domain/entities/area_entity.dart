import 'package:equatable/equatable.dart';

/// Entity representing an Area/Village.
class AreaEntity extends Equatable {
  final int id;
  final String name;
  final int centerId;

  const AreaEntity({
    required this.id,
    required this.name,
    required this.centerId,
  });

  @override
  List<Object?> get props => [id, name, centerId];
}
