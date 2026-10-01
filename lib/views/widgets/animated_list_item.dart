import 'package:flutter/material.dart';

import '../../core/constants/app_durations.dart';
import '../../core/constants/app_sizes.dart';

/// Fade and slide-up entry animation for list and grid items, with a
/// staggered delay based on the item's [index].
///
/// Only the first [AppDurations.maxStaggerItems] items get an increasing
/// delay, so items far down a long list never wait to appear.
///
/// The delay is part of a single controller timeline (using an [Interval])
/// instead of a `Future.delayed` timer, so nothing keeps running or fires
/// after the widget is disposed.
///
/// The animation plays each time the item is built. Lazy lists (such as
/// `ListView.builder`) rebuild items that scroll back into view, so pass
/// `animate: false` for items that should not animate again.
class AnimatedListItem extends StatefulWidget {
  const AnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    this.animate = true,
  });

  /// Position of the item in the list. Drives the stagger delay.
  final int index;

  final Widget child;

  /// Set to false to show the item immediately, without animation.
  final bool animate;

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  bool _started = false;

  @override
  void initState() {
    super.initState();

    final int staggerSteps = widget.index.clamp(
      0,
      AppDurations.maxStaggerItems,
    );
    final Duration delay = AppDurations.listItemStagger * staggerSteps;
    final Duration total = AppDurations.listItemAnimation + delay;

    _controller = AnimationController(vsync: this, duration: total);
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1,
        curve: AppCurves.entrance,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    // Respect the system "reduce motion" setting.
    final bool skipAnimation =
        !widget.animate || MediaQuery.disableAnimationsOf(context);
    if (skipAnimation) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _progress,
      child: AnimatedBuilder(
        animation: _progress,
        child: widget.child,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(
              0,
              (1 - _progress.value) * AppDimensions.listItemSlideOffset,
            ),
            child: child,
          );
        },
      ),
    );
  }
}
