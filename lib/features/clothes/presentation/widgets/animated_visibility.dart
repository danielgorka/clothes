import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Duration duration;
  final Widget child;

  const AnimatedVisibility({
    Key? key,
    required this.visible,
    required this.duration,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: duration,
      crossFadeState:
          visible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: Container(),
      secondChild: IgnorePointer(
        ignoring: !visible,
        child: child,
      ),
    );
  }
}
