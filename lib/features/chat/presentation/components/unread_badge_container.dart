import 'package:flutter/material.dart';

class UnreadBadgeContainer extends StatelessWidget {
  final int count;
  final Widget child;
  final double top;
  final double right;

  const UnreadBadgeContainer({super.key, required this.count, required this.child, this.top = -8, this.right = -4});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            top: top,
            right: right,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: Text(
                count.clamp(1, 99).toString(),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
