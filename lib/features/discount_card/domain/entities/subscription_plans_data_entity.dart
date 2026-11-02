import 'package:equatable/equatable.dart';
import 'payment_method_entity.dart';
import 'subscription_plan_entity.dart';

/// Aggregates all subscription plans and payment methods response.
class SubscriptionPlansDataEntity extends Equatable {
  final bool status;
  final List<SubscriptionPlanEntity> plans;
  final List<SubscriptionPlanEntity> activePlans;
  final List<PaymentMethodEntity> paymentMethods;
  final String instructions;
  final String supportPhone;

  const SubscriptionPlansDataEntity({
    this.status = true,
    this.plans = const [],
    this.activePlans = const [],
    this.paymentMethods = const [],
    this.instructions = '',
    this.supportPhone = '',
  });

  @override
  List<Object?> get props => [
    status,
    plans,
    activePlans,
    paymentMethods,
    instructions,
    supportPhone,
  ];
}
