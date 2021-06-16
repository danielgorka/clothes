import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart' as s;

class Shimmer extends StatelessWidget {
  final Widget child;

  const Shimmer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness != Brightness.light;
    final baseColor = Theme.of(context).canvasColor;
    final hslColor = HSLColor.fromColor(baseColor);
    final lightness = hslColor.lightness + (isDark ? 0.05 : -0.05);
    final highlightColor = hslColor.withLightness(lightness).toColor();
    return AbsorbPointer(
      child: s.Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child,
      ),
    );
  }
}
