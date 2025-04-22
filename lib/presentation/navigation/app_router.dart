import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/presentation/navigation/app_router.gr.dart';
import 'package:beauty_master/presentation/navigation/guards/auth_guard.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  static const mainShellRoute = EmptyShellRoute('MainRoute');

  final AuthGuard authGuard;

  AppRouter({required this.authGuard}) : super();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: AuthRoute.page, path: '/auth'),
    AutoRoute(page: OrderDetailsRoute.page, path: '/orders/:orderId', usesPathAsKey: true),
    AutoRoute(page: ImageCropRoute.page, path: '/image-crop'),
    AutoRoute(
      page: mainShellRoute,
      initial: true,
      guards: [authGuard],
      children: [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          children: [
            AutoRoute(page: CalendarRoute.page, path: 'calendar'),
            AutoRoute(page: OrdersRoute.page, initial: true, path: 'orders'),
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
          ],
        ),
      ],
    ),
  ];
}
