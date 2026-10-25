import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/extensions/context_extensions.dart';

/// A reusable, styled [TextFormField] that enforces the app's design system.
///
/// Supports all field variants:
/// - Plain text (name, email, phone…)
/// - Password with show/hide toggle
/// - Leading prefix icon or trailing suffix icon
/// - Optional label text or hint-only mode
///
/// Usage examples:
/// ```dart
/// // Simple field
/// AppTextField(
///   controller: _nameController,
///   hintText: 'الاسم الكامل',
///   suffixIcon: Icons.person_outline,
///   validator: (v) => v!.isEmpty ? 'مطلوب' : null,
/// )
///
/// // Password field
/// AppTextField.password(
///   controller: _passwordController,
///   isVisible: _isVisible,
///   onToggleVisibility: () => setState(() => _isVisible = !_isVisible),
/// )
/// ```
class AppTextField extends StatelessWidget {
  // ── Core ──────────────────────────────────────────────────────────────────
  final TextEditingController controller;
  final bool enabled;
  final String? hintText;
  final String? labelText;

  // ── Icons ─────────────────────────────────────────────────────────────────
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  /// A fully custom widget used as the trailing icon (e.g. visibility toggle).
  final Widget? suffixWidget;

  /// Whether this is a password field with a built-in toggle.
  /// When true, the suffixWidget builds itself from context to pick up theme.
  final bool _isPasswordToggle;
  final bool _passwordIsVisible;
  final VoidCallback? _onToggleVisibility;

  // ── Input behaviour ───────────────────────────────────────────────────────
  final bool obscureText;
  final TextInputType keyboardType;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final TextInputAction textInputAction;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final InputCounterWidgetBuilder? buildCounter;

  // ── Validation ────────────────────────────────────────────────────────────
  final String? Function(String?)? validator;

  // ── Callbacks ─────────────────────────────────────────────────────────────
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textDirection = TextDirection.rtl,
    this.textAlign = TextAlign.right,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.inputFormatters,
    this.maxLength,
    this.buildCounter,
    this.validator,
    this.onChanged,
    this.onTap,
  }) : _isPasswordToggle = false,
       _passwordIsVisible = false,
       _onToggleVisibility = null;

  /// Convenience constructor for password fields with a built-in
  /// show/hide toggle button.
  const AppTextField.password({
    super.key,
    required this.controller,
    this.enabled = true,
    this.hintText = 'كلمة المرور',
    required bool isVisible,
    required VoidCallback this._onToggleVisibility,
    this.validator,
  }) : labelText = null,
       prefixIcon = null,
       suffixIcon = Icons.lock_outline,
       suffixWidget = null,
       obscureText = !isVisible,
       keyboardType = TextInputType.visiblePassword,
       textDirection = TextDirection.rtl,
       textAlign = TextAlign.right,
       textInputAction = TextInputAction.done,
       maxLines = 1,
       inputFormatters = null,
       maxLength = null,
       buildCounter = null,
       onChanged = null,
       onTap = null,
       _isPasswordToggle = true,
       _passwordIsVisible = isVisible;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Build the effective suffix widget
    Widget? effectiveSuffix;
    if (_isPasswordToggle) {
      effectiveSuffix = GestureDetector(
        onTap: _onToggleVisibility,
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Icon(
            _passwordIsVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: colors.textQuaternary,
            size: 20.r,
          ),
        ),
      );
    } else {
      effectiveSuffix =
          suffixWidget ??
          (suffixIcon != null
              ? Icon(suffixIcon, color: colors.textQuaternary, size: 20.r)
              : null);
    }

    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textDirection: textDirection,
      textAlign: textAlign,
      textInputAction: textInputAction,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      buildCounter: buildCounter ??
          (maxLength != null
              ? (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) => null
              : null),
      onChanged: onChanged,
      onTap: onTap,
      style: AppTextStyles.bodyMedium.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.textQuaternary,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.textTertiary,
        ),
        // Leading icon
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colors.textQuaternary, size: 20.r)
            : null,
        // Trailing icon
        suffixIcon: effectiveSuffix,
        filled: true,
        fillColor: enabled
            ? colors.backgroundSecondary
            : colors.backgroundSecondary.withValues(alpha: 0.5),
        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.primary, width: 1.5.w),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.border.withValues(alpha: 0.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.discountRed, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.discountRed, width: 1.5.w),
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: colors.discountRed),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator:
          validator ??
          (_isPasswordToggle
              ? (v) {
                  if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
                  if (v.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                }
              : null),
    );
  }
}
