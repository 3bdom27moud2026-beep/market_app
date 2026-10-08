import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import 'package:market/features/auth/presentation/widgets/auth_bottom_sheet.dart';
import 'package:market/features/discount_card/domain/entities/discount_card_data_entity.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_cubit.dart';
import 'package:market/features/discount_card/presentation/cubit/discount_card_state.dart';
import 'package:market/features/discount_card/presentation/widgets/benefits_section.dart';
import 'package:market/features/discount_card/presentation/widgets/card_status_info_widget.dart';
import 'package:market/features/discount_card/presentation/widgets/discount_card_loading.dart'
    as loading_widget;
import 'package:market/features/discount_card/presentation/widgets/discount_card_widget.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';
import 'package:market/features/discount_card/presentation/widgets/no_card_state_widget.dart';
import 'package:market/features/discount_card/presentation/widgets/partner_discounts_section.dart';

/// {@template discount_card_screen}
/// Main screen for the Discount Card feature.
/// Consumes [DiscountCardCubit] and presents:
/// - State Unauthenticated: Clean Unauthenticated view prompting user to login to get the card.
/// - State A: Real Discount Card + QR + Statistics + Categories + Benefits when user has a card (`card != null`).
/// - State B: Polished empty state + Request Card CTA + Categories + Benefits when user has no card (`card == null`).
/// {@endtemplate}
class DiscountCardScreen extends StatefulWidget {
  const DiscountCardScreen({super.key});

  @override
  State<DiscountCardScreen> createState() => _DiscountCardScreenState();
}

class _DiscountCardScreenState extends State<DiscountCardScreen> {
  StreamSubscription<AuthEvent>? _authSubscription;

  @override
  void initState() {
    super.initState();
    context.read<DiscountCardCubit>().loadDiscountCardData();
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      context.read<DiscountCardCubit>().loadDiscountCardData();
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
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: const CustomDetailAppBar(title: 'كارت التوفير'),
      body: BlocBuilder<DiscountCardCubit, DiscountCardState>(
        builder: (context, state) {
          if (state is DiscountCardUnauthenticated) {
            return _UnauthenticatedCardView(
              onLoginTap: () async {
                final bool? result = await showAuthBottomSheet(context);
                if (result == true && context.mounted) {
                  context.read<DiscountCardCubit>().loadDiscountCardData();
                }
              },
              onRegisterTap: () async {
                final bool? result = await showAuthBottomSheet(
                  context,
                  initialTab: AuthBottomSheetTab.register,
                );
                if (result == true && context.mounted) {
                  context.read<DiscountCardCubit>().loadDiscountCardData();
                }
              },
            );
          }

          if (state is DiscountCardLoading) {
            return const loading_widget.DiscountCardLoading();
          }

          if (state is DiscountCardError) {
            return _DiscountCardErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<DiscountCardCubit>().loadDiscountCardData(),
            );
          }

          if (state is DiscountCardLoaded) {
            return _DiscountCardLoadedContent(data: state.data);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _DiscountCardLoadedContent extends StatelessWidget {
  final DiscountCardDataEntity data;

  const _DiscountCardLoadedContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final card = data.card;
    final statistics = data.statistics;
    final categories = data.categories;
    final benefits = data.benefits;

    return RefreshIndicator(
      onRefresh: () => context.read<DiscountCardCubit>().refresh(),
      color: context.colors.primaryDark,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.lg.h),

                    // STATE A (Has Card) vs STATE B (No Card)
                    if (card != null) ...[
                      // Real Shop Guide Card
                      DiscountCardWidget(card: card),
                      SizedBox(height: AppSpacing.md.h),

                      // Card Status Info (Active days remaining / Expired alert)
                      CardStatusInfoWidget(card: card),
                    ] else ...[
                      // State B: Polished empty state with Request Card action
                      const NoCardStateWidget(),
                    ],

                    SizedBox(height: AppSpacing.lg.h),
                    // Partner Merchant Discounts (3 Top Stats Cards + Search + Expandable Categories)
                    PartnerDiscountsSection(
                      statistics: statistics,
                      categories: categories,
                    ),
                    SizedBox(height: AppSpacing.xxl.h),



                    // Benefits Section
                    if (benefits.isNotEmpty) ...[
                      BenefitsSection(benefits: benefits),
                      SizedBox(height: AppSpacing.huge.h),
                    ] else
                      SizedBox(height: AppSpacing.xxl.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnauthenticatedCardView extends StatelessWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const _UnauthenticatedCardView({
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
            // Card icon with gradient circle
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
                Icons.credit_card_rounded,
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
              'قم بتسجيل الدخول للحصول على كارت الخصم\nوالاستفادة من كافة العروض والخصومات',
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
                  'تسجيل الدخول للحصول على الكارت',
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

class _DiscountCardErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DiscountCardErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64.r,
              color: context.colors.textQuaternary,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: context.colors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xxl.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primaryDark,
                foregroundColor: context.colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl.w,
                  vertical: AppSpacing.md.h,
                ),
              ),
              icon: Icon(Icons.refresh_rounded, size: 20.r),
              label: Text('إعادة المحاولة', style: AppTextStyles.buttonOrange),
            ),
          ],
        ),
      ),
    );
  }
}

