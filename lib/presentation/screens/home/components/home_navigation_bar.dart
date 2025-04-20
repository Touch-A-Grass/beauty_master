import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class HomeNavigationBarItem {
  final IconData icon;
  final String? label;

  HomeNavigationBarItem({required this.icon, this.label});
}

class HomeNavigationBar extends StatefulWidget {
  final List<HomeNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const HomeNavigationBar({super.key, required this.items, required this.currentIndex, required this.onItemTapped});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  int prevIndex = 0;

  @override
  void didUpdateWidget(covariant HomeNavigationBar oldWidget) {
    if (oldWidget.currentIndex != widget.currentIndex) {
      prevIndex = oldWidget.currentIndex;
      animationController.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250), value: 1);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 8 * (widget.items.length - 1)) / widget.items.length;

          return Stack(
            children: [
              AnimatedPositioned(
                top: 0,
                bottom: 0,
                left: (itemWidth + 8) * widget.currentIndex,
                width: itemWidth,
                duration: Duration(milliseconds: 250),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              Row(
                children:
                    widget.items.mapIndexed((index, item) => _buildItem(context, item, index, itemWidth)).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, HomeNavigationBarItem item, int index, double itemWidth) {
    return Padding(
      padding: index > 0 ? const EdgeInsets.only(left: 8) : EdgeInsets.zero,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => widget.onItemTapped(widget.items.indexOf(item)),
        child: SizedBox(
          width: itemWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final Color color;

                if (index == widget.currentIndex) {
                  color =
                      Color.lerp(
                        Theme.of(context).colorScheme.onPrimaryContainer,
                        Theme.of(context).colorScheme.onSurface,
                        animation.value,
                      )!;
                } else if (index == prevIndex) {
                  color =
                      Color.lerp(
                        Theme.of(context).colorScheme.onSurface,
                        Theme.of(context).colorScheme.onPrimaryContainer,
                        animation.value,
                      )!;
                } else {
                  color = Theme.of(context).colorScheme.onPrimaryContainer;
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: color, size: 32),
                    if (item.label != null) ...[
                      const SizedBox.square(dimension: 4),
                      Text(item.label!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
