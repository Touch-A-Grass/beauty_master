import 'package:flutter/material.dart';

class RatingView extends StatelessWidget {
  final int rating;
  final double starSize;
  final ValueChanged<int>? onRatingChanged;

  const RatingView({super.key, required this.rating, this.starSize = 24, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: List.generate(
        5,
            (index) => RatingStarView(
          active: index < (rating / 2),
          size: starSize,
          onClick: onRatingChanged == null ? null : () => onRatingChanged?.call((index + 1) * 2),
        ),
      ),
    );
  }
}

class RatingStarView extends StatelessWidget {
  final bool active;
  final VoidCallback? onClick;
  final double size;

  const RatingStarView({super.key, required this.active, this.onClick, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Icon(Icons.star, color: active ? Colors.orange : Colors.grey, size: size),
    );
  }
}
