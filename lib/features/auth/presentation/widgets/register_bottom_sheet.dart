import 'package:flutter/material.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';

/// Shows the unified registration / card request bottom sheet.
Future<bool?> showRegisterBottomSheet(BuildContext context) {
  return showAuthBottomSheet(
    context,
    initialTab: AuthBottomSheetTab.register,
  );
}
