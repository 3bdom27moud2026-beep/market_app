import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../data/models/onboarding_item_model.dart';
import '../widgets/onboarding_bottom_controls.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_page_widget.dart';

/// Fullscreen onboarding walkthrough screen for first-time app users.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<OnboardingItemModel> _items = OnboardingItemModel.defaultItems;
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await CacheHelper.setHasSeenOnboarding(true);
    if (mounted) {
      context.goNamed(AppRoutes.homeNamed);
    }
  }

  void _nextPage() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF8F8F8),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F8F8),
          body: SafeArea(
          child: Column(
            children: [
              // ── Top Brand Header ─────────────────────────────────────────
              const OnboardingHeader(),

              // ── Slides Carousel (PageView) ───────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _items.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPageWidget(item: _items[index]);
                  },
                ),
              ),

              // ── Bottom Navigation Controls ───────────────────────────────
              OnboardingBottomControls(
                currentIndex: _currentIndex,
                totalCount: _items.length,
                onSkip: _completeOnboarding,
                onNext: _nextPage,
                onGetStarted: _completeOnboarding,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
