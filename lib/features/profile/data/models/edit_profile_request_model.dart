import 'package:equatable/equatable.dart';

/// Model representing payload for POST /v1/profile/edit
class EditProfileRequestModel extends Equatable {
  final String name;
  final String email;
  final String phone;
  final int areaId;

  const EditProfileRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.areaId,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'area_id': areaId};
  }

  @override
  List<Object?> get props => [name, email, phone, areaId];
}
