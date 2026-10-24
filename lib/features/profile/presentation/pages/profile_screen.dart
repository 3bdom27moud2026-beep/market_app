import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';
import 'package:market/features/profile/dependency_injection.dart';
import 'package:market/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:market/features/profile/presentation/cubit/profile_state.dart';
import 'package:market/features/profile/presentation/widgets/profile_header.dart';
import 'package:market/features/profile/presentation/widgets/profile_info_card.dart';
import 'package:market/features/profile/presentation/widgets/user_card_info_widget.dart';
import 'package:market/features/profile/presentation/widgets/profile_statistics.dart';
import 'package:market/features/profile/presentation/widgets/savings_card.dart';
import 'package:market/features/profile/presentation/widgets/loyalty_and_referral_card.dart';
import 'package:market/features/profile/presentation/widgets/profile_menu_list.dart';
import 'package:market/features/profile/presentation/widgets/support_section.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart';

/// Profile Screen - displays user information, statistics, and menu options.
///
/// Follows Clean Architecture with BLoC/Cubit pattern.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<ProfileCubit>();
      return const _ProfileContent();
    } catch (_) {
      return BlocProvider<ProfileCubit>(
        create: (_) => ProfileDI.createProfileCubit()..loadProfile(),
        child: const _ProfileContent(),
      );
    }
  }
}

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      context.read<ProfileCubit>().loadProfile();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().refresh();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(68.h),
        child: const ProfileHeader(),
      ),
      body: Stack(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              switch (state.loadingStatus) {
                case LoadingStatus.initial:
                case LoadingStatus.loading:
                  return const _ProfileShimmerLoading();
                case LoadingStatus.unauthenticated:
                  return _UnauthenticatedView(
                    onLoginTap: () async {
                      final bool? result = await showAuthBottomSheet(context);
                      if (result == true && context.mounted) {
                        context.read<ProfileCubit>().loadProfile();
                      }
                    },
                    onRegisterTap: () async {
                      final bool? result = await showAuthBottomSheet(
                        context,
                        initialTab: AuthBottomSheetTab.register,
                      );
                      if (result == true && context.mounted) {
                        context.read<ProfileCubit>().loadProfile();
                      }
                    },
                  );
                case LoadingStatus.error:
                  return _ErrorView(
                    message: state.errorMessage ?? 'حدث خطأ',
                    onRetry: () => context.read<ProfileCubit>().loadProfile(),
                  );
                case LoadingStatus.loaded:
                case LoadingStatus.refreshing:
                  if (state.profileData == null) {
                    return const _ProfileShimmerLoading();
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<ProfileCubit>().refresh(),
                    child: _ProfileLoaded(state: state),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileLoaded extends StatelessWidget {
  final ProfileState state;

  const _ProfileLoaded({required this.state});

  @override
  Widget build(BuildContext context) {
    final profileData = state.profileData;
    if (profileData == null) {
      return const _ProfileShimmerLoading();
    }
    final profile = profileData.profile;
    final statistics = profileData.statistics;
    final savings = profileData.savings;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(height: AppSpacing.lg.h),

          // Page Title
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Text(
                'حسابي',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),

          SizedBox(height: AppSpacing.xl.h),

          // User Info Card
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: ProfileInfoCard(
              fullName: profile.fullName,
              phoneNumber: profile.phoneNumber,
              avatarUrl: profile.avatarUrl,
              onEditTap: () async {
                final result = await context.push(
                  AppRoutes.editProfile,
                  extra: profile,
                );
                if (result == true && context.mounted) {
                  context.read<ProfileCubit>().refresh();
                }
              },
            ),
          ),

          SizedBox(height: AppSpacing.xl.h),

          // User Card Info / Request Card Banner
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 250),
            child: UserCardInfoWidget(card: profile.card),
          ),

          SizedBox(height: AppSpacing.xl.h),

          // Statistics
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 300),
            child: ProfileStatistics(
              ordersCount: statistics.ordersCount,
              subscriptionDaysRemaining: statistics.subscriptionDaysRemaining,
              favoritesCount: statistics.favoritesCount,
              hasActiveCard: profile.card?.isActive == true,
              onFavoritesTap: () {
                context.go(AppRoutes.favorites);
              },
              onOrdersTap: () async {
                await context.push(AppRoutes.orders);
                if (context.mounted) {
                  context.read<ProfileCubit>().refresh();
                }
              },
            ),
          ),

          SizedBox(height: AppSpacing.xl.h),

          // Savings Card
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 400),
            child: SavingsCard(
              totalSavings: savings.totalSavings,
              currency: savings.currency,
            ),
          ),

          SizedBox(height: AppSpacing.xl.h),

          // Loyalty Points Balance Card
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 450),
            child: PointsBalanceCard(
              pointsBalance: profile.pointsBalance,
              pointsValueEgp: profile.pointsValueEgp,
            ),
          ),

          // Referral Code Card (Distinct from Points)
          if (profile.referralCode != null &&
              profile.referralCode!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md.h),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 480),
              child: ReferralCodeCard(
                referralCode: profile.referralCode!,
              ),
            ),
          ],

          SizedBox(height: AppSpacing.xxl.h),

          // Menu List
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 500),
            child: ProfileMenuList(
              onEditProfileTap: () async {
                final result = await context.push(
                  AppRoutes.editProfile,
                  extra: profile,
                );
                if (result == true && context.mounted) {
                  context.read<ProfileCubit>().refresh();
                }
              },
              onChangePasswordTap: () {
                context.push(AppRoutes.changePassword);
              },
              onTrackOrdersTap: () async {
                await context.push(AppRoutes.orders);
                if (context.mounted) {
                  context.read<ProfileCubit>().refresh();
                }
              },
              onFavoritesTap: () {
                context.go(AppRoutes.favorites);
              },
              onPreviousOrdersTap: () async {
                await context.push(AppRoutes.orders);
                if (context.mounted) {
                  context.read<ProfileCubit>().refresh();
                }
              },
            ),
          ),

          SizedBox(height: AppSpacing.xxl.h),

          // Support Section
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 600),
            child: SupportSection(
              onSupportTap: () {
                // Open WhatsApp support
              },
              onTermsTap: () {
                // Navigate to terms and conditions
              },
              onPrivacyTap: () {
                // Navigate to privacy policy
              },
              onAboutTap: () {
                // Navigate to about app
              },
              onRateTap: () {
                // Open app store for rating
              },
              onLogoutTap: () {
                SupportSection.showLogoutDialog(context, () {
                  _performLogout(context);
                });
              },
            ),
          ),

          // Bottom padding for navigation
          SizedBox(height: AppSpacing.huge.h),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    await context.read<ProfileCubit>().logout();
    AuthEventBus.instance.notifyLoggedOut();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تسجيل الخروج بنجاح'),
          backgroundColor: context.colors.accentGreen,
        ),
      );
    }
  }
}

class _UnauthenticatedView extends StatelessWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const _UnauthenticatedView({
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock icon with gradient circle
            Container(
              width: 100.r,
              height: 100.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    context.colors.primary.withValues(alpha: 0.15),
                    context.colors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 48.r,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.xxl.h),
            Text(
              'سجّل دخولك أولاً',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md.h),
            Text(
              'قم بتسجيل الدخول لعرض ملفك الشخصي\nومتابعة طلباتك ومزاياك',
              style: TextStyle(
                fontSize: 10.sp,
                color: context.colors.textTertiary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xxxl.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: onLoginTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ليس لديك حساب؟ ',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: context.colors.textTertiary,
                  ),
                ),
                GestureDetector(
                  onTap: onRegisterTap,
                  child: Text(
                    'اضغط هنا للتسجيل',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: context.colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.r,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.textTertiary,
              ),
            ),
            SizedBox(height: AppSpacing.xl.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.textOnPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxxl.w,
                  vertical: AppSpacing.md.h,
                ),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileShimmerLoading extends StatelessWidget {
  const _ProfileShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.backgroundSecondary,
      highlightColor: context.colors.border,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header placeholder
            Container(height: 80.h, color: context.colors.surface),

            SizedBox(height: AppSpacing.xl.h),

            // Title placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Container(
                height: 32.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xl.h),

            // User card placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.xl.r),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xl.h),

            // Statistics placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Row(
                children: List.generate(
                  3,
                  (_) => Expanded(
                    child: Container(
                      height: 80.h,
                      margin: EdgeInsets.only(left: AppSpacing.sm.w),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xl.h),

            // Savings card placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Container(
                height: 140.h,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.xl.r),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xxl.h),

            // Menu items placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Column(
                children: List.generate(
                  4,
                  (_) => Container(
                    height: 60.h,
                    margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.xxl.h),

            // Support section placeholder
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
              child: Column(
                children: List.generate(
                  6,
                  (_) => Container(
                    height: 60.h,
                    margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.lg.r),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.huge.h),
          ],
        ),
      ),
    );
  }
}
