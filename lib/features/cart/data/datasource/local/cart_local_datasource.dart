import '../../models/merchant_model.dart';
import '../../models/delivery_address_model.dart';
import '../../models/payment_method_model.dart';
import '../../../domain/entities/payment_method_entity.dart';

/// Local data source managing cart items cache.
class CartLocalDataSource {
  List<MerchantModel> _cachedMerchants = [];
  final List<DeliveryAddressModel> _cachedAddresses = [];

  final List<PaymentMethodModel> _defaultPaymentMethods = const [
    PaymentMethodModel(
      id: 'pay_cod',
      title: 'الدفع عند الاستلام',
      subtitle: 'الدفع نقداً عند استلام الطلب',
      type: PaymentType.cashOnDelivery,
      icon: 'assets/icons/cod.png',
    ),
  ];

  Future<List<MerchantModel>> getCartMerchants() async {
    return _cachedMerchants;
  }

  void cacheCartMerchants(List<MerchantModel> merchants) {
    _cachedMerchants = merchants;
  }

  Future<List<DeliveryAddressModel>> getAddresses() async {
    return _cachedAddresses;
  }

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return _defaultPaymentMethods;
  }

  void clearCache() {
    _cachedMerchants = [];
  }
}
