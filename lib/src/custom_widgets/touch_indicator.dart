import 'package:flutter/material.dart';

class TouchIndicator extends StatefulWidget {
  final Widget child;
  const TouchIndicator({Key? key, required this.child}) : super(key: key);

  @override
  State<TouchIndicator> createState() => _TouchIndicatorState();
}

class _TouchIndicatorState extends State<TouchIndicator> {
  Widget indicator = Container();
  final pointerIcon = const CircleAvatar(
    radius: 15,
    backgroundColor: Colors.white38,
  );
  @override
  Widget build(BuildContext context) {
    double safeAreaPadding = MediaQuery.of(context).viewPadding.top;
    return Listener(
      child: Stack(
        children: [widget.child, indicator],
      ),
      onPointerDown: (event) {
        setState(() {
          indicator = Positioned(
              top: event.localPosition.dy - safeAreaPadding,
              left: event.localPosition.dx,
              child: pointerIcon);
        });
      },
      onPointerMove: (event) {
        setState(() {
          indicator = Positioned(
              top: event.localPosition.dy - safeAreaPadding,
              left: event.localPosition.dx,
              child: pointerIcon);
        });
      },
      onPointerUp: (event) {
        setState(() {
          indicator = Container();
        });
      },
      onPointerCancel: (event) {
        setState(() {
          indicator = Container();
        });
      },
    );
  }
}
