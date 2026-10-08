import 'package:market/core/routes/app_routes.dart';

class NotificationItemModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? referenceId;
  final bool isRead;
  final String createdAt;
  final String? actionRoute;

  const NotificationItemModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    required this.isRead,
    required this.createdAt,
    this.actionRoute,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    final bool read =
        json['read_at'] != null ||
        json['read'] == true ||
        json['is_read'] == true;

    final String type = json['type']?.toString() ?? 'general';
    final String? refId =
        json['reference_id']?.toString() ??
        (json['data'] is Map ? json['data']['id']?.toString() : null);

    // Resolve navigation route
    String? route =
        json['route']?.toString() ??
        (json['data'] is Map ? json['data']['route']?.toString() : null);

    if (route == null || route.isEmpty) {
      if (type.contains('order')) {
        route = AppRoutes.orders;
      } else if (type.contains('card') || type.contains('discount')) {
        route = AppRoutes.discountCard;
      } else if (type.contains('points') || type.contains('loyalty')) {
        route = AppRoutes.profile;
      } else if (type.contains('merchant')) {
        if (refId != null && refId.isNotEmpty) {
          route = '/merchant-details/$refId';
        } else {
          route = AppRoutes.merchants;
        }
      } else if (type.contains('category')) {
        route = AppRoutes.categories;
      }
    }

    return NotificationItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? json['message']?.toString() ?? '',
      type: type,
      referenceId: refId,
      isRead: read,
      createdAt: json['created_at']?.toString() ?? '',
      actionRoute: route,
    );
  }

  NotificationItemModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? referenceId,
    bool? isRead,
    String? createdAt,
    String? actionRoute,
  }) {
    return NotificationItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}
