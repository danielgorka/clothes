import 'package:flutter/material.dart';

class AppBarFloatingActionButton extends StatefulWidget {
  final ScrollController scrollController;
  final double appBarHeight;
  final Widget child;
  final VoidCallback onPressed;

  const AppBarFloatingActionButton({
    Key? key,
    required this.scrollController,
    required this.appBarHeight,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AppBarFloatingActionButtonState createState() =>
      _AppBarFloatingActionButtonState();
}

class _AppBarFloatingActionButtonState
    extends State<AppBarFloatingActionButton> {
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updatePosition);
  }

  void _updatePosition() {
    setState(() {
      offset = widget.scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.appBarHeight - 28.0 - offset,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updatePosition);
    super.dispose();
  }
}
