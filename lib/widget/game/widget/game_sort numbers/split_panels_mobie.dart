import 'package:flutter/material.dart';
import 'package:math_game/widget/game/class/audio.dart';
import 'package:math_game/widget/game/class/drag_and_drop/math_sort_level.dart';
import 'package:math_game/widget/game/class/drag_and_drop/math_sort_user.dart';

class SplitPanelsMobie extends StatefulWidget {
  final int level;
  const SplitPanelsMobie(
      {super.key,
      this.columns = 10,
      this.itemSpacing = 4.0,
      required this.level});

  final int columns;
  final double itemSpacing;

  @override
  State<SplitPanelsMobie> createState() => _SplitPanelsMobieState();
}

class _SplitPanelsMobieState extends State<SplitPanelsMobie> {
  final Audio _audio = Audio();
  @override
  void initState() {
    super.initState();
    upper.clear();
    lower.clear();
    randomNumber(widget.level);
  }

  var whiteTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white);

  bool? wasUpperList;
  int? draggedProduct;
  void onDragStart(int product) {
    _audio.playMouseClickSound();
    setState(() {
      // Lưu vị trí và danh sách trước đó của mục được kéo
      draggedProduct = product;
      wasUpperList = upper.contains(product);
    });
  }

  void onDrop(int product, bool isUpper) {
    setState(() {
      // Loại bỏ mục khỏi danh sách tạm thời
      upper.remove(product);
      lower.remove(product);

      // Điều kiện 2: Giới hạn số lượng item
      if (isUpper && upper.length >= 10) {
        _showDialog('Số lượng vượt quá 10');
        // Thêm lại mục vào danh sách trước đó nếu số lượng vượt quá
        if (wasUpperList == true) {
          _audio.playDropSound();
          upper.add(draggedProduct!);
        } else {
          _audio.playDropSound();
          lower.add(draggedProduct!);
        }
        return;
      }

      // Kiểm tra nếu mục được thả vào cùng danh sách thì không làm gì
      if ((isUpper && wasUpperList == true) ||
          (!isUpper && wasUpperList == false)) {
        // Thêm lại mục vào danh sách trước đó
        if (wasUpperList == true) {
          _audio.playDropSound();
          upper.add(draggedProduct!);
        } else {
          _audio.playDropSound();
          lower.add(draggedProduct!);
        }
        return;
      }

      // Nếu mục được thả vào danh sách mới, cập nhật danh sách và số dư
      if (isUpper) {
        _audio.playDropSound();
        upper.add(product);
      } else {
        _audio.playDropSound();
        lower.add(product);
      }

      if (upper.length == 10) {
        numberPad = [
          'XONG',
          'KHÔI PHỤC',
        ];
      } else {
        numberPad = [
          'KIỂM TRA',
          'KHÔI PHỤC',
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double baseScreenWidth =
        1100; // Chiều rộng cơ bản mà bạn muốn bắt đầu từ 17 cột.
    double baseColumns = 14; // Số cột cho chiều rộng cơ bản.

// Tính toán tỉ lệ giữa chiều rộng màn hình hiện tại và chiều rộng cơ bản.
    double ratio = screenWidth / baseScreenWidth;

// Tính toán số cột dựa trên tỉ lệ. Bạn có thể làm tròn số này để có số cột nguyên.
    int columns = (baseColumns * ratio).round();

// Đảm bảo rằng số cột không vượt quá một giới hạn nhất định nếu cần.
    columns = columns.clamp(13, 14); // Giới hạn số cột từ 13 đến 17.
    double size = screenWidth / columns;
    return Column(
      children: <Widget>[
        Container(
          height: size + 5,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
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
            products: upper,
            onDragStart: onDragStart,
            onDrop: (product) => onDrop(product, true),
            isUpper: true,
          ),
        ),
        SizedBox(
          height: 300,
          child: DragDropList(
            products: lower,
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

  final List<int> products;
  final void Function(int) onDragStart;
  final void Function(int) onDrop;
  final bool isUpper;

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (data) => true,
      onAcceptWithDetails: (data) => onDrop(data.data),
      builder: (context, candidateData, rejectedData) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10, // Số lượng mục trong một hàng
            mainAxisSpacing: 1, // Khoảng cách giữa các hàng
            crossAxisSpacing: 1, // Khoảng cách giữa các cột
            childAspectRatio: 1, // Tỷ lệ chiều rộng/chiều cao của mục
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Draggable<int>(
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

  final int product;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columns;
    if (screenWidth < 1100) {
      columns = 20;
    } else if (screenWidth < 1200) {
      columns = 19;
    } else if (screenWidth < 1400) {
      columns = 18;
    } else if (screenWidth < 1500) {
      columns = 17;
    } else if (screenWidth < 1600) {
      columns = 16;
    } else {
      columns = 16;
    }
    double size = screenWidth / columns;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: Column(
          children: [
            Card(
              color: Colors.blue[300],
              child: Container(
                height: size,
                width: size,
                alignment: Alignment.center,
                child: Text(
                  product.toString(),
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
