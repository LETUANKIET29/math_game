import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_game/widget/game/widget/game_sort%20numbers/my_draggable_widget.dart';
import 'package:math_game/widget/game/widget/game_sort%20numbers/types.dart';
import 'package:dotted_border/dotted_border.dart';

class ItemPanel extends StatelessWidget {
  const ItemPanel({
    super.key,
    required this.crossAxisCount,
    required this.dragStart,
    required this.dropPreview,
    required this.hoveringData,
    required this.items,
    required this.onDragStart,
    required this.panel,
    required this.spacing,
  });

  final int crossAxisCount;
  final PanelLocation? dragStart;
  final PanelLocation? dropPreview;
  final int? hoveringData;
  final List<int> items;
  final double spacing;

  final Function(PanelLocation) onDragStart;
  final Panel panel;

  @override
  Widget build(BuildContext context) {
    final itemCopy = List<int>.from(items);

    PanelLocation? dragStartCopy;

    PanelLocation? dropPreviewCopy;

    if (dragStart != null) {
      dragStartCopy = dragStart!.copyWith();
    }

    if (dropPreview != null && hoveringData != null) {
      dropPreviewCopy = dropPreview!.copyWith(
        index: min(items.length, dropPreview!.$1),
      );

      if (dragStartCopy?.$2 == dropPreviewCopy.$2) {
        itemCopy.removeAt(dragStartCopy!.$1);
        dragStartCopy = null;
      }
      itemCopy.insert(
        min(dropPreview!.$1, itemCopy.length),
        hoveringData!,
      );
    }

    return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: const EdgeInsets.all(4),
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        children: items.asMap().entries.map<Widget>((MapEntry<int, int> entry) {
          Color textColor =
              entry.key == dragStartCopy?.$1 || entry.key == dropPreviewCopy?.$1
                  ? Colors.grey
                  : Colors.white;

          Widget child = Center(
            child: Text(
              entry.value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 36, color: textColor),
            ),
          );

          if (entry.key == dragStartCopy?.$1) {
            child = Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: child,
            );
          } else if (entry.key == dropPreviewCopy?.$1) {
            child = DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(20),
              dashPattern: const [10, 10],
              color: Colors.grey,
              strokeWidth: 2,
              child: child,
            );
          } else {
            child = Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: child,
            );
          }

          return Draggable(
            feedback: child,
            child: MyDraggableWidget(
              data: entry.value.toString(),
              onDragStart: () => onDragStart((entry.key, panel)),
              child: child,
            ),
          );
        }).toList());
  }
}
