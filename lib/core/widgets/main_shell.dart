import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/widgets/custom_bottom_nav_bar.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';

/// Main shell screen that wraps all tabbed pages with a persistent
/// bottom navigation bar.
///
/// Uses GoRouter's [ShellRoute] to keep the bottom nav visible across
/// all main screens.
class MainShell extends StatefulWidget {
  final Widget child;
  final StatefulNavigationShell? navigationShell;

  const MainShell({super.key, required this.child, this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      try {
        context.read<ProfileCubit>().loadProfile();
      } catch (_) {}
      setState(() {});
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current route location to highlight the active tab
    final currentRoute = GoRouterState.of(context).uri.toString();
    final shell =
        widget.navigationShell ??
        (widget.child is StatefulNavigationShell
            ? widget.child as StatefulNavigationShell
            : null);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavBar(
        currentRoute: currentRoute,
        navigationShell: shell,
      ),
    );
  }
}
