import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';
import 'package:market/features/profile/presentation/cubit/change_password_cubit.dart';
import 'package:market/features/profile/presentation/cubit/change_password_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final success = await context
        .read<ChangePasswordCubit>()
        .submitChangePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          newPasswordConfirmation: confirmPassword,
        );

    if (mounted) {
      if (success) {
        final state = context.read<ChangePasswordCubit>().state;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.successMessage ?? 'تم تغيير كلمة المرور بنجاح'),
            backgroundColor: context.colors.accentGreen,
          ),
        );
        context.pop(true);
      } else {
        final state = context.read<ChangePasswordCubit>().state;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage ?? 'فشل في تغيير كلمة المرور'),
            backgroundColor: context.colors.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const CustomDetailAppBar(
        title: 'تغيير كلمة المرور',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.r),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.md.h),

              // Current Password Field
              Text(
                'كلمة المرور الحالية',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                style: AppTextStyles.bodyMedium,
                decoration: _inputDecoration(
                  'أدخل كلمة المرور الحالية',
                  Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: context.colors.textTertiary,
                      size: 20.r,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'يرجى إدخال كلمة المرور الحالية';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.lg.h),

              // New Password Field
              Text(
                'كلمة المرور الجديدة',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                style: AppTextStyles.bodyMedium,
                decoration: _inputDecoration(
                  'أدخل كلمة المرور الجديدة',
                  Icons.lock_reset_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: context.colors.textTertiary,
                      size: 20.r,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'يرجى إدخال كلمة المرور الجديدة';
                  }
                  if (val.length < 6) {
                    return 'كلمة المرور يجب أن لا تقل عن 6 أحرف أو أرقام';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.lg.h),

              // Confirm New Password Field
              Text(
                'تأكيد كلمة المرور الجديدة',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs.h),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: AppTextStyles.bodyMedium,
                decoration: _inputDecoration(
                  'أعد إدخال كلمة المرور الجديدة',
                  Icons.lock_clock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: context.colors.textTertiary,
                      size: 20.r,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'يرجى تأكيد كلمة المرور الجديدة';
                  }
                  if (val != _newPasswordController.text) {
                    return 'كلمة المرور غير متطابقة';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppSpacing.xxl.h),

              // Submit Button
              BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                builder: (context, state) {
                  final isSubmitting =
                      state.status == ChangePasswordStatus.submitting;

                  return SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.textOnPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.md.r),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              width: 24.r,
                              height: 24.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5.r,
                                color: context.colors.textOnPrimary,
                              ),
                            )
                          : Text(
                              'تأكيد التغيير',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData prefixIcon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.searchHint,
      prefixIcon: Icon(
        prefixIcon,
        color: context.colors.textTertiary,
        size: 20.r,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: context.colors.backgroundSecondary,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        borderSide: BorderSide(color: context.colors.primary, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        borderSide: BorderSide(color: context.colors.accentRed, width: 1.w),
      ),
    );
  }
}
