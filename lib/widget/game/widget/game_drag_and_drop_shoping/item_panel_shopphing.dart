import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/widget/game_drag_and_drop_shoping/shopping_draggable_widget.dart';
import 'package:math_game/widget/game/widget/game_sort%20numbers/types.dart';

class ItemPanelShopping extends StatelessWidget {
  const ItemPanelShopping({
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
  final ItemModel? hoveringData;
  final List<ItemModel> items;
  final double spacing;
  final Function(PanelLocation) onDragStart;
  final Panel panel;

  @override
  Widget build(BuildContext context) {
    final itemCopy = List<ItemModel>.from(items);

    PanelLocation? dragStartCopy;
    PanelLocation? dropPreviewCopy;

    double fontSize;
    if (MediaQuery.of(context).size.width < 1100 || MediaQuery.of(context).size.height < 800) {
      fontSize = 16;
    } else if (MediaQuery.of(context).size.width < 1200 ||
        MediaQuery.of(context).size.height < 850) {
      fontSize = 22;
    } else if (MediaQuery.of(context).size.width < 1400 ||
        MediaQuery.of(context).size.height < 1100) {
      fontSize = 30;
    } else if (MediaQuery.of(context).size.width < 1600 ||
        MediaQuery.of(context).size.height < 1200) {
      fontSize = 36;
    } else {
      fontSize = 40;
    }

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
      children: items.asMap().entries.map<Widget>((MapEntry<int, ItemModel> entry) {
        Color textColor =
            entry.key == dragStartCopy?.$1 || entry.key == dropPreviewCopy?.$1
                ? Colors.grey
                : Colors.white;

        Widget child = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform.scale(
                scale: 2.0, // Doubles the size of the child
                child: Image.network(
                  entry.value.imageurl ?? 'https://via.placeholder.com/150',
                ),
              ),
              Text(
                '${entry.value.price} \$',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize, color: textColor),
              ),
            ],
          ),
        );

        if (entry.key == dragStartCopy?.$1) {
          child = Container(
            child: child,
          );
        } else if (entry.key == dropPreviewCopy?.$1) {
          child = DottedBorder(
            child: child,
          );
        } else {
          child = Container(
            child: child,
          );
        }

        return Draggable(
          feedback: Material(
            color: Colors.transparent,
            child: child,
          ),
          child: MyDraggableWidget(
            data: entry.value.imageurl ??
                'gs://beanmind-2911.appspot.com/item_game_images/item_store_002.png',
            onDragStart: () => onDragStart((entry.key, panel)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.scale(
                    scale: 2.0, // Doubles the size of the child
                    child: Image.network(
                      entry.value.imageurl ??
                          'https://via.placeholder.com/150',
                    ),
                  ),
                  Text(
                    '${entry.value.price} \$',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: fontSize, color: textColor),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
