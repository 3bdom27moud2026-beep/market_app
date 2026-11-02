import '../../domain/entities/subscription_plans_data_entity.dart';
import 'payment_method_model.dart';
import 'subscription_plan_model.dart';

class SubscriptionPlansResponseModel extends SubscriptionPlansDataEntity {
  const SubscriptionPlansResponseModel({
    required super.status,
    required super.plans,
    required super.activePlans,
    required super.paymentMethods,
    required super.instructions,
    required super.supportPhone,
  });

  factory SubscriptionPlansResponseModel.fromJson(Map<String, dynamic> json) {
    final rawPlans = json['plans'];
    final List<SubscriptionPlanModel> parsedPlans = [];
    if (rawPlans is List) {
      for (final p in rawPlans) {
        if (p is Map<String, dynamic>) {
          parsedPlans.add(SubscriptionPlanModel.fromJson(p));
        }
      }
    }

    final rawActive = json['active_plans'];
    final List<SubscriptionPlanModel> parsedActive = [];
    if (rawActive is List) {
      for (final p in rawActive) {
        if (p is Map<String, dynamic>) {
          parsedActive.add(SubscriptionPlanModel.fromJson(p));
        }
      }
    } else {
      parsedActive.addAll(parsedPlans.where((p) => p.isActive));
    }

    final rawMethods = json['payment_methods'];
    final List<PaymentMethodModel> parsedMethods = [];
    if (rawMethods is List) {
      for (final m in rawMethods) {
        if (m is Map<String, dynamic>) {
          parsedMethods.add(PaymentMethodModel.fromJson(m));
        }
      }
    }

    return SubscriptionPlansResponseModel(
      status: json['status'] as bool? ?? true,
      plans: parsedPlans,
      activePlans: parsedActive,
      paymentMethods: parsedMethods,
      instructions: json['instructions']?.toString() ??
          'قم بتحويل قيمة الاشتراك عبر خدمات الكاش أو إنستاباي ثم اضغط على زر "إرسال صورة التحويل" وأرفق لقطة الشاشة لتفعيل الكارت فوراً.',
      supportPhone: json['support_phone']?.toString() ?? '01023654866',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'plans': plans.map((p) => (p as SubscriptionPlanModel).toJson()).toList(),
      'active_plans': activePlans
          .map((p) => (p as SubscriptionPlanModel).toJson())
          .toList(),
      'payment_methods': paymentMethods
          .map((m) => (m as PaymentMethodModel).toJson())
          .toList(),
      'instructions': instructions,
      'support_phone': supportPhone,
    };
  }
}
