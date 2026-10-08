import 'package:equatable/equatable.dart';

/// Data model representing the payload for user registration.
class RegisterRequestModel extends Equatable {
  final String name;
  final String? email;
  final String phone;
  final String password;
  final int areaId;
  final bool requestCard;
  final String? referralCode;

  const RegisterRequestModel({
    required this.name,
    this.email,
    required this.phone,
    required this.password,
    required this.areaId,
    this.requestCard = false,
    this.referralCode,
  });

  /// Converts model into JSON payload required by backend API.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
      'area_id': areaId,
      'request_card': requestCard,
    };
    if (email != null && email!.trim().isNotEmpty) {
      map['email'] = email!.trim();
    } else {
      // Safe fallback email to satisfy backends where email format is still validated
      map['email'] = '${phone.trim()}@customer.app';
    }
    if (referralCode != null && referralCode!.trim().isNotEmpty) {
      map['referral_code'] = referralCode!.trim();
    }
    return map;
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    password,
    areaId,
    requestCard,
    referralCode,
  ];
}
