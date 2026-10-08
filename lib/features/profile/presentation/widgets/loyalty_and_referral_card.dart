import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:market/core/constants/app_spacing.dart';

class LoyaltyAndReferralCard extends StatelessWidget {
  final int pointsBalance;
  final double pointsValueEgp;
  final String? referralCode;

  const LoyaltyAndReferralCard({
    super.key,
    required this.pointsBalance,
    required this.pointsValueEgp,
    this.referralCode,
  });

  void _copyReferralCode(BuildContext context) {
    if (referralCode == null || referralCode!.isEmpty) return;
    Clipboard.setData(ClipboardData(text: referralCode!));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ كود الإحالة بنجاح 📋'),
        backgroundColor: context.colors.accentGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareReferralLink(BuildContext context) async {
    if (referralCode == null || referralCode!.isEmpty) return;
    final shareText =
        'سجل في تطبيق ShopGuide واستخدم كود الخصم الخاص بي: $referralCode للاستمتاع بأقوى العروض ونقاط المكافآت!\nhttps://shopguide.medguide.software/ref/$referralCode';
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
        borderRadius: BorderRadius.circular(AppSpacing.md.r),
        border: Border.all(
          color: context.colors.borderGold.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLight,
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Points Section
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: context.colors.primaryGold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.stars_rounded,
                  color: context.colors.primaryGold,
                  size: 24.r,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رصيد النقاط',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6.h),
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
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: context.colors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '(تعادل ${pointsValueEgp.toStringAsFixed(1)} ج.م)',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: context.colors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (referralCode != null && referralCode!.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
              child: Divider(color: context.colors.divider, height: 1),
            ),

            // Referral Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(7.r),
                  decoration: BoxDecoration(
                    color: context.colors.accentGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    color: context.colors.accentGreen,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: AppSpacing.md.w),
                Expanded(
                  child: Text(
                    'ادعُ أصدقاءك واكسب 50 نقطة مكافأة عند تسجيل كل صديق!',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md.h),

            // Code Display & Actions
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.sm.h,
              ),
              decoration: BoxDecoration(
                color: context.colors.backgroundTertiary,
                borderRadius: BorderRadius.circular(AppSpacing.sm.r),
                border: Border.all(color: context.colors.border),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.share_outlined, size: 18.r),
                    tooltip: 'مشاركة رابط الدعوة',
                    onPressed: () => _shareReferralLink(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.copy_rounded,
                      size: 18.r,
                      color: context.colors.primary,
                    ),
                    tooltip: 'نسخ الكود',
                    onPressed: () => _copyReferralCode(context),
                  ),
                  Spacer(),
                  Text(
                    referralCode!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: context.colors.primaryDark,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    ':كود الإحالة',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: context.colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
