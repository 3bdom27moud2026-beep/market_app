import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';

import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/payment_tile.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.backgroundTertiary,
      appBar: const CustomDetailAppBar(
        title: 'طريقة الدفع',
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            final selectedMethod = state.selectedPaymentMethod;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طرق الدفع المتاحة',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...state.availablePaymentMethods.map((method) {
                    final isSelected = selectedMethod?.id == method.id;
                    return PaymentTile(
                      paymentMethod: method,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<CartCubit>().selectPaymentMethod(method);
                      },
                    );
                  }),
                  SizedBox(height: 24.h),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.accentOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'تأكيد طريقة الدفع',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
