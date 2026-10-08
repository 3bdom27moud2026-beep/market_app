import 'package:equatable/equatable.dart';

/// Entity representing a Governorate.
class GovernorateEntity extends Equatable {
  final int id;
  final String name;

  const GovernorateEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
