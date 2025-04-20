import 'dart:ui';

import 'package:beauty_master/presentation/components/app_overlay.dart';
import 'package:beauty_master/presentation/components/push_handler.dart';
import 'package:beauty_master/presentation/components/shimmer.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatelessWidget {
  final Widget child;

  const RootScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(titleTextStyle: Theme.of(context).textTheme.titleMedium),
      ),
      child: PushHandler(
        child: AppOverlay(
          child: Scaffold(
            body: Shimmer(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(const Size(600, double.infinity)),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
