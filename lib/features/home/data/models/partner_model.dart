import 'package:equatable/equatable.dart';
import '../../../../core/utils/image_url_formatter.dart';
import '../../domain/entities/partner_entity.dart';

class PartnerModel extends Equatable {
  final String id;
  final String name;
  final String logo;
  final String discount;

  /// Partner's phone number for calling.
  final String phone;

  /// Partner's WhatsApp number for messaging.
  final String whatsapp;

  const PartnerModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.discount,
    this.phone = '',
    this.whatsapp = '',
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      logo: ImageUrlFormatter.format(json['logo']?.toString()) ?? '',
      discount: json['discount']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      whatsapp: json['whatsapp']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'discount': discount,
      'phone': phone,
      'whatsapp': whatsapp,
    };
  }

  PartnerEntity toEntity() {
    return PartnerEntity(
      id: id,
      name: name,
      logo: logo,
      discount: discount,
      phone: phone,
      whatsapp: whatsapp,
    );
  }

  @override
  List<Object?> get props => [id, name, logo, discount, phone, whatsapp];
}
