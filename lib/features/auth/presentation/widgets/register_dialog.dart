import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:market/features/auth/presentation/cubit/auth_state.dart';
import 'package:market/features/location/dependency_injection.dart';
import 'package:market/features/location/domain/entities/area_entity.dart';
import 'package:market/features/location/domain/entities/center_entity.dart';
import 'package:market/features/location/domain/entities/governorate_entity.dart';
import 'package:market/features/location/presentation/cubit/location_cubit.dart';
import 'package:market/features/location/presentation/cubit/location_state.dart';

/// Modal dialog for user authentication (Login / Register) triggered when accessing cart or restricted actions.
class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) => const RegisterDialog(),
    );
  }

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoginMode = true;

  late final TextEditingController _nameController;
  late final TextEditingController _emailOrPhoneController;
  late final TextEditingController _phoneController;
  late final TextEditingController _referralCodeController;
  late final TextEditingController _passwordController;

  bool _isPasswordVisible = false;
  bool _requestCard = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailOrPhoneController = TextEditingController();
    _phoneController = TextEditingController();
    _referralCodeController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailOrPhoneController.dispose();
    _phoneController.dispose();
    _referralCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final cubit = context.read<AuthCubit>();
      if (_isLoginMode) {
        cubit.login(
          identifier: _emailOrPhoneController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        final locationState = context.read<LocationCubit>().state;
        if (locationState.selectedArea == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('يرجى اختيار المنطقة / القرية'),
              backgroundColor: context.colors.discountRed,
            ),
          );
          return;
        }
        cubit.register(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          areaId: locationState.selectedArea!.id,
          requestCard: _requestCard,
          referralCode: _referralCodeController.text.trim().isNotEmpty
              ? _referralCodeController.text.trim()
              : null,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => CoreDI.sl<AuthCubit>()),
        BlocProvider<LocationCubit>(
          create: (_) => LocationDI.createLocationCubit()..loadGovernorates(),
        ),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.lg.r),
            ),
            backgroundColor: context.colors.background,
            elevation: 8,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl.r),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with close button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isLoginMode ? 'تسجيل الدخول' : 'إنشاء حساب جديد',
                            style: AppTextStyles.headingMedium.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: context.colors.textTertiary,
                              size: 20.r,
                            ),
                            onPressed: isLoading
                                ? null
                                : () => Navigator.of(context).pop(false),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.xs.h),
                      Text(
                        _isLoginMode
                            ? 'يرجى تسجيل الدخول للوصول إلى سلة التسوق الخاصة بك'
                            : 'يرجى إدخال بياناتك لإضافة المنتجات إلى السلة وإتمام الشراء',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.colors.textTertiary,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),

                      // Error Banner
                      if (state is AuthError) ...[
                        Container(
                          padding: EdgeInsets.all(AppSpacing.md.r),
                          decoration: BoxDecoration(
                            color: context.colors.discountRed.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.sm.r,
                            ),
                            border: Border.all(
                              color: context.colors.discountRed.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: context.colors.discountRed,
                                size: 20.r,
                              ),
                              SizedBox(width: AppSpacing.sm.w),
                              Expanded(
                                child: Text(
                                  state.message,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: context.colors.discountRed,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                      ],

                      // Name Input (Register mode only)
                      if (!_isLoginMode) ...[
                        TextFormField(
                          controller: _nameController,
                          enabled: !isLoading,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: 'الاسم الكامل',
                            hintText: 'محمود أحمد',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.md.r,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (!_isLoginMode &&
                                (value == null || value.trim().isEmpty)) {
                              return 'يرجى إدخال الاسم الكامل';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md.h),
                      ],

                      // Identifier Input (Login mode only)
                      if (_isLoginMode) ...[
                        TextFormField(
                          controller: _emailOrPhoneController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.text,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف أو البريد الإلكتروني',
                            hintText: '01xxxxxxxxx أو example@domain.com',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.md.r,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (_isLoginMode &&
                                (value == null || value.trim().isEmpty)) {
                              return 'يرجى إدخال رقم الهاتف أو البريد الإلكتروني';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md.h),
                      ],

                      // Phone Input (Register mode only - Primary Identifier)
                      if (!_isLoginMode) ...[
                        TextFormField(
                          controller: _phoneController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.phone,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف المحمول',
                            hintText: '01012345678',
                            prefixIcon: const Icon(
                              Icons.phone_android_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.md.r,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (!_isLoginMode &&
                                (value == null || value.trim().isEmpty)) {
                              return 'يرجى إدخال رقم الهاتف';
                            }
                            if (!_isLoginMode && value!.trim().length < 10) {
                              return 'يرجى إدخال رقم هاتف صحيح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSpacing.md.h),
                      ],

                      // Location Section (Register mode only)
                      if (!_isLoginMode) ...[
                        SizedBox(height: AppSpacing.sm.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14.r,
                              color: context.colors.accentOrange,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'موقع التوصيل',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: context.colors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 9.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                        BlocBuilder<LocationCubit, LocationState>(
                          builder: (context, locState) {
                            return Column(
                              children: [
                                _buildLocationDropdown<GovernorateEntity>(
                                  context,
                                  label: 'المحافظة',
                                  hint: 'اختر المحافظة',
                                  items: locState.governorates,
                                  selectedItem: locState.selectedGovernorate,
                                  isEnabled: !isLoading,
                                  isLoading: locState.isLoadingGovernorates,
                                  itemLabelBuilder: (g) => g.name,
                                  onChanged: (g) {
                                    if (g != null) {
                                      context
                                          .read<LocationCubit>()
                                          .selectGovernorate(g);
                                    }
                                  },
                                ),
                                SizedBox(height: AppSpacing.md.h),
                                _buildLocationDropdown<CenterEntity>(
                                  context,
                                  label: 'المركز',
                                  hint: 'اختر المركز',
                                  items: locState.centers,
                                  selectedItem: locState.selectedCenter,
                                  isEnabled:
                                      !isLoading &&
                                      locState.selectedGovernorate != null,
                                  isLoading: locState.isLoadingCenters,
                                  itemLabelBuilder: (c) => c.name,
                                  onChanged: (c) {
                                    if (c != null) {
                                      context
                                          .read<LocationCubit>()
                                          .selectCenter(c);
                                    }
                                  },
                                ),
                                SizedBox(height: AppSpacing.md.h),
                                _buildLocationDropdown<AreaEntity>(
                                  context,
                                  label: 'المنطقة / القرية *',
                                  hint: 'اختر المنطقة',
                                  items: locState.areas,
                                  selectedItem: locState.selectedArea,
                                  isEnabled:
                                      !isLoading &&
                                      locState.selectedCenter != null,
                                  isLoading: locState.isLoadingAreas,
                                  itemLabelBuilder: (a) => a.name,
                                  onChanged: (a) {
                                    if (a != null) {
                                      context.read<LocationCubit>().selectArea(
                                        a,
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.md.h),

                        // Request Card Toggle
                        _buildRequestCardToggle(isLoading),
                        SizedBox(height: AppSpacing.md.h),

                        // Referral Code (Register mode only - Optional)
                        TextFormField(
                          controller: _referralCodeController,
                          enabled: !isLoading,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(
                            labelText: 'كود الدعوة / Referral (اختياري)',
                            hintText: 'أدخل كود الإحالة إن وجد',
                            prefixIcon: const Icon(
                              Icons.card_giftcard_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.md.r,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm.h),
                      ],

                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        enabled: !isLoading,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'كلمة السر',
                          hintText: '******',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.md.r,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة السر';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.xl.h),

                      // Submit Button
                      SizedBox(
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _submitForm(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: context.colors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.md.r,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 24.r,
                                  height: 24.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5.w,
                                    color: context.colors.textOnPrimary,
                                  ),
                                )
                              : Text(
                                  _isLoginMode
                                      ? 'تسجيل الدخول والمتابعة'
                                      : 'إنشاء حساب جديد والمتابعة',
                                  style: AppTextStyles.buttonOrange.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md.h),

                      // Toggle Login/Register Mode Button
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isLoginMode = !_isLoginMode;
                                });
                              },
                        child: Text(
                          _isLoginMode
                              ? 'ليس لديك حساب؟ إنشاء حساب جديد'
                              : 'لديك حساب بالفعل؟ تسجيل الدخول',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationDropdown<T>(
    BuildContext context, {
    required String label,
    required String hint,
    required List<T> items,
    required T? selectedItem,
    required bool isEnabled,
    required bool isLoading,
    required String Function(T) itemLabelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 8.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.md.r),
            border: Border.all(color: context.colors.border),
            color: isEnabled
                ? context.colors.background
                : context.colors.backgroundSecondary,
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: context.colors.primary,
                    ),
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: selectedItem,
                    isExpanded: true,
                    hint: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        hint,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.colors.textTertiary,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    onChanged: isEnabled ? onChanged : null,
                    items: items.map((item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text(
                            itemLabelBuilder(item),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.colors.textSecondary,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    borderRadius: BorderRadius.circular(AppSpacing.md.r),
                    dropdownColor: context.colors.background,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildRequestCardToggle(bool isLoading) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: _requestCard
            ? context.colors.primary.withValues(alpha: 0.06)
            : context.colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        border: Border.all(
          color: _requestCard
              ? context.colors.primary.withValues(alpha: 0.3)
              : context.colors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_membership_outlined,
            size: 18.r,
            color: context.colors.textTertiary,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              'طلب بطاقة خصم',
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ),
          Switch(
            value: _requestCard,
            onChanged: isLoading
                ? null
                : (v) => setState(() => _requestCard = v),
            activeThumbColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}
