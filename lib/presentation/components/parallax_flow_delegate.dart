import 'package:flutter/material.dart';

class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext itemContext;

  ParallaxFlowDelegate({required this.scrollable, required this.itemContext});

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = itemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(
      0.0,
      1.0,
    );

    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    final backgroundSize = (itemContext.findRenderObject() as RenderBox).size;
    final listItemSize = context.size;
    final childRect = verticalAlignment.inscribe(
      backgroundSize,
      Offset.zero & listItemSize,
    );

    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top - listItemOffset.dy * 0.5 + context.size.height / 4))
              .transform,
    );
  }

  @override
  bool shouldRepaint(covariant ParallaxFlowDelegate oldDelegate) {
    return true;
  }
}
