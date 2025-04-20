import 'package:flutter/material.dart';

class Gradients {
  static get shimmer => LinearGradient(
    colors: [Colors.transparent, Colors.grey.shade300.withAlpha(50), Colors.transparent],
    stops: [0.1, 0.3, 0.5],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
