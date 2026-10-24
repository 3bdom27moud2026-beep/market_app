import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:market/core/constants/app_spacing.dart';

/// Composite widget displaying both Points Card and Referral Card as separate cards.
class LoyaltyAndReferralCard extends StatelessWidget {
  final int pointsBalance;
  final double pointsValueEgp;
  final String? referralCode;
  final VoidCallback? onPointsTap;

  const LoyaltyAndReferralCard({
    super.key,
    required this.pointsBalance,
    required this.pointsValueEgp,
    this.referralCode,
    this.onPointsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Independent Points Balance Card
        PointsBalanceCard(
          pointsBalance: pointsBalance,
          pointsValueEgp: pointsValueEgp,
          onTap: onPointsTap,
        ),

        // 2. Independent Referral Code Card
        if (referralCode != null && referralCode!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md.h),
          ReferralCodeCard(referralCode: referralCode!),
        ],
      ],
    );
  }
}

/// Standalone card for displaying user's loyalty points balance.
class PointsBalanceCard extends StatelessWidget {
  final int pointsBalance;
  final double pointsValueEgp;
  final VoidCallback? onTap;

  const PointsBalanceCard({
    super.key,
    required this.pointsBalance,
    required this.pointsValueEgp,
    this.onTap,
  });

  void _showPointsInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl.w,
          AppSpacing.lg.h,
          AppSpacing.xl.w,
          AppSpacing.xxl.h,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg.h),
              Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFBF4E4),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.stars_rounded,
                        color: Color(0xFFC89528),
                        size: 26,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رصيد نقاط المكافآت',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '$pointsBalance نقطة (تعادل ${pointsValueEgp.toStringAsFixed(1)} ج.م)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC89528),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg.h),
              Divider(color: context.colors.divider),
              SizedBox(height: AppSpacing.md.h),
              Text(
                'كيف تستفيد من نقاطك؟',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),
              _buildBulletPoint(
                context,
                'اكسب نقاطاً مع كل عملية شراء ناجحة عبر التطبيق.',
              ),
              _buildBulletPoint(
                context,
                'استبدل نقاطك بخصم نقدي مباشر عند إتمام الطلب.',
              ),
              _buildBulletPoint(
                context,
                'شارك كود الإحالة الخاص بك مع أصدقائك واكسب 50 نقطة لكل صديق يسجل في التطبيق.',
              ),
              SizedBox(height: AppSpacing.lg.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 6.r,
              height: 6.r,
              decoration: const BoxDecoration(
                color: Color(0xFFC89528),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5.sp,
                color: context.colors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLight,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap ?? () => _showPointsInfo(context),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.md.h,
            ),
            child: Row(
              children: [
                // Star Badge
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBF4E4),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.stars_rounded,
                      color: Color(0xFFC89528),
                      size: 26,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),

                // Points Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'رصيد النقاط',
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$pointsBalance',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'نقطة',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '(تعادل ${pointsValueEgp.toStringAsFixed(1)} ج.م)',
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFC89528),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Left Action / Chevron Button
                Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC89528),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Standalone card for displaying user's referral code and invite rewards.
class ReferralCodeCard extends StatelessWidget {
  final String referralCode;

  const ReferralCodeCard({super.key, required this.referralCode});

  void _copyReferralCode(BuildContext context) {
    if (referralCode.isEmpty) return;
    Clipboard.setData(ClipboardData(text: referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ كود الإحالة بنجاح 📋'),
        backgroundColor: context.colors.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareReferralLink(BuildContext context) async {
    if (referralCode.isEmpty) return;
    final shareText =
        'سجل في تطبيق شوب جايد واستخدم كود الخصم الخاص بي: $referralCode للاستمتاع بأقوى العروض ونقاط المكافآت!\nhttps://shopguide.medguide.software/ref/$referralCode';
    final uri = Uri.parse(
      'whatsapp://send?text=${Uri.encodeComponent(shareText)}',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else if (context.mounted) {
        _copyReferralCode(context);
      }
    } catch (_) {
      if (context.mounted) {
        _copyReferralCode(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      padding: EdgeInsets.all(AppSpacing.lg.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLight,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Gift Icon & Invitation Text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7EE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    color: Color(0xFF00A86B),
                    size: 20.w,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Text(
                  'ادعُ أصدقاءك واكسب 50 نقطة مكافأة عند تسجيل كل صديق!',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),

          // Referral Code Box with Copy & Share Actions
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md.w,
              vertical: AppSpacing.xs.h,
            ),
            decoration: BoxDecoration(
              color: context.colors.backgroundTertiary,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share_outlined, size: 19.r),
                      tooltip: 'مشاركة رابط الدعوة',
                      onPressed: () => _shareReferralLink(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 32.r,
                        minHeight: 32.r,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 19.r,
                        color: context.colors.textOnPrimary,
                      ),
                      tooltip: 'نسخ الكود',
                      onPressed: () => _copyReferralCode(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 32.r,
                        minHeight: 32.r,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () => _copyReferralCode(context),
                  borderRadius: BorderRadius.circular(6.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          referralCode,
                          style: TextStyle(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: context.colors.textOnPrimary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          ':كود الإحالة',
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            color: context.colors.textTertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
