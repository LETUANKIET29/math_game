import 'package:flutter/material.dart';

class MyDraggableWidget extends StatelessWidget {
  const MyDraggableWidget({
    super.key,
    required this.data,
    required this.onDragStart,
    required this.child,
  });

  final String data;
  final Function() onDragStart;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: data,
      onDragStarted: onDragStart,
      feedback: Opacity(
        opacity: 0.8,
        child: Material(
          child: child,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: child,
      ),
      child: child,
    );
  }
}
