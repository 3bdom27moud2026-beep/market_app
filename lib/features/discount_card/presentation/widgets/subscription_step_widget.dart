import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/features/discount_card/dependency_injection.dart';
import 'package:market/features/discount_card/domain/entities/payment_method_entity.dart';
import 'package:market/features/discount_card/domain/entities/subscription_plan_entity.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';

/// Reusable subscription plans and payment methods step widget.
/// Used in the registration flow (when card request toggle is ON) and in card request sheets.
class SubscriptionStepWidget extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSkipWithoutCard;
  final Future<void> Function({
    required String planType,
    required String paymentMethod,
    required File receiptFile,
  }) onConfirm;
  final bool isSubmitting;
  final String confirmButtonText;

  const SubscriptionStepWidget({
    super.key,
    required this.onBack,
    required this.onSkipWithoutCard,
    required this.onConfirm,
    this.isSubmitting = false,
    this.confirmButtonText = 'تأكيد الاشتراك وإنشاء الحساب',
  });

  @override
  State<SubscriptionStepWidget> createState() => _SubscriptionStepWidgetState();
}

class _SubscriptionStepWidgetState extends State<SubscriptionStepWidget> {
  final ImagePicker _picker = ImagePicker();

  bool _isLoadingPlans = true;
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
    _fetchPlansAndPaymentInfo();
  }

  Future<void> _fetchPlansAndPaymentInfo() async {
    DiscountCardCubit cubit;
    try {
      cubit = DiscountCardDI.createDiscountCardCubit();
    } catch (_) {
      cubit = DiscountCardDI.createDiscountCardCubit();
    }

    final result = await cubit.getSubscriptionPlans();
    if (!mounted) return;

    result.fold(
      (error) {
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
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.md.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'إرفاق صورة إيصال التحويل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 14.h),
                ListTile(
                  leading: Icon(
                    Icons.photo_camera_outlined,
                    color: context.colors.primary,
                  ),
                  title: const Text('التقاط صورة بالكاميرا'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickReceipt(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: context.colors.primary,
                  ),
                  title: const Text('اختيار من المعرض (Gallery)'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickReceipt(ImageSource.gallery);
                  },
                ),
              ],
            ),
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

  void _handleConfirm() {
    if (_receiptFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى إرفاق صورة إيصال التحويل لإتمام طلب الكارت'),
          backgroundColor: context.colors.discountRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _showImageSourceDialog();
      return;
    }

    widget.onConfirm(
      planType: _selectedPlanType,
      paymentMethod: _selectedPaymentMethod,
      receiptFile: _receiptFile!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const navyColor = Color(0xFF0F2B48);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header Navigation Row ──────────────────────────────────────
          Row(
            children: [
              // Back Button
              IconButton(
                onPressed: widget.isSubmitting ? null : widget.onBack,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18.r,
                  color: isDark ? Colors.white : navyColor,
                ),
                tooltip: 'الرجوع لتعديل البيانات',
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  'اختر باقة الاشتراك',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : navyColor,
                    fontFamily: 'Alexandria',
                  ),
                ),
              ),
              // Skip / Cancel Card Request Button
              TextButton(
                onPressed:
                    widget.isSubmitting ? null : widget.onSkipWithoutCard,
                child: Text(
                  'بدون كارت',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textTertiary,
                    fontFamily: 'Alexandria',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ── 1. PLANS SELECTION (3 Columns) ──────────────────────────────
          if (_isLoadingPlans)
            SizedBox(
              height: 80.h,
              child: const Center(child: CircularProgressIndicator()),
            )
          else
            _buildHorizontalPlansRow(isDark),

          SizedBox(height: 16.h),

          // ── 2. PAYMENT METHODS & SUBMIT BUTTON ──────────────────────────
          _buildPaymentMethodsSection(isDark),

          SizedBox(height: 12.h),

          // ── Secondary Action: Continue without Card ─────────────────────
          Center(
            child: TextButton(
              onPressed:
                  widget.isSubmitting ? null : widget.onSkipWithoutCard,
              child: Text(
                'المتابعة بدون كارت خصم (إنشاء حساب عادي)',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          if (_supportPhone.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Center(
              child: Text(
                'للاستفسار أو المساعدة: $_supportPhone',
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: context.colors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
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
        onTap: widget.isSubmitting
            ? null
            : () {
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
            InkWell(
              onTap: widget.isSubmitting ? null : _showImageSourceDialog,
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

          // Submit / Upload Button: "إرسال صورة التحويل" / "تأكيد الاشتراك وإنشاء الحساب"
          Center(
            child: SizedBox(
              height: 44.h,
              child: ElevatedButton(
                onPressed: widget.isSubmitting ? null : _handleConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navyColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  elevation: 0,
                ),
                child: widget.isSubmitting
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
                                  : widget.confirmButtonText,
                              style: TextStyle(
                                fontSize: 12.5.sp,
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
        onTap: widget.isSubmitting
            ? null
            : () {
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
        color: context.colors.accentGreen.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: context.colors.accentGreen.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: context.colors.accentGreen.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: context.colors.accentGreen,
              size: 20.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تم إرفاق صورة إيصال التحويل بنجاح',
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.accentGreen,
                  ),
                ),
                SizedBox(height: 2.h),
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
            onPressed: widget.isSubmitting
                ? null
                : () {
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
}
