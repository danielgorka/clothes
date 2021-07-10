import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ShadowSide {
  top,
  bottom,
}

class ImageShadow extends StatelessWidget {
  final ShadowSide side;
  final bool overrideSystemUiOverlayStyle;

  const ImageShadow({
    Key? key,
    required this.side,
    this.overrideSystemUiOverlayStyle = false,
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

    Widget content = IgnorePointer(
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
    );

    if (overrideSystemUiOverlayStyle) {
      content = AnnotatedRegion<SystemUiOverlayStyle>(
        key: Keys.imageShadowAnnotatedRegion,
        value: AppTheme.overlayDark,
        child: content,
      );
    }

    return Positioned.fill(
      child: content,
    );
  }
}
