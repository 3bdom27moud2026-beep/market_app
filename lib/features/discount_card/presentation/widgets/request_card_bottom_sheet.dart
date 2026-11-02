import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/discount_card/dependency_injection.dart';
import 'package:market/features/discount_card/domain/entities/payment_method_entity.dart';
import 'package:market/features/discount_card/domain/entities/subscription_plan_entity.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';

/// Shows a bottom sheet to request a discount card via POST /v1/card/request.
Future<void> showRequestCardBottomSheet(
  BuildContext context, {
  File? initialReceiptFile,
}) {
  DiscountCardCubit cubit;
  try {
    cubit = context.read<DiscountCardCubit>();
  } catch (_) {
    cubit = DiscountCardDI.createDiscountCardCubit();
  }
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (ctx) => BlocProvider<DiscountCardCubit>.value(
      value: cubit,
      child: _RequestCardBottomSheetContent(
        initialReceiptFile: initialReceiptFile,
      ),
    ),
  );
}

class _RequestCardBottomSheetContent extends StatefulWidget {
  final File? initialReceiptFile;

  const _RequestCardBottomSheetContent({this.initialReceiptFile});

  @override
  State<_RequestCardBottomSheetContent> createState() =>
      _RequestCardBottomSheetContentState();
}

class _RequestCardBottomSheetContentState
    extends State<_RequestCardBottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoadingPlans = true;
  bool _isSubmitting = false;

  List<SubscriptionPlanEntity> _plans = [];
  List<PaymentMethodEntity> _paymentMethods = [];
  String _instructions =
      'قم بتحويل قيمة الاشتراك عبر خدمات الكاش أو إنستاباي ثم اضغط على زر "إرسال صورة التحويل" وأرفق لقطة الشاشة لتفعيل الكارت فوراً.';
  String _supportPhone = '01023654866';

  String _selectedPlanType = 'semi_annual';
  String _selectedPaymentMethod = 'cash_wallet';
  File? _receiptFile;

  @override
  void initState() {
    super.initState();
    if (widget.initialReceiptFile != null) {
      _receiptFile = widget.initialReceiptFile;
    }
    _loadPlans();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadPlans() async {
    final result = await context.read<DiscountCardCubit>().getSubscriptionPlans();
    if (!mounted) return;

    result.fold(
      (error) {
        // Fallback default plans matching API spec
        setState(() {
          _plans = const [
            SubscriptionPlanEntity(
              id: 'monthly',
              planId: 1,
              planType: 'monthly',
              name: 'شهري',
              durationMonths: 1,
              durationLabel: 'شهرياً',
              price: 50.0,
              priceLabel: '50 جنيه / شهرياً',
              monthlyEquivalent: 50.0,
              description: 'قيمة الاشتراك 50 جنيه شهرياً',
              isActive: true,
              badge: null,
              color: '#10b981',
              icon: 'calendar',
            ),
            SubscriptionPlanEntity(
              id: 'semi_annual',
              planId: 2,
              planType: 'semi_annual',
              name: 'نصف سنوي',
              durationMonths: 6,
              durationLabel: '6 أشهر',
              price: 150.0,
              priceLabel: '150 جنيه / 6 أشهر',
              monthlyEquivalent: 25.0,
              description: 'قيمة الاشتراك 150 جنيه (6 أشهر)',
              isActive: true,
              badge: 'الأكثر طلباً ⭐',
              color: '#f59e0b',
              icon: 'star',
            ),
            SubscriptionPlanEntity(
              id: 'annual',
              planId: 3,
              planType: 'annual',
              name: 'سنوي',
              durationMonths: 12,
              durationLabel: 'سنوياً',
              price: 300.0,
              priceLabel: '300 جنيه / سنوياً',
              monthlyEquivalent: 25.0,
              description: 'قيمة الاشتراك 300 جنيه (12 شهراً)',
              isActive: true,
              badge: 'أعلى توفير 👑',
              color: '#2563eb',
              icon: 'crown',
            ),
          ];
          _paymentMethods = const [
            PaymentMethodEntity(
              id: 'cash_wallet',
              name: 'خدمات الكاش',
              number: '01023654866',
              icon: 'wallet',
              description: 'فودافون كاش، أورنج كاش، اتصالات كاش، وي باي',
              actionLabel: 'نسخ الرقم',
            ),
            PaymentMethodEntity(
              id: 'instapay',
              name: 'إنستاباي',
              number: '01023654866',
              icon: 'send',
              description: 'تحويل فوري عبر تطبيق InstaPay',
              actionLabel: 'نسخ الحساب',
            ),
          ];
          _isLoadingPlans = false;
        });
      },
      (data) {
        setState(() {
          _plans = data.activePlans.isNotEmpty ? data.activePlans : data.plans;
          _paymentMethods = data.paymentMethods;
          if (data.instructions.isNotEmpty) {
            _instructions = data.instructions;
          }
          if (data.supportPhone.isNotEmpty) {
            _supportPhone = data.supportPhone;
          }
          if (_plans.isNotEmpty &&
              !_plans.any((p) => p.planType == _selectedPlanType)) {
            _selectedPlanType = _plans.first.planType;
          }
          if (_paymentMethods.isNotEmpty &&
              !_paymentMethods.any((m) => m.id == _selectedPaymentMethod)) {
            _selectedPaymentMethod = _paymentMethods.first.id;
          }
          _isLoadingPlans = false;
        });
      },
    );
  }

  Future<void> _pickReceipt(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _receiptFile = File(picked.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر اختيار الصورة: $e'),
          backgroundColor: context.colors.accentRed,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختيار صورة إيصال التحويل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                ListTile(
                  leading: Icon(Icons.photo_library_outlined, color: context.colors.primary),
                  title: const Text('المعرض (Gallery)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickReceipt(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_outlined, color: context.colors.primary),
                  title: const Text('الكاميرا (Camera)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickReceipt(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitRequest() async {
    if (_isSubmitting) return;

    if (_receiptFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى إرفاق صورة إيصال أو لقطة شاشة التحويل أولاً'),
          backgroundColor: context.colors.accentRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final result = await context.read<DiscountCardCubit>().submitCardRequest(
      planType: _selectedPlanType,
      paymentMethod: _selectedPaymentMethod,
      receiptImagePath: _receiptFile!.path,
      phone: _phoneController.text.trim().isNotEmpty
          ? _phoneController.text.trim()
          : null,
      deliveryAddress: _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : null,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    result.fold(
      (transportError) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    transportError,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: context.colors.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      (businessResult) {
        navigator.pop();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    businessResult.message.isNotEmpty
                        ? businessResult.message
                        : 'تم تقديم طلب كارت التوفير بنجاح وهو قيد المراجعة',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: context.colors.accentGreen,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ $label: $text'),
        backgroundColor: context.colors.accentGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg.w,
            right: AppSpacing.lg.w,
            top: AppSpacing.md.h,
            bottom: AppSpacing.lg.h + bottomInset,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: context.colors.border,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Header with badge
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_card_rounded,
                          color: context.colors.primary,
                          size: 24.r,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'طلب كارت التوفير والاشتراك',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'اختر باقتك المفضلة وأرفق إيصال التحويل لتفعيل الكارت فوراً',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: context.colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // ── 1. PLANS SELECTION ──────────────────────────────────
                  Text(
                    '1. اختر باقة الاشتراك',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (_isLoadingPlans)
                    SizedBox(
                      height: 90.h,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else
                    Column(
                      children: _plans.map((plan) {
                        final isSelected = _selectedPlanType == plan.planType;
                        return _buildPlanCard(plan, isSelected);
                      }).toList(),
                    ),

                  SizedBox(height: 16.h),

                  // ── 2. PAYMENT METHOD & NUMBERS ─────────────────────────
                  Text(
                    '2. طريقة الدفع وبيانات التحويل',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Column(
                    children: _paymentMethods.map((method) {
                      final isSelected = _selectedPaymentMethod == method.id;
                      return _buildPaymentMethodCard(method, isSelected);
                    }).toList(),
                  ),

                  // Instructions Box
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7).withValues(alpha: isDark ? 0.15 : 0.6),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: const Color(0xFFD97706),
                          size: 18.r,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            _instructions,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: isDark ? Colors.white : const Color(0xFF92400E),
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── 3. RECEIPT IMAGE UPLOAD ─────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '3. إرفاق صورة إيصال التحويل *',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      if (_receiptFile != null)
                        TextButton.icon(
                          onPressed: _showImageSourceDialog,
                          icon: Icon(Icons.refresh_rounded, size: 14.r),
                          label: const Text('تغيير'),
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.primary,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  _buildReceiptPickerArea(),

                  SizedBox(height: 16.h),

                  // ── 4. OPTIONAL FIELDS (PHONE & ADDRESS) ────────────────
                  Text(
                    '4. بيانات إضافية للتواصل (اختياري)',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Phone
                  TextFormField(
                    key: const Key('card_request_phone_field'),
                    controller: _phoneController,
                    enabled: !_isSubmitting,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val != null &&
                          val.trim().isNotEmpty &&
                          val.trim().length < 10) {
                        return 'يرجى إدخال رقم هاتف صالح';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'رقم هاتف التواصل (اختياري)',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                        color: context.colors.textTertiary,
                        size: 20.r,
                      ),
                      filled: true,
                      fillColor: context.colors.backgroundTertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.sm.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Address
                  TextFormField(
                    key: const Key('card_request_address_field'),
                    controller: _addressController,
                    enabled: !_isSubmitting,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'العنوان في حال طلب كارت بلاستيكي مطبوع (اختياري)',
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: context.colors.textTertiary,
                        size: 20.r,
                      ),
                      filled: true,
                      fillColor: context.colors.backgroundTertiary,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        borderSide: BorderSide(color: context.colors.border),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.w,
                        vertical: AppSpacing.sm.h,
                      ),
                    ),
                  ),

                  SizedBox(height: 22.h),

                  // ── 5. SUBMIT CTA BUTTON ────────────────────────────────
                  SizedBox(
                    height: 52.h,
                    child: ElevatedButton(
                      key: const Key('card_request_submit_button'),
                      onPressed: _isSubmitting ? null : _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              width: 24.r,
                              height: 24.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_rounded, size: 18),
                                SizedBox(width: 8.w),
                                Text(
                                  'إرسال صورة التحويل وتفعيل الكارت',
                                  style: TextStyle(
                                    fontSize: 13.5.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (_supportPhone.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        'للاستفسار أو المساعدة: $_supportPhone',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: context.colors.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanEntity plan, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final planColor = _parseColor(plan.color) ?? context.colors.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPlanType = plan.planType;
            });
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? planColor.withValues(alpha: isDark ? 0.2 : 0.08)
                  : (isDark ? context.colors.surface : Colors.white),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected ? planColor : context.colors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio indicator
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? planColor : context.colors.textTertiary,
                      width: 2,
                    ),
                    color: isSelected ? planColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 13.r, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 12.w),

                // Plan details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          if (plan.badge != null && plan.badge!.isNotEmpty) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: planColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: planColor, width: 0.8),
                              ),
                              child: Text(
                                plan.badge!,
                                style: TextStyle(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: planColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        plan.description,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: context.colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${plan.price.toStringAsFixed(0)} ج.م',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: planColor,
                      ),
                    ),
                    Text(
                      plan.durationLabel,
                      style: TextStyle(
                        fontSize: 9.5.sp,
                        color: context.colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethodEntity method, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = context.colors.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPaymentMethod = method.id;
            });
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? primary.withValues(alpha: isDark ? 0.2 : 0.08)
                  : (isDark ? context.colors.surface : Colors.white),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: isSelected ? primary : context.colors.border,
                width: isSelected ? 1.8 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      method.id == 'instapay'
                          ? Icons.send_rounded
                          : Icons.account_balance_wallet_rounded,
                      color: isSelected ? primary : context.colors.textTertiary,
                      size: 22.r,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        method.name,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    // Copy Number Button
                    InkWell(
                      onTap: () => _copyToClipboard(method.number, method.name),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.accentOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: context.colors.accentOrange,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.copy_rounded,
                              size: 13.r,
                              color: context.colors.accentOrange,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              method.actionLabel.isNotEmpty
                                  ? method.actionLabel
                                  : 'نسخ',
                              style: TextStyle(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.accentOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      'رقم التحويل: ',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    Text(
                      method.number,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: primary,
                        letterSpacing: 1.2,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  method.description,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptPickerArea() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_receiptFile != null) {
      return Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: isDark ? context.colors.surface : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: context.colors.accentGreen, width: 1.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                _receiptFile!,
                width: 58.r,
                height: 58.r,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: context.colors.accentGreen,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'تم إرفاق صورة الإيصال بنجاح',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _receiptFile!.path.split('/').last.split('\\').last,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: context.colors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _receiptFile = null;
                });
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                color: context.colors.accentRed,
                size: 20.r,
              ),
              tooltip: 'حذف الصورة',
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _showImageSourceDialog,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        height: 94.h,
        decoration: BoxDecoration(
          color: context.colors.primary.withValues(alpha: isDark ? 0.08 : 0.04),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: context.colors.primary.withValues(alpha: 0.5),
            style: BorderStyle.solid,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 28.r,
              color: context.colors.primary,
            ),
            SizedBox(height: 6.h),
            Text(
              'اضغط هنا لرفع لقطة شاشة التحويل (Screenshot / Receipt)',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'صيغ مقبولة: JPG, PNG, WEBP',
              style: TextStyle(
                fontSize: 9.sp,
                color: context.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return null;
    try {
      final clean = hexString.replaceAll('#', '').trim();
      if (clean.length == 6) {
        return Color(int.parse('0xFF$clean'));
      } else if (clean.length == 8) {
        return Color(int.parse('0x$clean'));
      }
    } catch (_) {}
    return null;
  }
}
