import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ShimmerType {
  normal,
  canvas,
  text,
}

class AppShimmer extends StatelessWidget {
  final ShimmerType type;
  final Widget child;

  const AppShimmer({
    Key? key,
    this.type = ShimmerType.normal,
    required this.child,
  }) : super(key: key);

  Color _highlightColorFromBase(bool isDark, Color baseColor) {
    final hslColor = HSLColor.fromColor(baseColor);
    final lightness = hslColor.lightness + (isDark ? 0.05 : -0.05);
    return hslColor.withLightness(lightness).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness != Brightness.light;
    Color baseColor;
    Color highlightColor;

    switch (type) {
      case ShimmerType.normal:
        baseColor = isDark ? Colors.grey[600]! : Colors.grey[300]!;
        highlightColor = isDark ? Colors.grey[500]! : Colors.grey[100]!;
        break;
      case ShimmerType.canvas:
        baseColor = Theme.of(context).canvasColor;
        highlightColor = _highlightColorFromBase(isDark, baseColor);
        break;
      case ShimmerType.text:
        baseColor = isDark ? Colors.white : Colors.grey[800]!;
        highlightColor = isDark ? Colors.grey[600]! : Colors.grey[100]!;
        break;
    }

    return AbsorbPointer(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: child,
      ),
    );
  }
}
