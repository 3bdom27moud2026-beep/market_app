import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market/core/constants/app_assets.dart';
import 'package:market/core/constants/app_radius.dart';
import 'package:market/core/constants/app_shadows.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/utils/cache_helper.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart'
    show UserCardEntity;

/// {@template discount_card_widget}
/// Displays the user's actual Shop Guide discount card with real properties from [UserCardEntity].
/// {@endtemplate}
class DiscountCardWidget extends StatelessWidget {
  final UserCardEntity card;
  final String? userName;

  const DiscountCardWidget({super.key, required this.card, this.userName});

  @override
  Widget build(BuildContext context) {
    final bool isActive = card.isActive;
    final bool isExpired = card.status.toLowerCase() == 'expired';

    String effectiveUserName = userName ?? '';
    if (effectiveUserName.isEmpty) {
      try {
        final jsonStr = CacheHelper.userData;
        if (jsonStr != null && jsonStr.isNotEmpty) {
          final map = jsonDecode(jsonStr);
          effectiveUserName = (map['name'] ?? map['full_name'] ?? '')
              .toString();
        }
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.cardElevated,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Column(
          children: [
            // Top Section (Branding & Status & Subscriber Name)
            _CardTopSection(
              card: card,
              isActive: isActive,
              isExpired: isExpired,
              userName: effectiveUserName,
            ),
            // Bottom Section (Card details & Expiration)
            _CardBottomSection(
              card: card,
              isActive: isActive,
              isExpired: isExpired,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardTopSection extends StatelessWidget {
  final UserCardEntity card;
  final bool isActive;
  final bool isExpired;
  final String userName;

  const _CardTopSection({
    required this.card,
    required this.isActive,
    required this.isExpired,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    Color statusBgColor;
    Color statusTextColor;
    String statusText;
    IconData statusIcon;

    final bool isPending = card.status.toLowerCase() == 'pending';

    if (isActive) {
      statusBgColor = context.colors.accentGreen.withValues(alpha: 0.2);
      statusTextColor = context.colors.textOnPrimary;
      statusText = '✓ مُفعل';
      statusIcon = Icons.verified_rounded;
    } else if (isPending) {
      statusBgColor = Color(0xFFF59E0B).withValues(alpha: 0.25);
      statusTextColor = context.colors.textOnPrimary;
      statusText = '⏳ قيد المراجعة';
      statusIcon = Icons.hourglass_top_rounded;
    } else if (isExpired) {
      statusBgColor = context.colors.accentRed.withValues(alpha: 0.35);
      statusTextColor = context.colors.textOnPrimary;
      statusText = 'منتهي الصلاحية';
      statusIcon = Icons.warning_amber_rounded;
    } else {
      statusBgColor = context.colors.textTertiary.withValues(alpha: 0.3);
      statusTextColor = context.colors.textOnPrimary;
      statusText = card.status;
      statusIcon = Icons.info_outline_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.accentOrange,
            context.colors.accentOrangeLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(
                color: context.colors.textOnPrimary.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusIcon, size: 14, color: statusTextColor),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  statusText,
                  style: AppTextStyles.discountBadge.copyWith(
                    fontSize: 8.sp,
                    color: statusTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Subscriber Name in the Top Bar
          if (userName.isNotEmpty)
            Expanded(
              child: Text(
                userName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headingSmall.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textOnPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: AppSpacing.sm),
          // Shop Guide Logo
          SvgPicture.asset(AppAssets.logoSvg, height: 28, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class _CardBottomSection extends StatelessWidget {
  final UserCardEntity card;
  final bool isActive;
  final bool isExpired;

  const _CardBottomSection({
    required this.card,
    required this.isActive,
    required this.isExpired,
  });

  String _formatCardType(String type) {
    if (type.toLowerCase() == 'annual' || type.toLowerCase() == 'yearly') {
      return 'اشتراك سنوي';
    } else if (type.toLowerCase() == 'monthly') {
      return 'اشتراك شهري';
    }
    return type;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'غير محدد';
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return dateStr;
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primaryDark, context.colors.primaryLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'كارت خصومات شوب جايد',
            style: AppTextStyles.whiteHeading.copyWith(fontSize: 14.sp),
          ),
          const SizedBox(height: AppSpacing.md),

          // Card Number Container with Copy action
          Tooltip(
            message: 'نسخ رقم الكارت',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: card.cardNo));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم نسخ رقم الكارت: ${card.cardNo}'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppRadius.small),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primaryLightest.withValues(
                      alpha: 0.35,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    border: Border.all(
                      color: context.colors.textOnPrimary.withValues(
                        alpha: 0.25,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: context.colors.textOnPrimary80,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        card.cardNo,
                        style: AppTextStyles.whiteHeading.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (card.status.toLowerCase() == 'pending') ...[
            SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(AppRadius.small),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.hourglass_empty_rounded,
                    color: Color(0xFFFDE68A),
                    size: 16,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'طلبك قيد المراجعة من الإدارة وسيتم تفعيل الخصومات فور الموافقة',
                      style: TextStyle(
                        color: context.colors.textOnPrimary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),

          // Metadata Row (Card Type & Expiration Date)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Card Type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نوع الكارت',
                    style: AppTextStyles.whiteSmall.copyWith(fontSize: 7.sp),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatCardType(card.type),
                    style: AppTextStyles.whiteBody.copyWith(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Expiration Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isExpired ? 'تاريخ الانتهاء' : 'تاريخ الصلاحية',
                    style: AppTextStyles.whiteSmall.copyWith(
                      fontSize: 7.sp,
                      color: isExpired
                          ? context.colors.accentRed.withValues(alpha: 0.9)
                          : context.colors.textOnPrimary60,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    _formatDate(card.expiresAt),
                    style: AppTextStyles.whiteBody.copyWith(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: isExpired
                          ? context.colors.accentRed
                          : context.colors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
