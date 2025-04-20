import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverPinnedHeaderNoSpace extends SingleChildRenderObjectWidget {
  const SliverPinnedHeaderNoSpace({super.key, required Widget super.child});

  @override
  RenderSliverPinnedHeaderNoSpace createRenderObject(BuildContext context) {
    return RenderSliverPinnedHeaderNoSpace();
  }
}

class RenderSliverPinnedHeaderNoSpace extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    final paintedChildExtent = min(childExtent, constraints.remainingPaintExtent - constraints.overlap);
    geometry = SliverGeometry(
      paintExtent: paintedChildExtent,
      maxPaintExtent: childExtent,
      maxScrollObstructionExtent: childExtent,
      paintOrigin: constraints.overlap,
      scrollExtent: 0,
      layoutExtent: 0,
      hasVisualOverflow: paintedChildExtent < childExtent,
    );
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    return 0;
  }
}
