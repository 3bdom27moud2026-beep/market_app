import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/core/utils/cart_event_bus.dart';
import 'package:market/core/widgets/custom_bottom_nav_bar.dart';
import 'package:market/features/cart/dependency_injection.dart';
import 'package:market/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:market/features/cart/presentation/pages/basket_screen.dart';
import 'package:market/features/categories/dependency_injection.dart';
import 'package:market/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:market/features/categories/presentation/screens/categories_screen.dart';
import 'package:market/features/favorites/dependency_injection.dart';
import 'package:market/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:market/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:market/features/home/dependency_injection.dart';
import 'package:market/features/home/presentation/cubit/home_cubit.dart';
import 'package:market/features/home/presentation/screens/home_screen.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:market/features/profile/presentation/pages/profile_screen.dart';
import 'package:market/features/promotions/dependency_injection.dart';
import 'package:market/features/promotions/presentation/cubit/startup_promotion_cubit.dart';

/// Main shell screen that wraps all tabbed pages with a swipeable
/// PageView and a curved animated bottom navigation bar.
class MainShell extends StatefulWidget {
  final Widget child;
  final StatefulNavigationShell? navigationShell;

  const MainShell({super.key, required this.child, this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  StreamSubscription<AuthEvent>? _authSubscription;
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.navigationShell?.currentIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);

    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      try {
        context.read<ProfileCubit>().loadProfile();
      } catch (_) {}
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newIndex = widget.navigationShell?.currentIndex;
    if (newIndex != null && newIndex != _currentIndex) {
      _currentIndex = newIndex;
      if (_pageController.hasClients &&
          _pageController.page?.round() != newIndex) {
        _pageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _authSubscription?.cancel();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);

    final shell = widget.navigationShell ??
        (widget.child is StatefulNavigationShell
            ? widget.child as StatefulNavigationShell
            : null);

    shell?.goBranch(index);

    // Contextual refresh hooks
    if (index == 2) {
      try {
        context.read<ProfileCubit>().refresh();
      } catch (_) {}
    } else if (index == 4) {
      CartEventBus.instance.notifyCartUpdated();
    }
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    if (_pageController.hasClients &&
        _pageController.page?.round() != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final shell = widget.navigationShell ??
        (widget.child is StatefulNavigationShell
            ? widget.child as StatefulNavigationShell
            : null);

    return Scaffold(
      body: Stack(
        children: [
          // Keep GoRouter's child mounted offstage so internal routing stays valid
          Offstage(
            offstage: true,
            child: widget.child,
          ),

          // Interactive Swipeable PageView for all 5 tabs in RTL
          Directionality(
            textDirection: TextDirection.rtl,
            child: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: _onPageChanged,
              children: [
                // 0: الرئيسية (Home)
                _KeepAlivePage(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<HomeCubit>(
                        create: (_) => HomeDI.createHomeCubit(),
                      ),
                      BlocProvider<StartupPromotionCubit>(
                        create: (_) =>
                            PromotionsDI.createStartupPromotionCubit(),
                      ),
                      BlocProvider<CartCubit>(
                        create: (_) => CartDI.createCartCubit()..loadCart(),
                      ),
                    ],
                    child: const HomeScreen(),
                  ),
                ),

                // 1: الفئات (Categories)
                _KeepAlivePage(
                  child: BlocProvider<CategoriesCubit>(
                    create: (_) => CategoriesDI.createCategoriesCubit(),
                    child: const CategoriesScreen(),
                  ),
                ),

                // 2: الحساب (Account / Profile)
                const _KeepAlivePage(
                  child: ProfileScreen(),
                ),

                // 3: المفضلة (Favorites)
                _KeepAlivePage(
                  child: BlocProvider<FavoritesCubit>(
                    create: (_) =>
                        FavoritesDI.createFavoritesCubit()..loadFavorites(),
                    child: const FavoritesScreen(),
                  ),
                ),

                // 4: السلة (Cart / Basket)
                _KeepAlivePage(
                  child: BlocProvider<CartCubit>(
                    create: (_) => CartDI.createCartCubit()..loadCart(),
                    child: const BasketScreen(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentRoute: currentRoute,
        navigationShell: shell,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

/// Helper widget to keep pages alive across swipes.
class _KeepAlivePage extends StatefulWidget {
  final Widget child;
  const _KeepAlivePage({required this.child});

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
