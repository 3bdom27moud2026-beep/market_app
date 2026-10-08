import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_content.dart';
import '../../../../core/constants/app_assets.dart';

/// Main splash screen that orchestrates background, content, and initialization.
///
/// Pre-caches the logo SVG asset before the first frame to avoid decoding jank
/// during the entrance animation. Uses a navigation guard to prevent
/// multiple navigation calls.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final SplashCubit _cubit;
  bool _animationsComplete = false;
  bool _hasNavigated = false;
  bool _didPrecache = false;

  @override
  void initState() {
    super.initState();
    _cubit = SplashCubit();
    _cubit.initializeApp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didPrecache) {
      _didPrecache = true;
      _precacheLogo();
    }
  }

  /// Pre-caches the logo SVG asset so vector decoding doesn't jank the animation.
  Future<void> _precacheLogo() async {
    try {
      final loader = SvgAssetLoader(AppAssets.logoSvg);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onAnimationsComplete() {
    _animationsComplete = true;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_hasNavigated) return;
    if (!mounted) return;
    final state = _cubit.state;
    if (state is SplashReady && _animationsComplete) {
      _hasNavigated = true;
      _cubit.navigateToNext(GoRouter.of(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SplashCubit>.value(
        value: _cubit,
        child: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashReady) {
              _tryNavigate();
            } else if (state is SplashError) {
              // Optionally show error dialog or retry
              debugPrint('Splash initialization error: ${state.message}');
            }
          },
          child: SplashBackground(
            child: SplashContent(onAnimationsComplete: _onAnimationsComplete),
          ),
        ),
      ),
    );
  }
}
