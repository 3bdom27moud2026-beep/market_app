// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market/core/utils/auth_event_bus.dart';
import '../../data/datasource/notifications_remote_datasource.dart';
import '../../dependency_injection.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRemoteDataSource _remoteDataSource;
  StreamSubscription<AuthEvent>? _authSubscription;

  NotificationsCubit({required NotificationsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource,
      super(const NotificationsState()) {
    _authSubscription = AuthEventBus.instance.stream.listen((event) {
      if (event.type == AuthEventType.loggedIn) {
        loadNotifications();
        try {
          NotificationsDI.fcmService.syncTokenWithBackend();
        } catch (_) {}
      } else if (event.type == AuthEventType.loggedOut) {
        emit(const NotificationsState());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: NotificationsStatus.loading));

    try {
      final (items, unreadCount) = await _remoteDataSource.getNotifications();
      emit(
        state.copyWith(
          status: NotificationsStatus.loaded,
          notifications: items,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationsStatus.error,
          errorMessage: 'فشل في تحميل الإشعارات',
        ),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    final updatedList = state.notifications.map((item) {
      if (item.id == id && !item.isRead) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();

    final unread = updatedList.where((n) => !n.isRead).length;
    emit(state.copyWith(notifications: updatedList, unreadCount: unread));

    await _remoteDataSource.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    final updatedList = state.notifications.map((item) {
      return item.copyWith(isRead: true);
    }).toList();

    emit(state.copyWith(notifications: updatedList, unreadCount: 0));

    await _remoteDataSource.markAllAsRead();
  }

  Future<void> deleteNotification(String id) async {
    final updatedList = state.notifications
        .where((item) => item.id != id)
        .toList();
    final unread = updatedList.where((n) => !n.isRead).length;

    emit(state.copyWith(notifications: updatedList, unreadCount: unread));

    await _remoteDataSource.deleteNotification(id);
  }
}
