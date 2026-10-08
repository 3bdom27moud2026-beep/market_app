import 'package:equatable/equatable.dart';

/// Entity representing a Center.
class CenterEntity extends Equatable {
  final int id;
  final String name;
  final int governorateId;

  const CenterEntity({
    required this.id,
    required this.name,
    required this.governorateId,
  });

  @override
  List<Object?> get props => [id, name, governorateId];
}
