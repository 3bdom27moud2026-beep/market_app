import 'package:equatable/equatable.dart';

/// Represents a partner / store logo shown in the partners section.
class PartnerEntity extends Equatable {
  final String id;
  final String name;
  final String logo;
  final String discount;

  /// Partner's phone number for calling.
  final String phone;

  /// Partner's WhatsApp number for messaging.
  final String whatsapp;

  const PartnerEntity({
    required this.id,
    required this.name,
    required this.logo,
    required this.discount,
    this.phone = '',
    this.whatsapp = '',
  });

  @override
  List<Object?> get props => [id, name, logo, discount, phone, whatsapp];
}
