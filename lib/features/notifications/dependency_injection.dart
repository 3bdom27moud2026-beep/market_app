import 'package:get_it/get_it.dart';
import 'package:market/core/services/fcm_service.dart';
import 'package:market/core/utils/api_client.dart';
import 'data/datasource/notifications_remote_datasource.dart';
import 'presentation/cubit/notifications_cubit.dart';

abstract final class NotificationsDI {
  static void init(GetIt sl) {
    sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotificationsRemoteDataSource(apiClient: sl<ApiClient>()),
    );

    sl.registerLazySingleton<FCMService>(
      () => FCMService(remoteDataSource: sl<NotificationsRemoteDataSource>()),
    );

    sl.registerFactory<NotificationsCubit>(
      () => NotificationsCubit(
        remoteDataSource: sl<NotificationsRemoteDataSource>(),
      ),
    );
  }

  static NotificationsCubit createNotificationsCubit() {
    return GetIt.instance<NotificationsCubit>();
  }

  static FCMService get fcmService {
    return GetIt.instance<FCMService>();
  }
}
