import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Loading indicator widget for location selection.
class LocationLoading extends StatelessWidget {
  const LocationLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: CircularProgressIndicator(
          strokeWidth: 2.r,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
