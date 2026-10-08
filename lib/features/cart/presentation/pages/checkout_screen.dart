import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../../domain/entities/delivery_address_entity.dart';
import '../widgets/address_card.dart';
import '../widgets/payment_tile.dart';
import '../widgets/price_summary_card.dart';
import '../widgets/checkout_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _orderNotesController = TextEditingController();

  @override
  void dispose() {
    _orderNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.backgroundTertiary,
      appBar: const CustomDetailAppBar(title: 'إتمام الطلب'),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            context.go(AppRoutes.orderSuccess, extra: state.order);
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.colors.accentRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderProcessing) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: context.colors.accentOrange),
                  SizedBox(height: 16.h),
                  Text(
                    'جاري إرسال وتأكيد الطلب...',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primaryDark,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoaded) {
            final address = state.selectedAddress;
            final payment = state.selectedPaymentMethod;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Address Section
                        if (address != null)
                          AddressCard(
                            address: address,
                            onChangeAddress: () => _showAddressBottomSheet(
                              context,
                              state.availableAddresses,
                            ),
                          )
                        else
                          _buildNoAddressCard(
                            context,
                            state.availableAddresses,
                          ),
                        SizedBox(height: 16.h),

                        // Payment Section Header & Methods
                        Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: context.colors.border.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'طريقة الدفع',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.colors.accentGreen
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      'آمنة ومضمونة',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.accentGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              if (state.availablePaymentMethods.isNotEmpty)
                                ...state.availablePaymentMethods.map(
                                  (p) => PaymentTile(
                                    paymentMethod: p,
                                    isSelected:
                                        payment?.id == p.id ||
                                        (payment == null &&
                                            p ==
                                                state
                                                    .availablePaymentMethods
                                                    .first),
                                    onTap: () {
                                      context
                                          .read<CartCubit>()
                                          .selectPaymentMethod(p);
                                    },
                                  ),
                                )
                              else if (payment != null)
                                PaymentTile(
                                  paymentMethod: payment,
                                  isSelected: true,
                                  onTap: () {},
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Loyalty Points Redemption Box
                        // Container(
                        //   padding: EdgeInsets.all(14.r),
                        //   decoration: BoxDecoration(
                        //     color: context.colors.surface,
                        //     borderRadius: BorderRadius.circular(16.r),
                        //     border: Border.all(
                        //       color: _usePoints
                        //           ? context.colors.primaryGold
                        //           : context.colors.border.withValues(
                        //               alpha: 0.8,
                        //             ),
                        //     ),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       // Row(
                        //       //   children: [
                        //       //     Checkbox(
                        //       //       value: _usePoints,
                        //       //       activeColor: context.colors.primaryGold,
                        //       //       onChanged: (val) {
                        //       //         setState(() => _usePoints = val ?? false);
                        //       //       },
                        //       //     ),
                        //       //     Expanded(
                        //       //       child: Text(
                        //       //         'استبدال نقاط المكافأة (Loyalty Points)',
                        //       //         style: TextStyle(
                        //       //           fontSize: 13.sp,
                        //       //           fontWeight: FontWeight.bold,
                        //       //           color: context.colors.textPrimary,
                        //       //         ),
                        //       //       ),
                        //       //     ),
                        //       //     Icon(
                        //       //       Icons.stars_rounded,
                        //       //       color: context.colors.primaryGold,
                        //       //       size: 22.sp,
                        //       //     ),
                        //       //   ],
                        //       // ),
                        //       if (_usePoints) ...[
                        //         SizedBox(height: 8.h),
                        //         TextField(
                        //           controller: _pointsController,
                        //           keyboardType: TextInputType.number,
                        //           decoration: InputDecoration(
                        //             labelText: 'عدد النقاط المراد استبدالها',
                        //             hintText: 'مثال: 100 نقطة',
                        //             suffixText: 'نقطة',
                        //             filled: true,
                        //             fillColor:
                        //                 context.colors.backgroundTertiary,
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(10.r),
                        //               borderSide: BorderSide.none,
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 6.h),
                        //         Text(
                        //           '* كل 10 نقاط تعادل 1 ج.م خصم مباشر من الفاتورة',
                        //           style: TextStyle(
                        //             fontSize: 12.sp,
                        //             color: context.colors.textSecondary,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ],
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 16.h),

                        // Items Summary Preview
                        Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: context.colors.border.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المنتجات المطلوبة (${state.merchants.fold<int>(0, (sum, m) => sum + m.items.length)})',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...state.merchants.map((merchant) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        merchant.name,
                                        style: TextStyle(
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.bold,
                                          color: context.colors.textPrimary,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      ...merchant.items.map(
                                        (item) => Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2.0.h,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${item.quantity}x ${item.name}',
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 10.5.sp,
                                                    color: context
                                                        .colors
                                                        .textSecondary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${(item.price * item.quantity).toStringAsFixed(0)} ج.م',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: context
                                                      .colors
                                                      .textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Optional Delivery Instructions / Notes
                        // Container(
                        //   padding: EdgeInsets.all(14.r),
                        //   decoration: BoxDecoration(
                        //     color: context.colors.surface,
                        //     borderRadius: BorderRadius.circular(16.r),
                        //     border: Border.all(
                        //       color: context.colors.border.withValues(
                        //         alpha: 0.8,
                        //       ),
                        //     ),
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.edit_note_rounded,
                        //             size: 20.r,
                        //             color: context.colors.primary,
                        //           ),
                        //           SizedBox(width: 8.w),
                        //           Text(
                        //             'ملاحظات إضافية للتوصيل (اختياري)',
                        //             style: TextStyle(
                        //               fontSize: 12.5.sp,
                        //               fontWeight: FontWeight.bold,
                        //               color: context.colors.textPrimary,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       SizedBox(height: 10.h),
                        //       TextField(
                        //         controller: _orderNotesController,
                        //         maxLines: 2,
                        //         decoration: InputDecoration(
                        //           hintText:
                        //               'مثال: برجاء الاتصال قبل الوصول بـ 10 دقائق، أو ترك الطلب لدى الأمن...',
                        //           hintStyle: TextStyle(
                        //             fontSize: 11.sp,
                        //             color: context.colors.textTertiary,
                        //           ),
                        //           filled: true,
                        //           fillColor: context.colors.backgroundTertiary,
                        //           border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(10.r),
                        //             borderSide: BorderSide.none,
                        //           ),
                        //           contentPadding: EdgeInsets.all(10.r),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 16.h),

                        // Price Summary
                        PriceSummaryCard(summary: state.summary),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),

                // Sticky Bottom Confirm Button
                CheckoutButton(
                  totalPrice: state.summary.total,
                  label: 'تأكيد الطلب',
                  onPressed: () {
                    if (state.selectedAddress == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'يرجى تحديد أو إضافة عنوان التوصيل أولاً لتأكيد طلبك',
                          ),
                          backgroundColor: context.colors.accentRed,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      if (state.availableAddresses.isNotEmpty) {
                        _showAddressBottomSheet(
                          context,
                          state.availableAddresses,
                        );
                      } else {
                        _showAddressEditSheet(context);
                      }
                      return;
                    }
                    context.read<CartCubit>().placeOrder();
                  },
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNoAddressCard(
    BuildContext context,
    List<DeliveryAddressEntity> available,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: context.colors.accentOrange.withValues(alpha: 0.6),
          width: 1.5.w,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: context.colors.accentOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off_outlined,
                  color: context.colors.accentOrange,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'عنوان التوصيل غير محدد',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'يرجى تحديد أو إضافة عنوان لاستلام هذا الطلب',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: context.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (available.isNotEmpty) {
                  _showAddressBottomSheet(context, available);
                } else {
                  _showAddressEditSheet(context);
                }
              },
              icon: Icon(Icons.add_location_alt_outlined, size: 18.r),
              label: Text(
                available.isNotEmpty
                    ? 'اختيار أو إضافة عنوان'
                    : 'إضافة عنوان توصيل جديد',
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressBottomSheet(BuildContext context, List<dynamic> addresses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'عناوين التوصيل',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      _showAddressEditSheet(context);
                    },
                    icon: Icon(
                      Icons.add_location_alt_outlined,
                      size: 18.r,
                      color: context.colors.primary,
                    ),
                    label: Text(
                      'إضافة عنوان جديد',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...addresses.map(
                        (addr) => Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          child: Stack(
                            children: [
                              AddressCard(
                                address: addr as DeliveryAddressEntity,
                                showEditButton: false,
                                onChangeAddress: () {
                                  context.read<CartCubit>().selectAddress(addr);
                                  Navigator.pop(bottomSheetContext);
                                },
                              ),
                              Positioned(
                                top: 8.h,
                                left: 8.w,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        size: 18.r,
                                        color: context.colors.accentOrange,
                                      ),
                                      tooltip: 'تعديل هذا العنوان',
                                      onPressed: () {
                                        Navigator.pop(bottomSheetContext);
                                        _showAddressEditSheet(context, addr);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 20.r,
                                        color: context.colors.accentGreen,
                                      ),
                                      tooltip: 'اختيار هذا العنوان',
                                      onPressed: () {
                                        context.read<CartCubit>().selectAddress(
                                          addr,
                                        );
                                        Navigator.pop(bottomSheetContext);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(bottomSheetContext);
                  _showAddressEditSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.add_rounded, size: 20.r),
                label: Text(
                  'إضافة عنوان توصيل جديد',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddressEditSheet(
    BuildContext context, [
    DeliveryAddressEntity? existing,
  ]) {
    final nameController = TextEditingController(
      text: existing?.recipientName ?? '',
    );
    final phoneController = TextEditingController(
      text: existing?.phoneNumber ?? '',
    );
    final govController = TextEditingController(
      text: existing?.governorate ?? 'القاهرة',
    );
    final cityController = TextEditingController(text: existing?.city ?? '');
    final detailsController = TextEditingController(
      text: existing?.addressDetails ?? '',
    );
    final titleController = TextEditingController(
      text: existing?.title ?? 'عنوان التوصيل',
    );
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.r,
            right: 16.r,
            top: 16.r,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20.r,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        existing != null
                            ? 'تعديل عنوان التوصيل'
                            : 'إضافة عنوان توصيل جديد',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildAddressField(
                    controller: titleController,
                    label: 'اسم العنوان (مثال: المنزل، العمل)',
                    icon: Icons.bookmark_border_rounded,
                  ),
                  SizedBox(height: 10.h),
                  _buildAddressField(
                    controller: nameController,
                    label: 'اسم المستلم',
                    icon: Icons.person_outline_rounded,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'يرجى إدخال اسم المستلم'
                        : null,
                  ),
                  SizedBox(height: 10.h),
                  _buildAddressField(
                    controller: phoneController,
                    label: 'رقم الهاتف',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().length < 8)
                        ? 'يرجى إدخال رقم هاتف صحيح'
                        : null,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAddressField(
                          controller: govController,
                          label: 'المحافظة',
                          icon: Icons.map_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'المحافظة مطلوبة'
                              : null,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _buildAddressField(
                          controller: cityController,
                          label: 'المدينة / المنطقة',
                          icon: Icons.location_city_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'المدينة مطلوبة'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _buildAddressField(
                    controller: detailsController,
                    label: 'تفاصيل العنوان (الشارع، رقم العمارة، الشقة)',
                    icon: Icons.home_outlined,
                    maxLines: 2,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'يرجى إدخال تفاصيل العنوان'
                        : null,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      final newAddress = DeliveryAddressEntity(
                        id:
                            existing?.id ??
                            'addr_${DateTime.now().millisecondsSinceEpoch}',
                        title: titleController.text.trim().isEmpty
                            ? 'عنوان التوصيل'
                            : titleController.text.trim(),
                        recipientName: nameController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        governorate: govController.text.trim(),
                        city: cityController.text.trim(),
                        addressDetails: detailsController.text.trim(),
                        isDefault: existing?.isDefault ?? true,
                      );
                      context.read<CartCubit>().selectAddress(newAddress);
                      Navigator.pop(sheetContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'حفظ واختيار هذا العنوان',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20.r),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
    );
  }
}
