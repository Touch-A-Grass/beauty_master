import 'package:auto_route/auto_route.dart';
import 'package:beauty_master/presentation/navigation/app_router.gr.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        if (!AutoRouter.of(context).canPop()) {
          AutoRouter.of(context).pushAndPopUntil(HomeRoute(children: [OrdersRoute()]), predicate: (route) => false);
        } else {
          context.maybePop();
        }
      },
    );
  }
}
