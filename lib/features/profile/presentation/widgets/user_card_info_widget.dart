import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/features/discount_card/presentation/widgets/request_card_bottom_sheet.dart';
import 'package:market/features/profile/domain/entities/profile_entity.dart';

/// Card widget to display the user's discount card details or a prompt to activate/request a card.
class UserCardInfoWidget extends StatelessWidget {
  final UserCardEntity? card;
  final VoidCallback? onRequestCardTap;

  const UserCardInfoWidget({super.key, this.card, this.onRequestCardTap});

  @override
  Widget build(BuildContext context) {
    if (card == null || card!.cardNo.isEmpty || !card!.isActive) {
      return _buildNoCardView(context);
    }

    return _buildActiveCardView(context, card!);
  }

  /// Banner displayed when the user does NOT have an active discount card (Image 1 design).
  Widget _buildNoCardView(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: InkWell(
        onTap: () {
          if (card != null && card!.isPending) {
            context.push(AppRoutes.cardDetails, extra: card);
          } else if (onRequestCardTap != null) {
            onRequestCardTap!();
          } else {
            showRequestCardBottomSheet(context);
          }
        },
        borderRadius: BorderRadius.circular(28.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF0F2B48),
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Promo text on the right
                Expanded(
                  child: Text(
                    'فعل إشتراكك واحصل على خصم على كل أوامرك',
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                // Circular orange arrow button on the left
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF8025),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chevron_left_rounded,
                      size: 22.r,
                      color: const Color(0xFF0F2B48),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Card displayed when user HAS an active discount card (Image 2 design).
  Widget _buildActiveCardView(BuildContext context, UserCardEntity cardEntity) {
    final String typeArabic = _formatTypeArabic(cardEntity.type);
    final String activatedDate = _formatDate(cardEntity.activatedAt ?? cardEntity.createdAt);
    final String expiresDate = _formatDate(cardEntity.expiresAt);
    final String subscriptionNote = _getSubscriptionNote(cardEntity);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
      child: InkWell(
        onTap: () => context.push(AppRoutes.cardDetails, extra: cardEntity),
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F2B48),
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: CustomPaint(
              painter: _CardWavePatternPainter(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 16.h,
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Orange Pill Badge
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF8025),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            'كارت خصومات شوب جايد',
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Row 1: رقم الكارت
                      _buildInfoRow(
                        context,
                        label: 'رقم الكارت',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cardEntity.cardNo.startsWith('#')
                                  ? cardEntity.cardNo
                                  : '#${cardEntity.cardNo}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: cardEntity.cardNo),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم نسخ رقم الكارت بنجاح'),
                                    backgroundColor: Color(0xFF10B981),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.copy_rounded,
                                size: 14.r,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildDivider(),

                      // Row 2: نوع الإشتراك
                      _buildInfoRow(
                        context,
                        label: 'نوع الإشتراك',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              typeArabic,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.access_time_rounded,
                              size: 14.r,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),

                      _buildDivider(),

                      // Row 3: حالة الكارت
                      _buildInfoRow(
                        context,
                        label: 'حالة الكارت',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'مُـفـعـل',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.check_circle_rounded,
                              size: 15.r,
                              color: const Color(0xFF10B981),
                            ),
                          ],
                        ),
                      ),

                      _buildDivider(),

                      // Row 4: تاريخ التفعيل
                      _buildInfoRow(
                        context,
                        label: 'تاريخ التفعيل',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              activatedDate,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 14.r,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),

                      _buildDivider(),

                      // Row 5: تاريخ الانتهاء
                      _buildInfoRow(
                        context,
                        label: 'تاريخ الانتهاء',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              expiresDate,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 14.r,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Bottom Promo Text with check icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 15.r,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            subscriptionNote,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 10.h,
      thickness: 0.6,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }

  String _formatTypeArabic(String type) {
    final t = type.toLowerCase();
    if (t.contains('semi') ||
        t.contains('نصف') ||
        t == '6_months' ||
        t == 'semi_annual') {
      return 'نصف سنوي';
    } else if (t.contains('annual') ||
        t.contains('year') ||
        t.contains('سنوي') ||
        t == '12_months') {
      return 'سنوي';
    } else if (t.contains('month') || t.contains('شهري') || t == '1_month') {
      return 'شهري';
    }
    return type.isNotEmpty ? type : 'نصف سنوي';
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '---';
    final dt = DateTime.tryParse(rawDate);
    if (dt == null) return rawDate;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _getSubscriptionNote(UserCardEntity card) {
    final t = card.type.toLowerCase();
    if (t.contains('semi') ||
        t.contains('نصف') ||
        t == '6_months' ||
        t == 'semi_annual') {
      return 'أنت الآن تتمتع بستة أشهر مجانية';
    } else if (t.contains('annual') ||
        t.contains('year') ||
        t.contains('سنوي') ||
        t == '12_months') {
      return 'أنت الآن تتمتع بسنة كاملة من الخصومات';
    } else if (t.contains('month') || t.contains('شهري')) {
      return 'أنت الآن تتمتع بشهر كامل من الخصومات';
    }
    return 'أنت الآن تتمتع بكافة خصومات ومزايا شوب جايد';
  }
}

/// Custom painter to draw subtle decorative waves across the VIP discount card.
class _CardWavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final startY = size.height * (0.35 + i * 0.16);
      path.moveTo(0, startY);

      double x = 0;
      double step = size.width / 6;
      bool up = true;

      while (x < size.width) {
        final nextX = x + step;
        final nextY = startY + (up ? -10 : 10);
        path.quadraticBezierTo(x + step / 2, nextY, nextX, startY);
        x = nextX;
        up = !up;
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
