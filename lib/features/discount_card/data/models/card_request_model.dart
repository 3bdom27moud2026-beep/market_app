import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

/// Request payload model for POST /v1/card/request supporting multipart/form-data.
class CardRequestModel extends Equatable {
  final String planType;
  final String paymentMethod;
  final String? receiptImagePath;
  final String? phone;
  final String? deliveryAddress;

  const CardRequestModel({
    required this.planType,
    required this.paymentMethod,
    this.receiptImagePath,
    this.phone,
    this.deliveryAddress,
  });

  /// Converts fields to Dio [FormData] for multipart upload.
  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'plan_type': planType,
      'payment_method': paymentMethod,
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      if (deliveryAddress != null && deliveryAddress!.trim().isNotEmpty)
        'delivery_address': deliveryAddress!.trim(),
    };

    if (receiptImagePath != null && receiptImagePath!.isNotEmpty) {
      final fileName = receiptImagePath!.split('/').last.split('\\').last;
      map['receipt_image'] = await MultipartFile.fromFile(
        receiptImagePath!,
        filename: fileName,
      );
    }

    return FormData.fromMap(map);
  }

  Map<String, dynamic> toJson() => {
    'plan_type': planType,
    'payment_method': paymentMethod,
    if (phone != null) 'phone': phone,
    if (deliveryAddress != null) 'delivery_address': deliveryAddress,
  };

  factory CardRequestModel.fromJson(Map<String, dynamic> json) {
    return CardRequestModel(
      planType: json['plan_type']?.toString() ?? 'monthly',
      paymentMethod: json['payment_method']?.toString() ?? 'cash_wallet',
      phone: json['phone']?.toString(),
      deliveryAddress: json['delivery_address']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
    planType,
    paymentMethod,
    receiptImagePath,
    phone,
    deliveryAddress,
  ];
}
