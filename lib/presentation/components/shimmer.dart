import 'package:beauty_master/presentation/theme/gradients.dart';
import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  final Widget? child;
  final LinearGradient? gradient;
  final AnimationController? controller;

  const Shimmer({super.key, this.child, this.gradient, this.controller});

  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  @override
  State<Shimmer> createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  late LinearGradient _gradient;

  @override
  void initState() {
    super.initState();

    _gradient = widget.gradient ?? Gradients.shimmer;

    _shimmerController =
        widget.controller ?? (AnimationController(vsync: this)..repeat(period: const Duration(seconds: 2)));

    _shimmerAnimation = Tween<double>(begin: -1, end: 2).animate(_shimmerController);
  }

  Listenable get shimmerAnimation => _shimmerAnimation;

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

  Gradient get gradient => LinearGradient(
    colors: _gradient.colors,
    stops: _gradient.stops,
    begin: _gradient.begin,
    end: _gradient.end,
    tileMode: _gradient.tileMode,
    transform: _SlidingGradientTransform(slidePercent: _shimmerAnimation.value),
  );

  bool get isSized => (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({required RenderBox descendant, Offset offset = Offset.zero}) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
