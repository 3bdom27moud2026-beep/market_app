// ignore_for_file: prefer_initializing_formals
import 'package:flutter/foundation.dart';
import 'package:market/core/utils/api_client.dart';
import 'package:market/core/utils/end_points.dart';
import '../models/notification_model.dart';

class NotificationsRemoteDataSource {
  final ApiClient _apiClient;

  NotificationsRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// Fetch notifications and unread_count from GET /v1/notifications.
  Future<(List<NotificationItemModel>, int)> getNotifications({
    int page = 1,
  }) async {
    try {
      final response = await _apiClient.get(
        EndPoints.notifications,
        queryParameters: {'page': page},
      );

      final data = response.data;
      if (kDebugMode) {
        debugPrint('[NotificationsRemoteDataSource] response: $data');
      }

      int unreadCount = 0;
      List<dynamic> list = [];

      if (data is Map<String, dynamic>) {
        if (data['data'] is Map<String, dynamic>) {
          final d = data['data'] as Map<String, dynamic>;
          unreadCount = (d['unread_count'] as num?)?.toInt() ?? 0;
          if (d['notifications'] is List) {
            list = d['notifications'] as List;
          }
        } else if (data['notifications'] is List) {
          list = data['notifications'] as List;
          unreadCount = (data['unread_count'] as num?)?.toInt() ?? 0;
        } else if (data['data'] is List) {
          list = data['data'] as List;
        }
      } else if (data is List) {
        list = data;
      }

      final items = list
          .map((e) => NotificationItemModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (unreadCount == 0) {
        unreadCount = items.where((item) => !item.isRead).length;
      }

      return (items, unreadCount);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationsRemoteDataSource] Error fetching: $e');
      }
      return (<NotificationItemModel>[], 0);
    }
  }

  /// Mark single notification as read: POST /v1/notifications/{id}/read.
  Future<bool> markAsRead(String id) async {
    try {
      final response = await _apiClient.post(EndPoints.notificationRead(id));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationsRemoteDataSource] Error markAsRead: $e');
      }
      return false;
    }
  }

  /// Mark all notifications as read: POST /v1/notifications/read-all.
  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiClient.post(EndPoints.notificationsReadAll);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationsRemoteDataSource] Error markAllAsRead: $e');
      }
      return false;
    }
  }

  /// Delete notification: DELETE /v1/notifications/{id}.
  Future<bool> deleteNotification(String id) async {
    try {
      final response = await _apiClient.delete(
        EndPoints.notificationDelete(id),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[NotificationsRemoteDataSource] Error deleteNotification: $e',
        );
      }
      return false;
    }
  }

  /// Update or register FCM device token: POST /v1/notifications/fcm-token.
  Future<bool> updateFcmToken({
    required String fcmToken,
    String deviceType = 'android',
  }) async {
    try {
      final response = await _apiClient.post(
        EndPoints.fcmToken,
        data: {
          'fcm_token': fcmToken,
          'token': fcmToken,
          'device_type': deviceType,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[NotificationsRemoteDataSource] Error updateFcmToken: $e');
      }
      return false;
    }
  }
}
