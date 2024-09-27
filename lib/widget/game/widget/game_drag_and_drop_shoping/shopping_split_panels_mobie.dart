import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/class/audio.dart';

class ShopingSplitPanelsMobie extends StatefulWidget {
  const ShopingSplitPanelsMobie({super.key});

  @override
  State<ShopingSplitPanelsMobie> createState() =>
      _ShopingSplitPanelsMobieState();
}

class _ShopingSplitPanelsMobieState extends State<ShopingSplitPanelsMobie> {
  final Audio _audio = Audio();
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

  var whiteTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white);

  bool? wasUpperList;
  ItemModel? draggedProduct;
  void onDragStart(ItemModel product) {
    _audio.playMouseClickSound();
    setState(() {
      // Lưu vị trí và danh sách trước đó của mục được kéo
      draggedProduct = product;
      wasUpperList = upperItemModel.contains(product);
    });
  }

  void onDrop(ItemModel product, bool isUpper) {
    setState(() {
      // Loại bỏ mục khỏi danh sách tạm thời
      upperItemModel.remove(product);
      lowerItemModel.remove(product);
      // Điều kiện 1: Kiểm tra số dư
      if (isUpper && balance - product.price < 0) {
        _showDialog('Số tiền không đủ');
        // Thêm lại mục vào danh sách trước đó nếu số dư không đủ
        if (wasUpperList == true) {
          _audio.playDropSound();
          upperItemModel.add(draggedProduct!);
        } else {
          _audio.playDropSound();
          lowerItemModel.add(draggedProduct!);
        }
        return;
      }

      // Điều kiện 2: Giới hạn số lượng item
      if (isUpper && upperItemModel.length >= 10) {
        _showDialog('Số lượng vượt quá 10');
        // Thêm lại mục vào danh sách trước đó nếu số lượng vượt quá
        if (wasUpperList == true) {
          _audio.playDropSound();
          upperItemModel.add(draggedProduct!);
        } else {
          _audio.playDropSound();
          lowerItemModel.add(draggedProduct!);
        }
        return;
      }

      // Kiểm tra nếu mục được thả vào cùng danh sách thì không làm gì
      if ((isUpper && wasUpperList == true) ||
          (!isUpper && wasUpperList == false)) {
        // Thêm lại mục vào danh sách trước đó
        if (wasUpperList == true) {
          _audio.playDropSound();
          upperItemModel.add(draggedProduct!);
        } else {
          _audio.playDropSound();
          lowerItemModel.add(draggedProduct!);
        }
        return;
      }

      // Nếu mục được thả vào danh sách mới, cập nhật danh sách và số dư
      if (isUpper) {
        _audio.playDropSound();
        upperItemModel.add(product);
        balance -= product.price;
      } else {
        _audio.playDropSound();
        lowerItemModel.add(product);
        balance += product.price;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Số tiền bạn có: $balance \$',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Số tiền giữ lại theo yêu cầu: $lastbalance \$',
                      style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
            child: DragDropList(
              products: upperItemModel,
              onDragStart: onDragStart,
              onDrop: (product) => onDrop(product, true),
              isUpper: true,
            ),
          ),
        ),
        
        Expanded(
          flex: 2,
          child: DragDropList(
            products: lowerItemModel,
            onDragStart: onDragStart,
            onDrop: (product) => onDrop(product, false),
            isUpper: false,
          ),
        ),
      ],
    );
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
}

class DragDropList extends StatelessWidget {
  const DragDropList({
    super.key,
    required this.products,
    required this.onDragStart,
    required this.onDrop,
    required this.isUpper,
  });

  final List<ItemModel> products;
  final void Function(ItemModel) onDragStart;
  final void Function(ItemModel) onDrop;
  final bool isUpper;

  @override
  Widget build(BuildContext context) {
    return DragTarget<ItemModel>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (data) => onDrop(data.data),
      builder: (context, candidateData, rejectedData) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10, // Số lượng mục trong một hàng
            mainAxisSpacing: 1, // Khoảng cách giữa các hàng
            crossAxisSpacing: 1, // Khoảng cách giữa các cột
            childAspectRatio: 0.8, // Tỷ lệ chiều rộng/chiều cao của mục
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Draggable<ItemModel>(
              data: product,
              onDragStarted: () => onDragStart(product),
              feedback: ShoppingCartItem(
                product: product,
                isDragging: true,
              ),
              childWhenDragging: Container(),
              child: ShoppingCartItem(
                product: product,
                isDragging: false,
              ),
            );
          },
        );
      },
    );
  }
}

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem(
      {super.key, required this.product, required this.isDragging});

  final ItemModel product;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: FittedBox(
        child: Column(
          children: [
            Image.network(
              product.imageurl ?? '',
              scale: 1,
            ),
            Text('\$${product.price}',
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none)),
                    const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
