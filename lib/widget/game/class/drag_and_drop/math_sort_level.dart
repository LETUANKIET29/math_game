import 'dart:math';

import 'package:math_game/widget/game/class/drag_and_drop/math_sort_user.dart';

List<int> upper = [];
List<int> lower = [];
List<int> startLower = [];

final Set<int> uniqueNumbers = {};
final Random random = Random();
String sortingOrder = '';

void randomNumber(int currentLevel) {
  if (currentLevel == 1){
    while (uniqueNumbers.length < 10) {
      uniqueNumbers.add(random.nextInt(10) + 1);
    }
  }
  if (currentLevel == 2){
    while (uniqueNumbers.length < 10) {
      uniqueNumbers.add(random.nextInt(99) + 1);
    }
  }
  if (currentLevel == 3){
    while (uniqueNumbers.length < 10) {
      uniqueNumbers.add(random.nextInt(999) + 1);
    }
  }
  startLower.addAll(uniqueNumbers);
  lower = startLower;
}

void resetGameSortNumber(int currentLevel) {
  upper.clear();
  lower.clear();
  startLower.clear();
  uniqueNumbers.clear();
  randomNumber(currentLevel);
}

void generateSortingQuestion() {
  bool isAscending = Random().nextBool();
  if (isAscending) {
    question = 'Sắp xếp dãy số theo thứ tự tăng dần';
    sortingOrder = 'ascending';
  } else {
    question = 'Sắp xếp dãy số theo thứ tự giảm dần';
    sortingOrder = 'descending';
  }
}
