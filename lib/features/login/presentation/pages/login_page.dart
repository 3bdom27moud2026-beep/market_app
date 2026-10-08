import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/di/dependency_injection.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/widgets/app_text_field.dart';
import 'package:market/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:market/features/auth/presentation/cubit/auth_state.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';

/// Production-ready Login Page.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _identifierController;
  late final TextEditingController _passwordController;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      context.read<AuthCubit>().login(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
    }
  }

  Future<void> openRegisterDialog(BuildContext context) async {
    final bool? registered = await showAuthBottomSheet(
      context,
      initialTab: AuthBottomSheetTab.register,
    );

    if (registered == true && context.mounted) {
      if (context.canPop()) {
        Navigator.of(context).pop(true);
      } else {
        context.goNamed(AppRoutes.homeNamed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => CoreDI.sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.appBar,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.colors.appBarIcon,
              size: 20.r,
            ),
            onPressed: () {
              if (context.canPop()) {
                Navigator.of(context).pop(false);
              } else {
                context.goNamed(AppRoutes.homeNamed);
              }
            },
          ),
          title: Text('تسجيل الدخول', style: AppTextStyles.appBarTitle),
          centerTitle: true,
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              AuthEventBus.instance.notifyLoggedIn(state.user);
              if (context.canPop()) {
                Navigator.of(context).pop(true);
              } else {
                context.goNamed(AppRoutes.homeNamed);
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.xxl.r),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSpacing.lg.h),
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80.r,
                      color: context.colors.primary,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    Text(
                      'مرحباً بك مجدداً!',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      'قم بتسجيل الدخول لإتمام عمليات الشراء وإدارة حسابك',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: context.colors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.xxl.h),

                    // Error Banner
                    if (state is AuthError) ...[
                      Container(
                        padding: EdgeInsets.all(AppSpacing.md.r),
                        decoration: BoxDecoration(
                          color: context.colors.discountRed.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.sm.r),
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                    ],

                    // Email/Phone Input
                    AppTextField(
                      controller: _identifierController,
                      enabled: !isLoading,
                      hintText: 'البريد الإلكتروني أو رقم الهاتف',
                      suffixIcon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.rtl,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني أو رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.lg.h),

                    // Password Input
                    AppTextField.password(
                      controller: _passwordController,
                      enabled: !isLoading,
                      hintText: 'كلمة السر',
                      isVisible: _isPasswordVisible,
                      onToggleVisibility: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xxl.h),

                    // Login Button
                    SizedBox(
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _submitLogin(context),
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
                                  strokeWidth: 2.5.r,
                                  color: context.colors.textOnPrimary,
                                ),
                              )
                            : Text(
                                'تسجيل الدخول',
                                style: AppTextStyles.buttonOrange.copyWith(
                                  fontSize: 12.sp,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl.h),

                    // Toggle to Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ليس لديك حساب؟ ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.colors.textTertiary,
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => openRegisterDialog(context),
                          child: Text(
                            'إنشاء حساب جديد',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
