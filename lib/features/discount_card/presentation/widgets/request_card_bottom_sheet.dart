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

  String _selectedPlanType = 'monthly';
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
                  if (_isLoadingPlans)
                    SizedBox(
                      height: 80.h,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else
                    _buildHorizontalPlansRow(isDark),

                  SizedBox(height: 18.h),

                  // ── 2. PAYMENT METHODS & SUBMIT BUTTON ──────────────────
                  _buildPaymentMethodsSection(isDark),

                  SizedBox(height: 14.h),

                  // ── 3. OPTIONAL CONTACT & DELIVERY FIELDS ───────────────
                  _buildOptionalFieldsSection(isDark),

                  if (_supportPhone.isNotEmpty) ...[
                    SizedBox(height: 10.h),
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

  Widget _buildHorizontalPlansRow(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < _plans.length; i++) ...[
              if (i > 0)
                Container(
                  width: 1.w,
                  color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                ),
              _buildHorizontalPlanItem(
                _plans[i],
                _selectedPlanType == _plans[i].planType,
                isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalPlanItem(
    SubscriptionPlanEntity plan,
    bool isSelected,
    bool isDark,
  ) {
    const navyColor = Color(0xFF0F2B48);
    const orangeAccent = Color(0xFFFF7A00);

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPlanType = plan.planType;
          });
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top: Radio button + Plan Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16.r,
                    height: 16.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? orangeAccent
                            : (isDark ? Colors.white38 : const Color(0xFF94A3B8)),
                        width: 2.r,
                      ),
                      color: isSelected ? orangeAccent : Colors.transparent,
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 5.r,
                              height: 5.r,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Text(
                      plan.name,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : navyColor,
                        fontFamily: 'Alexandria',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),

              // Middle: قيمة الاشتراك
              Text(
                'قيمة الإشتراك',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Alexandria',
                ),
              ),
              SizedBox(height: 7.h),

              // Bottom: Dark navy pill with price
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: navyColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${plan.price.toStringAsFixed(0)} جنيه شهريا',
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Alexandria',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection(bool isDark) {
    const navyColor = Color(0xFF0F2B48);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title: طرق الدفع
          Row(
            children: [
              Text(
                'طرق الدفع',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : navyColor,
                  fontFamily: 'Alexandria',
                ),
              ),
              const Spacer(),
              if (_instructions.isNotEmpty)
                Tooltip(
                  message: _instructions,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Padding(
                    padding: EdgeInsets.all(4.r),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 17.r,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),

          // Payment cards
          for (final method in _paymentMethods) ...[
            _buildPaymentMethodPill(method, isDark),
            SizedBox(height: 10.h),
          ],

          SizedBox(height: 6.h),

          // Receipt preview if attached
          if (_receiptFile != null) ...[
            _buildReceiptPickedPreview(isDark),
            SizedBox(height: 12.h),
          ] else ...[
            // Optional subtle hint to upload receipt
            InkWell(
              onTap: _showImageSourceDialog,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 15.r,
                      color: isDark ? Colors.white60 : const Color(0xFF64748B),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'اضغط هنا لاختيار صورة إيصال التحويل (أو من الزر أدناه)',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],

          // Submit / Upload Button: "إرسال صورة التحويل"
          Center(
            child: SizedBox(
              height: 44.h,
              child: ElevatedButton(
                key: const Key('card_request_submit_button'),
                onPressed: _isSubmitting
                    ? null
                    : () {
                        if (_receiptFile == null) {
                          _showImageSourceDialog();
                        } else {
                          _submitRequest();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: navyColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3.5.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Icon(
                                Icons.link_rounded,
                                size: 14.r,
                                color: navyColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              _receiptFile == null
                                  ? 'إرسال صورة التحويل'
                                  : 'تأكيد وإرسال التحويل',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodPill(PaymentMethodEntity method, bool isDark) {
    const navyColor = Color(0xFF0F2B48);
    final isSelected = _selectedPaymentMethod == method.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method.id;
          });
        },
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: isSelected
                  ? (isDark ? Colors.white30 : navyColor.withValues(alpha: 0.35))
                  : (isDark ? Colors.transparent : const Color(0xFFE2E8F0)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 6.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Right side (in RTL): Payment Name
              Text(
                method.name,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : navyColor,
                  fontFamily: 'Alexandria',
                ),
              ),
              const Spacer(),
              // Left side (in RTL): Send icon + Phone Number
              Directionality(
                textDirection: TextDirection.ltr,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = method.id;
                    });
                    _copyToClipboard(method.number, method.name);
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.near_me_rounded,
                          size: 15.r,
                          color: isDark ? Colors.white70 : navyColor,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          method.number,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : navyColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptPickedPreview(bool isDark) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFF10B981),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              _receiptFile!,
              width: 48.r,
              height: 48.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 15,
                    ),
                    SizedBox(width: 4.w),
                    const Text(
                      'تم إرفاق صورة الإيصال بنجاح',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  _receiptFile!.path.split('/').last.split('\\').last,
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    color: isDark ? Colors.white60 : Colors.grey,
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
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.redAccent,
              size: 18,
            ),
            tooltip: 'إلغاء',
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalFieldsSection(bool isDark) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          'بيانات إضافية للتواصل والتوصيل (اختياري)',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
        children: [
          SizedBox(height: 6.h),
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
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
