import 'package:beauty_master/presentation/components/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ShimmerLoadingPainter extends StatefulWidget {
  final Widget child;
  final bool active;

  const ShimmerLoadingPainter({super.key, required this.child, this.active = true});

  @override
  State<ShimmerLoadingPainter> createState() => _ShimmerLoadingPainterState();
}

class _ShimmerLoadingPainterState extends State<ShimmerLoadingPainter> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChanged);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerAnimation;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChanged);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChanged);
    super.dispose();
  }

  void _onShimmerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) {
      return widget.child;
    }

    final shimmer = Shimmer.of(context);
    final renderObject = context.findRenderObject();

    if (shimmer == null || !shimmer.isSized || renderObject == null || renderObject is! RenderBox) {
      return widget.child;
    }

    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;

    final offsetWithinShimmer = shimmer.getDescendantOffset(descendant: renderObject);

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(-offsetWithinShimmer.dx, -offsetWithinShimmer.dy, shimmerSize.width, shimmerSize.height),
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerSwitcher extends StatelessWidget {
  final bool isLoading;
  final Widget loadingChild;
  final Widget child;

  const ShimmerSwitcher({super.key, required this.isLoading, required this.loadingChild, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: isLoading ? loadingChild : child);
  }
}

class SliverShimmerSwitcher extends StatelessWidget {
  final bool isLoading;
  final Widget loadingChild;
  final Widget child;

  const SliverShimmerSwitcher({super.key, required this.isLoading, required this.loadingChild, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedSwitcher(duration: const Duration(milliseconds: 250), child: isLoading ? loadingChild : child);
  }
}

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoadingPainter(child: ShimmerContentBox(width: width, height: height, borderRadius: borderRadius));
  }
}

class ShimmerContentBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerContentBox({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      width: width,
      height: height,
    );
  }
}
