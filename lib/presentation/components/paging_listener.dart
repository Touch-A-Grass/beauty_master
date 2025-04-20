import 'package:flutter/material.dart';

class PagingListener extends StatelessWidget {
  final VoidCallback onPageEnd;
  final Widget child;

  const PagingListener({super.key, required this.onPageEnd, required this.child});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) onPageEnd();
        return false;
      },
      child: child,
    ); //(child: child);
  }
}
