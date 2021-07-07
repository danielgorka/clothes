import 'package:flutter/material.dart';

enum ShadowSide {
  top,
  bottom,
}

class ImageShadow extends StatelessWidget {
  final ShadowSide side;

  const ImageShadow({
    Key? key,
    required this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Alignment begin;
    Alignment end;
    switch (side) {
      case ShadowSide.top:
        begin = Alignment.bottomCenter;
        end = Alignment.topCenter;
        break;
      case ShadowSide.bottom:
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
        break;
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.4),
              ],
              begin: begin,
              end: end,
              stops: const [0.6, 0.83, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
