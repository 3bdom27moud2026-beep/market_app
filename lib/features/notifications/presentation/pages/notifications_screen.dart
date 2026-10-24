import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:market/core/extensions/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/constants/app_spacing.dart';
import 'package:market/core/constants/app_text_styles.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import '../../data/models/notification_model.dart';
import '../../dependency_injection.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import 'package:market/core/widgets/custom_nav_buttons.dart';

/// Screen displaying customer notifications with live backend sync.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<NotificationsCubit>();
      return const _NotificationsView();
    } catch (_) {
      return BlocProvider<NotificationsCubit>(
        create: (_) =>
            NotificationsDI.createNotificationsCubit()..loadNotifications(),
        child: const _NotificationsView(),
      );
    }
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  int _selectedFilterIndex = 0;
  StreamSubscription<AuthEvent>? _authSubscription;

  final List<String> _filters = [
    'الكل',
    'عروض مخصصة لك 🎁',
    'تحديثات الطلبات 📦',
    'خصومات الكارت 💳',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationsCubit>().loadNotifications();
      }
    });
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      if (event.type == AuthEventType.loggedIn) {
        context.read<NotificationsCubit>().loadNotifications();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  String _formatNotificationDate(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final dateTime = DateTime.tryParse(rawDate);
      if (dateTime == null) return rawDate;
      final local = dateTime.toLocal();
      final now = DateTime.now();
      final difference = now.difference(local);

      if (difference.inSeconds < 60 && !difference.isNegative) {
        return 'الآن';
      } else if (difference.inMinutes < 60 && !difference.isNegative) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24 && !difference.isNegative) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays < 7 && !difference.isNegative) {
        return 'منذ ${difference.inDays} يوم';
      } else {
        return DateFormat('yyyy/MM/dd - hh:mm a', 'ar').format(local);
      }
    } catch (_) {
      return rawDate;
    }
  }

  List<NotificationItemModel> _applyFilter(List<NotificationItemModel> items) {
    if (_selectedFilterIndex == 0) return items;
    if (_selectedFilterIndex == 1) {
      return items.where((n) {
        final t = n.type.toLowerCase();
        return t.contains('offer') ||
            t.contains('promo') ||
            t.contains('personalized') ||
            t.contains('custom');
      }).toList();
    }
    if (_selectedFilterIndex == 2) {
      return items
          .where((n) => n.type.toLowerCase().contains('order'))
          .toList();
    }
    return items.where((n) {
      final t = n.type.toLowerCase();
      return t.contains('card') ||
          t.contains('discount') ||
          t.contains('points') ||
          t.contains('loyalty');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final filteredList = _applyFilter(state.notifications);
        final unreadCount = state.unreadCount;

        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: AppBar(
            backgroundColor: context.colors.surface,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الإشعارات',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    color: context.colors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unreadCount > 0) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.accentOrange,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            leading: Padding(
              padding: EdgeInsets.all(6.r),
              child: const AppBackButton(),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: const CartBadgeButton(),
              ),
            ],
          ),
          body:
              state.status == NotificationsStatus.loading &&
                  state.notifications.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: context.colors.primary,
                  ),
                )
              : state.status == NotificationsStatus.error &&
                    state.notifications.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48.r,
                          color: context.colors.accentRed,
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        Text(
                          state.errorMessage ?? 'حدث خطأ أثناء تحميل الإشعارات',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            color: context.colors.textSecondary,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg.h),
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<NotificationsCubit>()
                              .loadNotifications(),
                          icon: Icon(Icons.refresh_rounded, size: 16.r),
                          label: Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Filter buttons bar
                    Container(
                      color: context.colors.surface,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      height: 52.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg.w,
                        ),
                        itemCount: _filters.length,
                        separatorBuilder: (_, _) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final isSelected = _selectedFilterIndex == index;
                          return InkWell(
                            onTap: () =>
                                setState(() => _selectedFilterIndex = index),
                            borderRadius: BorderRadius.circular(20.r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: isSelected
                                      ? context.colors.primary
                                      : context.colors.borderLight,
                                  width: 1.w,
                                ),
                              ),
                              child: Text(
                                _filters[index],
                                style: TextStyle(
                                  fontFamily: AppTextStyles.fontFamily,
                                  fontSize: 12.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : context.colors.textSecondary,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(height: 1.h, color: context.colors.divider),

                    // Notifications list or empty view
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => context
                            .read<NotificationsCubit>()
                            .loadNotifications(),
                        child: filteredList.isEmpty
                            ? LayoutBuilder(
                                builder: (context, constraints) =>
                                    SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight,
                                        ),
                                        child: _buildEmptyState(),
                                      ),
                                    ),
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.all(AppSpacing.lg.r),
                                itemCount: filteredList.length,
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: AppSpacing.md.h),
                                itemBuilder: (context, index) {
                                  final item = filteredList[index];
                                  return _buildDismissibleCard(context, item);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxxl.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.primary.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 40.r,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'لا توجد إشعارات حالياً',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Text(
              'سنقوم بإشعارك بأحدث العروض المخصصة وحالة طلباتك فور توفرها',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 12.sp,
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleCard(
    BuildContext context,
    NotificationItemModel item,
  ) {
    return Dismissible(
      key: Key('notif_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: context.colors.accentRed,
          borderRadius: BorderRadius.circular(AppSpacing.md.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22.r),
            SizedBox(width: 6.w),
            Text(
              'حذف',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        context.read<NotificationsCubit>().deleteNotification(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم حذف الإشعار',
              style: TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 12.sp,
              ),
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: _buildNotificationCard(context, item),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationItemModel item,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final type = item.type.toLowerCase();
    final (
      IconData icon,
      Color color,
      Color bgColor,
    ) = type.contains('offer') || type.contains('promo')
        ? (
            Icons.local_offer_rounded,
            const Color(0xFFEF8226),
            isDark
                ? const Color(0xFFEF8226).withValues(alpha: 0.15)
                : const Color(0xFFFFF3E0),
          )
        : type.contains('order')
        ? (
            Icons.inventory_2_rounded,
            context.colors.primary,
            isDark
                ? context.colors.primary.withValues(alpha: 0.15)
                : const Color(0xFFE8EEF5),
          )
        : type.contains('card') || type.contains('discount')
        ? (
            Icons.card_membership_rounded,
            const Color(0xFF2E7D32),
            isDark
                ? const Color(0xFF2E7D32).withValues(alpha: 0.15)
                : const Color(0xFFE8F5E9),
          )
        : (
            Icons.campaign_rounded,
            const Color(0xFF0288D1),
            isDark
                ? const Color(0xFF0288D1).withValues(alpha: 0.15)
                : const Color(0xFFE1F5FE),
          );

    final bool hasAction =
        item.actionRoute != null && item.actionRoute!.isNotEmpty;

    return InkWell(
      onTap: () {
        if (!item.isRead) {
          context.read<NotificationsCubit>().markAsRead(item.id);
        }
        if (hasAction) {
          context.push(item.actionRoute!);
        }
      },
      borderRadius: BorderRadius.circular(AppSpacing.md.r),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.r),
        decoration: BoxDecoration(
          color: item.isRead
              ? context.colors.surface
              : (isDark
                    ? context.colors.surface.withValues(alpha: 0.8)
                    : const Color(0xFFF4F8FC)),
          borderRadius: BorderRadius.circular(AppSpacing.md.r),
          border: Border.all(
            color: item.isRead
                ? context.colors.borderLight
                : context.colors.primary.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20.r),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 13.sp,
                            fontWeight: item.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: context.colors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                      ),
                      if (!item.isRead) ...[
                        SizedBox(width: 6.w),
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.accentOrange,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.body,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      color: context.colors.textSecondary,
                      height: 1.45,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.createdAt.isNotEmpty)
                        Expanded(
                          child: Text(
                            _formatNotificationDate(item.createdAt),
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w500,
                              color: context.colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        const Spacer(),
                      if (hasAction) ...[
                        SizedBox(width: 8.w),
                        _buildActionPill(context, item, color),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionPill(
    BuildContext context,
    NotificationItemModel item,
    Color color,
  ) {
    final type = item.type.toLowerCase();
    final String label = type.contains('offer') || type.contains('promo')
        ? 'عرض العرض'
        : type.contains('order')
        ? 'تفاصيل الطلب'
        : type.contains('card') || type.contains('discount')
        ? 'عرض الكارت'
        : type.contains('merchant')
        ? 'زيارة المتجر'
        : 'عرض التفاصيل';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1.1,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.arrow_back_ios_new_rounded, size: 9.r, color: color),
        ],
      ),
    );
  }
}
