import 'package:intl/intl.dart';

String formatPrice(int price) {
  int adjustedPrice = price * 1000;

  final formatter = NumberFormat("#,###");
  return "${formatter.format(adjustedPrice)}đ";
}
