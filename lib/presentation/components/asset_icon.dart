import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetIcon extends StatelessWidget {
  final String path;
  final double? size;
  final Color? color;

  const AssetIcon(
    this.path, {
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            ),
      width: size,
      height: size,
    );
  }
}
