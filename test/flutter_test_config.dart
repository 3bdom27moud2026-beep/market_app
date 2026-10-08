import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Global test configuration for flutter_test.
///
/// Automatically configures [ScreenUtil] before every test so widget tests
/// using `.sp`, `.w`, `.h` execute without LateInitializationError.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() {
    ScreenUtil.configure(
      data: const MediaQueryData(size: Size(375, 812)),
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  });
  await testMain();
}
