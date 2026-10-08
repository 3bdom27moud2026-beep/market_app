import 'package:equatable/equatable.dart';

/// Entity representing user's delivery shipping address.
class DeliveryAddressEntity extends Equatable {
  final String id;
  final String title;
  final String recipientName;
  final String phoneNumber;
  final String governorate;
  final String city;
  final String addressDetails;
  final String? notes;
  final bool isDefault;

  const DeliveryAddressEntity({
    required this.id,
    required this.title,
    required this.recipientName,
    required this.phoneNumber,
    required this.governorate,
    required this.city,
    required this.addressDetails,
    this.notes,
    this.isDefault = false,
  });

  String get fullAddress => '$governorate, $city - $addressDetails';

  @override
  List<Object?> get props => [
    id,
    title,
    recipientName,
    phoneNumber,
    governorate,
    city,
    addressDetails,
    notes,
    isDefault,
  ];
}
