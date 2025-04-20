import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/presentation/navigation/app_router.gr.dart';
import 'package:beauty_master/presentation/navigation/navigation_state_updater.dart';

class AuthGuard extends AutoRouteGuard {
  final NavigationStateUpdater navigationStateUpdater;

  AuthGuard(this.navigationStateUpdater);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (navigationStateUpdater.isAuthorized) {
      resolver.next();
    } else {
      resolver.redirect(
        AuthRoute(
          onLoggedIn: () {
            resolver.resolveNext(true, reevaluateNext: false);
          },
        ),
      );
    }
  }
}
