import 'package:flutter/material.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/widget/game_sort%20numbers/types.dart';

class MyDropRegion extends StatefulWidget {
  const MyDropRegion({
    super.key,
    required this.childSize,
    required this.columns,
    required this.panel,
    required this.onDrop,
    required this.setExternalData,
    required this.updateDropPreview,
    required this.child,
  });

  final Size childSize;
  final int columns;
  final Panel panel;
  final VoidCallback onDrop;
  final void Function(ItemModel) setExternalData;
  final void Function(PanelLocation) updateDropPreview;
  final Widget child;

  @override
  State<MyDropRegion> createState() => _MyDropRegionState();
}

class _MyDropRegionState extends State<MyDropRegion> {
  int? dropIndex;

  @override
  Widget build(BuildContext context) {
    return DragTarget<ItemModel>(
      onWillAcceptWithDetails: (data) {
        return true;
      },
      onAcceptWithDetails: (data) {
        widget.setExternalData(data.data);
        widget.onDrop();
      },
      builder: (BuildContext context, List<ItemModel?> candidateData, List<dynamic> rejectedData) {
        return GestureDetector(
          onPanUpdate: (details) {
            _updatePreview(details.localPosition);
          },
          child: widget.child,
        );
      },
    );
  }

  void _updatePreview(Offset hoverPosition) {
    final int row = hoverPosition.dy ~/ widget.childSize.height;
    final int column = (hoverPosition.dx - (widget.childSize.width / 2).toInt()) ~/
        widget.childSize.width.toInt();
    int newDropIndex = (row * widget.columns) + column;

    if (newDropIndex != dropIndex) {
      dropIndex = newDropIndex;
      widget.updateDropPreview((dropIndex!, widget.panel));
    }
  }
}
