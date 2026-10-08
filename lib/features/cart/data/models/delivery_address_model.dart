import '../../domain/entities/delivery_address_entity.dart';

class DeliveryAddressModel extends DeliveryAddressEntity {
  const DeliveryAddressModel({
    required super.id,
    required super.title,
    required super.recipientName,
    required super.phoneNumber,
    required super.governorate,
    required super.city,
    required super.addressDetails,
    super.notes,
    super.isDefault,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      recipientName: json['recipient_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      governorate: json['governorate'] as String? ?? '',
      city: json['city'] as String? ?? '',
      addressDetails: json['address_details'] as String? ?? '',
      notes: json['notes'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'recipient_name': recipientName,
      'phone_number': phoneNumber,
      'governorate': governorate,
      'city': city,
      'address_details': addressDetails,
      'notes': notes,
      'is_default': isDefault,
    };
  }
}
