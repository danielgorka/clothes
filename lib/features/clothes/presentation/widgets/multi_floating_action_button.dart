import 'package:flutter/material.dart';

@visibleForTesting
const overlayKey = Key('multi_floating_action_button_overlay');

class MultiFloatingActionButton extends StatefulWidget {
  final List<MultiFloatingActionButtonAction> actions;
  final Widget openedChild;
  final Widget closedChild;
  final Duration animationDuration;
  final String? tooltip;

  const MultiFloatingActionButton({
    Key? key,
    this.actions = const [],
    required this.openedChild,
    required this.closedChild,
    this.animationDuration = const Duration(milliseconds: 250),
    this.tooltip,
  }) : super(key: key);

  @override
  _MultiFloatingActionButtonState createState() =>
      _MultiFloatingActionButtonState();
}

class _MultiFloatingActionButtonState extends State<MultiFloatingActionButton>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeInAnimation;
  late final Animation<double> _fadeOutAnimation;
  late final Animation<double> _rotationAnimation;

  AnimationStatus _animStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _fadeOutAnimation = ReverseAnimation(_fadeInAnimation);
    _rotationAnimation = Tween(begin: 0.5, end: 1.0).animate(_fadeInAnimation);

    _controller.addListener(() {
      if (_animStatus != _controller.status) {
        setState(() {
          _animStatus = _controller.status;
        });
      }
    });
  }

  void _switchView() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  Widget _getOverlay() {
    return Positioned(
      key: overlayKey,
      left: 0.0,
      right: -15.0,
      top: 0.0,
      bottom: -15.0,
      child: IgnorePointer(
        ignoring: !_controller.isCompleted,
        child: GestureDetector(
          onPanDown: (_) => _switchView(),
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Theme.of(context).canvasColor.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getItems() {
    final actions = <Widget>[];
    if (!_controller.isDismissed) {
      actions.addAll(_getActionsWidgets());
    }

    actions.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FloatingActionButton(
          tooltip: _controller.isCompleted ? null : widget.tooltip,
          onPressed: _switchView,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Stack(
              children: [
                FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Center(child: widget.openedChild),
                ),
                FadeTransition(
                  opacity: _fadeOutAnimation,
                  child: Center(child: widget.closedChild),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: actions,
    );
  }

  List<Widget> _getActionsWidgets() {
    final actions = <Widget>[];
    final singleChildrenTween = 1.0 / widget.actions.length;
    var index = widget.actions.length - 1;
    for (final action in widget.actions) {
      final childAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * singleChildrenTween,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
      index--;

      final VoidCallback? onTap;
      if (action.onTap != null) {
        onTap = () {
          _switchView();
          action.onTap!.call();
        };
      } else {
        onTap = null;
      }

      actions.add(
        InkWell(
          borderRadius: BorderRadius.circular(32.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 4.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action.label != null)
                  ScaleTransition(
                    alignment: Alignment.bottomRight,
                    scale: childAnimation,
                    child: FadeTransition(
                      opacity: childAnimation,
                      child: action.label,
                    ),
                  ),
                const SizedBox(width: 4.0),
                ScaleTransition(
                  alignment: Alignment.bottomCenter,
                  scale: childAnimation,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: onTap,
                    child: action.child,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        _getOverlay(),
        _getItems(),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MultiFloatingActionButtonAction {
  final Widget? label;
  final Widget child;
  final VoidCallback? onTap;

  const MultiFloatingActionButtonAction({
    this.label,
    required this.child,
    this.onTap,
  });
}
