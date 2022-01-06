import 'package:flutter/material.dart';
import 'package:sleep_timer/src/globals.dart';

class AnimatedTimer extends StatefulWidget {
  final String text;

  final bool isAnimationActive;
  const AnimatedTimer(
      {Key? key, required this.text, required this.isAnimationActive})
      : super(key: key);

  @override
  _AnimatedTimerState createState() => _AnimatedTimerState();
}

class _AnimatedTimerState extends State<AnimatedTimer>
    with TickerProviderStateMixin {
  // late final AnimationController _animationTransitionTopCenterController =
  //     AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  late final AnimationController _slideAnimationController =
      AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1000));

  late final Animation<AlignmentGeometry> _animationCenterDown =
      TweenSequence(<TweenSequenceItem<AlignmentGeometry>>[
    TweenSequenceItem(
        tween: Tween<AlignmentGeometry>(
          begin: Alignment.topCenter,
          end: Alignment.center,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 1),
    TweenSequenceItem(
        tween: Tween<AlignmentGeometry>(
          begin: Alignment.center,
          end: Alignment.center,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 2.3),
    TweenSequenceItem(
        tween: Tween<AlignmentGeometry>(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 1)
  ]).animate(_slideAnimationController);
  late final Animation<double> _opacityAnimation =
      TweenSequence(<TweenSequenceItem<double>>[
    TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 1),
    TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 1,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 2.3),
    TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 1)
  ]).animate(_slideAnimationController);
  // late final Animation<double> _opacityAnimation = Tween<double>(
  //   begin: 0,
  //   end: 1,
  // ).animate(CurvedAnimation(
  //   parent: _animationOpacityController,
  //   curve: Curves.linear,
  // ));

  @override
  void dispose() {
    _slideAnimationController.dispose();

    super.dispose();
  }

  runAnimation() async {
    if (widget.isAnimationActive) {
      await _slideAnimationController.repeat();
    } else {
      _slideAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    runAnimation();
    return SizedBox(
      height: 100,
      child: Builder(builder: (context) {
        return alignedTransition(
            AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity:
                      widget.isAnimationActive ? _opacityAnimation.value : 1,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isDarkTheme.value ? Colors.teal : Colors.pinkAccent,
                ),
                child: Text(widget.text,
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            widget.isAnimationActive);
      }),
    );
  }

  Widget alignedTransition(Widget child, bool isAnimating) {
    return isAnimating
        ? AlignTransition(alignment: _animationCenterDown, child: child)
        : Center(child: child);
  }
}
