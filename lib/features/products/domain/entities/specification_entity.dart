import 'package:equatable/equatable.dart';

/// Represents a single product specification.
class SpecificationEntity extends Equatable {
  final String title;
  final String value;

  const SpecificationEntity({required this.title, required this.value});

  @override
  List<Object?> get props => [title, value];
}
