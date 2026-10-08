import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:market/core/routes/app_routes.dart';
import 'package:market/core/services/fcm_service.dart';
import 'package:market/features/splash/presentation/cubit/splash_cubit.dart';

class FakeGoRouter extends Fake implements GoRouter {
  String? pushedNamed;
  String? pushedLocation;
  String? wentNamed;
  String? wentLocation;

  @override
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) {
    wentNamed = name;
  }

  @override
  void go(String location, {Object? extra}) {
    wentLocation = location;
  }

  @override
  Future<T?> push<T extends Object?>(String location, {Object? extra}) async {
    pushedLocation = location;
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashCubit Navigation Tests', () {
    late SplashCubit cubit;
    late FakeGoRouter fakeRouter;

    setUp(() {
      cubit = SplashCubit();
      fakeRouter = FakeGoRouter();
      FCMService.pendingRoute = null;
    });

    tearDown(() {
      cubit.close();
      FCMService.pendingRoute = null;
    });

    test('navigates to home when there is no pending notification route', () {
      cubit.navigateToNext(fakeRouter);

      expect(fakeRouter.wentNamed, AppRoutes.homeNamed);
      expect(fakeRouter.pushedLocation, isNull);
    });

    test(
      'navigates to home and schedules push when pending notification route exists',
      () async {
        FCMService.pendingRoute = AppRoutes.orders;

        cubit.navigateToNext(fakeRouter);

        expect(fakeRouter.wentNamed, AppRoutes.homeNamed);
        expect(FCMService.pendingRoute, isNull); // consumed
      },
    );
  });
}
