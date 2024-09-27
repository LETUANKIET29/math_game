import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/widget/game_drag_and_drop_shoping/item_panel_shopphing.dart';
import 'package:math_game/widget/game/widget/game_drag_and_drop_shoping/shopping_drop_region.dart';
import 'package:math_game/widget/game/widget/game_sort%20numbers/types.dart';

class ShopingSplitPanels extends StatefulWidget {
  const ShopingSplitPanels(
      {super.key, this.itemSpacing = 4.0});

  final double itemSpacing;

  @override
  State<ShopingSplitPanels> createState() => _ShopingSplitPanelsState();
}

class _ShopingSplitPanelsState extends State<ShopingSplitPanels> {
  late int columns;
  @override
  void initState() {
    super.initState();
    balance = 100;
    lastbalance = 20;
    upperItemModel.clear();
    lowerItemModel.clear();
    lowerItemModel.addAll(startLowerItemModel);
  }

  PanelLocation? dragStart;
  PanelLocation? dropPreview;
  ItemModel? hoveringData;
  var whiteTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white);

  void onDragStart(PanelLocation start) {
    final data = switch (start.$2) {
      Panel.lower => lowerItemModel[start.$1],
      Panel.upper => upperItemModel[start.$1],
    };
    setState(() {
      dragStart = start;
      hoveringData = data;
    });
  }

  void drop() {
    try {
      assert(dropPreview != null, 'Can only drop over a known location');
      assert(hoveringData != null, 'Can only drop when data is being dragged');
      setState(() {
        if (dragStart!.$2 == Panel.lower && balance - hoveringData!.price < 0) {
          _showDialog('Số tiền không đủ');
          return;
        }
        if (upperItemModel.length >= 10 && dragStart!.$2 == Panel.lower) {
          _showDialog('Số lượng vượt quá 10');
          return;
        }
        if (dragStart != null) {
          if (dragStart!.$2 == dropPreview!.$2) {
            return;
          }

          if (dragStart!.$2 == Panel.upper) {
            upperItemModel.removeAt(dragStart!.$1);
            balance += hoveringData!.price;
          } else {
            lowerItemModel.removeAt(dragStart!.$1);
            balance -= hoveringData!.price;
          }
        }
        if (dropPreview!.$2 == Panel.upper) {
          upperItemModel.insert(
              min(dropPreview!.$1, upperItemModel.length), hoveringData!);
        } else {
          lowerItemModel.insert(
              min(dropPreview!.$1, lowerItemModel.length), hoveringData!);
        }
        dragStart = null;
        dropPreview = null;
        hoveringData = null;
      });
    } catch (e) {
      return;
    }
  }

  void setExternalData(ItemModel data) => hoveringData = data;

  void updateDropPreview(PanelLocation update) {
    setState(() {
      dropPreview = update;
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          content: IntrinsicHeight(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepPurple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    message,
                    style: whiteTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (MediaQuery.of(context).size.width < 1100 || MediaQuery.of(context).size.height < 800) {
        columns = 8;
      } else if (MediaQuery.of(context).size.width < 1200 ||
          MediaQuery.of(context).size.height < 850) {
        columns = 8;
      } else if (MediaQuery.of(context).size.width < 1400 ||
          MediaQuery.of(context).size.height < 900) {
        columns = 9;
      } else if (MediaQuery.of(context).size.width < 1600 ||
          MediaQuery.of(context).size.height < 1000) {
        columns = 10;
      } else {
        columns = 10;
      }
      final gutters = columns + 1;
      final spaceForColumns =
          constraints.maxWidth - (widget.itemSpacing * gutters);
      final columnWidth = spaceForColumns / columns;
      final itemSize = Size(columnWidth, columnWidth);

      return Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số tiền bạn có: $balance \$',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  'Số tiền giữ lại theo yêu cầu: $lastbalance \$',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
              height: constraints.maxHeight / 2,
              width: constraints.maxWidth,
              top: 100,
              child: MyDropRegion(
                onDrop: drop,
                setExternalData: setExternalData,
                updateDropPreview: updateDropPreview,
                columns: columns,
                childSize: itemSize,
                panel: Panel.upper,
                child: ItemPanelShopping(
                  crossAxisCount: columns,
                  dragStart: dragStart?.$2 == Panel.upper ? dragStart : null,
                  dropPreview:
                      dropPreview?.$2 == Panel.upper ? dropPreview : null,
                  hoveringData:
                      dropPreview?.$2 == Panel.upper ? hoveringData : null,
                  spacing: widget.itemSpacing,
                  items: upperItemModel,
                  onDragStart: onDragStart,
                  panel: Panel.upper,
                ),
              )),
          Positioned(
            height: 2,
            width: constraints.maxWidth,
            top: constraints.maxHeight / 2,
            child: const ColoredBox(
              color: Colors.black,
            ),
          ),
          Positioned(
            height: constraints.maxHeight / 2,
            width: constraints.maxWidth,
            bottom: 0,
            child: MyDropRegion(
              onDrop: drop,
              setExternalData: setExternalData,
              updateDropPreview: updateDropPreview,
              columns: columns,
              childSize: itemSize,
              panel: Panel.lower,
              child: ItemPanelShopping(
                crossAxisCount: columns,
                dragStart: dragStart?.$2 == Panel.lower ? dragStart : null,
                dropPreview:
                    dropPreview?.$2 == Panel.lower ? dropPreview : null,
                hoveringData:
                    dropPreview?.$2 == Panel.lower ? hoveringData : null,
                items: lowerItemModel,
                onDragStart: onDragStart,
                panel: Panel.lower,
                spacing: widget.itemSpacing,
              ),
            ),
          )
        ],
      );
    });
  }
}
