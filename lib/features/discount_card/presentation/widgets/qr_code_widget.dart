import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// {@template qr_code_widget}
/// Displays a centered QR code using the qr_flutter package.
/// {@endtemplate}
class QrCodeWidget extends StatelessWidget {
  final String data;

  const QrCodeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(AppSpacing.lg.r),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.large.r),
            boxShadow: AppShadows.card,
            border: Border.all(
              color: context.colors.border.withValues(alpha: 0.7),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 170.0.r,
                backgroundColor: context.colors.background,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: context.colors.primaryDark,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: context.colors.primaryDark,
                ),
              ),
              SizedBox(height: AppSpacing.md.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 16.r,
                    color: context.colors.textTertiary,
                  ),
                  SizedBox(width: AppSpacing.xs.w),
                  Flexible(
                    child: Text(
                      'امسح الكود لدى التاجر للحصول على الخصم الفوري',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
