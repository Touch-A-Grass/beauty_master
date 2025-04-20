import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppDraggableModalSheet extends StatefulWidget {
  static const double closeExtent = 0.25;

  final ScrollableWidgetBuilder builder;
  final DraggableScrollableController? controller;

  const AppDraggableModalSheet({super.key, required this.builder, this.controller});

  @override
  State<AppDraggableModalSheet> createState() => _AppDraggableModalSheetState();
}

class _AppDraggableModalSheetState extends State<AppDraggableModalSheet> {
  bool isClosed = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (!isClosed && notification.extent <= AppDraggableModalSheet.closeExtent) {
          isClosed = true;
          context.maybePop();
        }
        return false;
      },
      child: DraggableScrollableSheet(
        controller: widget.controller,
        snap: true,
        initialChildSize: 1,
        minChildSize: 0,
        shouldCloseOnMinExtent: false,
        maxChildSize: 1,
        snapSizes: const [1],
        builder: widget.builder,
      ),
    );
  }
}
