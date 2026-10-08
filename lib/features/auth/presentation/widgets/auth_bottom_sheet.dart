import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/widgets/app_text_field.dart';
import 'package:market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:market/features/auth/presentation/cubit/auth_state.dart';
import 'package:market/features/auth/presentation/widgets/register_dialog.dart';
import 'package:market/features/location/dependency_injection.dart';
import 'package:market/features/location/domain/entities/area_entity.dart';
import 'package:market/features/location/domain/entities/center_entity.dart';
import 'package:market/features/location/domain/entities/governorate_entity.dart';
import 'package:market/features/location/presentation/cubit/location_cubit.dart';
import 'package:market/features/location/presentation/cubit/location_state.dart';

/// Tabs available in the unified authentication bottom sheet.
enum AuthBottomSheetTab { login, register }

/// Shows the unified authentication bottom sheet (Login & Request Card/Register)
/// and returns [true] on successful login or registration.
Future<bool?> showAuthBottomSheet(
  BuildContext context, {
  AuthBottomSheetTab initialTab = AuthBottomSheetTab.login,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => CoreDI.sl<AuthCubit>()),
        BlocProvider<LocationCubit>(
          create: (_) => LocationDI.createLocationCubit()..loadGovernorates(),
        ),
      ],
      child: _UnifiedAuthBottomSheet(initialTab: initialTab),
    ),
  );
}

/// Backward-compatible alias for callers wanting the register / card request tab directly.
Future<bool?> showRegisterBottomSheet(BuildContext context) {
  return showAuthBottomSheet(context, initialTab: AuthBottomSheetTab.register);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Unified Authentication Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _UnifiedAuthBottomSheet extends StatefulWidget {
  final AuthBottomSheetTab initialTab;

  const _UnifiedAuthBottomSheet({this.initialTab = AuthBottomSheetTab.login});

  @override
  State<_UnifiedAuthBottomSheet> createState() =>
      _UnifiedAuthBottomSheetState();
}

class _UnifiedAuthBottomSheetState extends State<_UnifiedAuthBottomSheet> {
  late AuthBottomSheetTab _selectedTab;

  // Login form controllers & state
  final _loginFormKey = GlobalKey<FormState>();
  late final TextEditingController _loginPhoneController;
  late final TextEditingController _loginPasswordController;
  bool _loginPasswordVisible = false;

  // Register form controllers & state
  final _registerFormKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _regPhoneController;
  late final TextEditingController _referralCodeController;
  late final TextEditingController _regPasswordController;
  bool _regPasswordVisible = false;
  bool _requestCard = true; // Enabled by default for card request tab

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;

    _loginPhoneController = TextEditingController();
    _loginPasswordController = TextEditingController();

    _nameController = TextEditingController();
    _regPhoneController = TextEditingController();
    _referralCodeController = TextEditingController();
    _regPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginPhoneController.dispose();
    _loginPasswordController.dispose();

    _nameController.dispose();
    _regPhoneController.dispose();
    _referralCodeController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login(
      identifier: _loginPhoneController.text.trim(),
      password: _loginPasswordController.text,
    );
  }

  void _submitRegister(BuildContext context) {
    if (!(_registerFormKey.currentState?.validate() ?? false)) return;

    final locationState = context.read<LocationCubit>().state;
    if (locationState.selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى اختيار المنطقة / القرية'),
          backgroundColor: context.colors.discountRed,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().register(
      name: _nameController.text.trim(),
      phone: _regPhoneController.text.trim(),
      password: _regPasswordController.text,
      areaId: locationState.selectedArea!.id,
      requestCard: _requestCard,
      referralCode: _referralCodeController.text.trim().isNotEmpty
          ? _referralCodeController.text.trim()
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.9;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          AuthEventBus.instance.notifyLoggedIn(state.user);
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl.w,
                  0,
                  AppSpacing.xl.w,
                  AppSpacing.xl.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _DragHandle(),
                    SizedBox(height: AppSpacing.sm.h),

                    // Close Button on the left (matches screenshot)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _CloseButton(
                        onTap: isLoading
                            ? null
                            : () => Navigator.of(context).pop(false),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs.h),

                    // Logo Icon (Shopping bag in navy blue box)
                    const _LogoIcon(),
                    SizedBox(height: AppSpacing.md.h),

                    // Title
                    Text(
                      'ShopGuide',
                      style: AppTextStyles.headingMedium.copyWith(
                        color: context.colors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.xs.h),

                    // Subtitle depending on active tab
                    Text(
                      _selectedTab == AuthBottomSheetTab.login
                          ? 'أهلاً بعودتك! سجّل دخولك للمتابعة'
                          : 'أدخل بياناتك لإنشاء حسابك وطلب كارت الخصم',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.colors.textTertiary,
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.lg.h),

                    // Segmented Tab Switcher (تسجيل الدخول / طلب كارت)
                    _AuthSegmentedTabBar(
                      selectedTab: _selectedTab,
                      onTabChanged: (tab) {
                        if (!isLoading && _selectedTab != tab) {
                          setState(() => _selectedTab = tab);
                        }
                      },
                    ),
                    SizedBox(height: AppSpacing.lg.h),

                    // Error banner
                    if (state is AuthError) ...[
                      _ErrorBanner(message: state.message),
                      SizedBox(height: AppSpacing.md.h),
                    ],

                    // Tab View
                    if (_selectedTab == AuthBottomSheetTab.login)
                      _buildLoginForm(context, isLoading)
                    else
                      _buildRegisterForm(context, isLoading),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Login Form
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildLoginForm(BuildContext context, bool isLoading) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phone
          AppTextField(
            controller: _loginPhoneController,
            enabled: !isLoading,
            hintText: 'رقم الهاتف',
            suffixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.rtl,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'يرجى إدخال رقم الهاتف'
                : null,
          ),
          SizedBox(height: AppSpacing.md.h),

          // Password
          AppTextField.password(
            controller: _loginPasswordController,
            enabled: !isLoading,
            isVisible: _loginPasswordVisible,
            onToggleVisibility: () =>
                setState(() => _loginPasswordVisible = !_loginPasswordVisible),
          ),
          SizedBox(height: AppSpacing.sm.h),

          // Forgot Password
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: isLoading ? null : () {},
              child: Text(
                'نسيت كلمة المرور؟',
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl.h),

          // Submit
          _SubmitButton(
            isLoading: isLoading,
            label: 'تسجيل الدخول',
            onPressed: () => _submitLogin(context),
          ),
          SizedBox(height: AppSpacing.md.h),

          // Switch to Register link
          GestureDetector(
            onTap: isLoading ? null : () => RegisterDialog(),

            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.textTertiary,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'ليس لديك حساب؟ '),
                  TextSpan(
                    text: 'انشاء حساب جديد',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Register / Request Card Form
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildRegisterForm(BuildContext context, bool isLoading) {
    return Form(
      key: _registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name
          AppTextField(
            controller: _nameController,
            enabled: !isLoading,
            hintText: 'الاسم الكامل',
            suffixIcon: Icons.person_outline,
            keyboardType: TextInputType.name,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'يرجى إدخال الاسم الكامل'
                : null,
          ),
          SizedBox(height: AppSpacing.md.h),

          // Phone
          AppTextField(
            controller: _regPhoneController,
            enabled: !isLoading,
            hintText: 'رقم الهاتف',
            suffixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.rtl,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'يرجى إدخال رقم الهاتف'
                : null,
          ),
          SizedBox(height: AppSpacing.md.h),

          // Password
          AppTextField.password(
            controller: _regPasswordController,
            enabled: !isLoading,
            isVisible: _regPasswordVisible,
            onToggleVisibility: () =>
                setState(() => _regPasswordVisible = !_regPasswordVisible),
          ),
          SizedBox(height: AppSpacing.md.h),

          // Referral Code (Optional)
          AppTextField(
            controller: _referralCodeController,
            enabled: !isLoading,
            hintText: 'كود الدعوة / Referral (اختياري)',
            suffixIcon: Icons.card_giftcard_outlined,
            keyboardType: TextInputType.text,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(height: AppSpacing.xl.h),

          // Location Section
          const _SectionHeader(label: 'موقع التوصيل'),
          SizedBox(height: AppSpacing.sm.h),

          BlocBuilder<LocationCubit, LocationState>(
            builder: (context, locState) {
              return Column(
                children: [
                  // Governorate
                  _LocationDropdown<GovernorateEntity>(
                    label: 'المحافظة',
                    hint: 'اختر المحافظة',
                    items: locState.governorates,
                    selectedItem: locState.selectedGovernorate,
                    isEnabled: !isLoading,
                    isLoading: locState.isLoadingGovernorates,
                    itemLabelBuilder: (g) => g.name,
                    onChanged: (g) {
                      if (g != null) {
                        context.read<LocationCubit>().selectGovernorate(g);
                      }
                    },
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  // Center
                  _LocationDropdown<CenterEntity>(
                    label: 'المركز',
                    hint: 'اختر المركز',
                    items: locState.centers,
                    selectedItem: locState.selectedCenter,
                    isEnabled:
                        !isLoading && locState.selectedGovernorate != null,
                    isLoading: locState.isLoadingCenters,
                    itemLabelBuilder: (c) => c.name,
                    onChanged: (c) {
                      if (c != null) {
                        context.read<LocationCubit>().selectCenter(c);
                      }
                    },
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  // Area
                  _LocationDropdown<AreaEntity>(
                    label: 'المنطقة / القرية',
                    hint: 'اختر المنطقة',
                    items: locState.areas,
                    selectedItem: locState.selectedArea,
                    isEnabled: !isLoading && locState.selectedCenter != null,
                    isLoading: locState.isLoadingAreas,
                    itemLabelBuilder: (a) => a.name,
                    onChanged: (a) {
                      if (a != null) {
                        context.read<LocationCubit>().selectArea(a);
                      }
                    },
                    isRequired: true,
                  ),
                ],
              );
            },
          ),
          SizedBox(height: AppSpacing.xl.h),

          // Request Card Toggle (Defaults to true)
          _RequestCardToggle(
            value: _requestCard,
            enabled: !isLoading,
            onChanged: (v) => setState(() => _requestCard = v),
          ),
          SizedBox(height: AppSpacing.xl.h),

          // Submit
          _SubmitButton(
            isLoading: isLoading,
            label: 'طلب كارت',
            onPressed: () => _submitRegister(context),
          ),
          SizedBox(height: AppSpacing.md.h),

          // Back to Login link
          GestureDetector(
            onTap: isLoading
                ? null
                : () => setState(() => _selectedTab = AuthBottomSheetTab.login),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.textTertiary,
                  fontSize: 10.sp,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'لديك حساب بالفعل؟ '),
                  TextSpan(
                    text: 'تسجيل الدخول',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Segmented Tab Switcher (Matches attached design)
// ═══════════════════════════════════════════════════════

class _AuthSegmentedTabBar extends StatelessWidget {
  final AuthBottomSheetTab selectedTab;
  final ValueChanged<AuthBottomSheetTab> onTabChanged;

  const _AuthSegmentedTabBar({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: context.colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            // Right: تسجيل الدخول
            Expanded(
              child: _TabButton(
                title: 'تسجيل الدخول',
                isSelected: selectedTab == AuthBottomSheetTab.login,
                onTap: () => onTabChanged(AuthBottomSheetTab.login),
              ),
            ),
            SizedBox(width: 4.w),
            // Left: طلب كارت
            Expanded(
              child: _TabButton(
                title: 'طلب كارت',
                isSelected: selectedTab == AuthBottomSheetTab.register,
                onTap: () => onTabChanged(AuthBottomSheetTab.register),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected
                ? context.colors.primaryDark
                : context.colors.textTertiary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  Sub-widgets & Dropdowns
// ═══════════════════════════════════════════════════════

class _DragHandle extends StatelessWidget {
  const _DragHandle();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: context.colors.border,
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _CloseButton({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: context.colors.backgroundSecondary,
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.border),
        ),
        child: Icon(
          Icons.close,
          size: 18.r,
          color: context.colors.textTertiary,
        ),
      ),
    );
  }
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: BoxDecoration(
          color: context.colors.primaryDark,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: context.colors.primaryDark.withValues(alpha: 0.25),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Icon(
          Icons.shopping_bag_outlined,
          color: context.colors.textOnPrimary,
          size: 30.r,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final String label;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primaryDark,
          foregroundColor: context.colors.textOnPrimary,
          disabledBackgroundColor: context.colors.primaryDark.withValues(
            alpha: 0.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
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
                label,
                style: AppTextStyles.buttonOrange.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.r),
      decoration: BoxDecoration(
        color: context.colors.discountRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.sm.r),
        border: Border.all(
          color: context.colors.discountRed.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: context.colors.discountRed,
            size: 18.r,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.discountRed,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final List<T> items;
  final T? selectedItem;
  final bool isEnabled;
  final bool isLoading;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  const _LocationDropdown({
    required this.label,
    required this.hint,
    required this.items,
    required this.selectedItem,
    required this.isEnabled,
    required this.isLoading,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
            if (isRequired) ...[
              SizedBox(width: 4.w),
              Text(
                '*',
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.colors.discountRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 6.h),
        Container(
          height: 52.h,
          decoration: BoxDecoration(
            color: isEnabled
                ? context.colors.background
                : context.colors.backgroundSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.colors.border),
          ),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    width: 20.r,
                    height: 20.r,
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
                          fontSize: 12.sp,
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
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    icon: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: context.colors.textTertiary,
                        size: 22.r,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    dropdownColor: context.colors.background,
                  ),
                ),
        ),
      ],
    );
  }
}

class _RequestCardToggle extends StatelessWidget {
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _RequestCardToggle({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md.w,
        vertical: AppSpacing.sm.h,
      ),
      decoration: BoxDecoration(
        color: value
            ? context.colors.primary.withValues(alpha: 0.06)
            : context.colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: value
              ? context.colors.primary.withValues(alpha: 0.3)
              : context.colors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: value
                  ? context.colors.primary.withValues(alpha: 0.12)
                  : context.colors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_membership_outlined,
              size: 18.r,
              color: value
                  ? context.colors.primary
                  : context.colors.textTertiary,
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'طلب بطاقة خصم',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  'احصل على بطاقة خصم حصرية عند إنشاء حسابك',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: context.colors.textTertiary,
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: context.colors.primary,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16.r,
          color: context.colors.accentOrange,
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.textSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
