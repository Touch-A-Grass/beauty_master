import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppOverlay extends StatelessWidget {
  final Widget child;

  const AppOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (Theme.of(context).brightness == Brightness.dark)
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: child,
    );
  }
}
