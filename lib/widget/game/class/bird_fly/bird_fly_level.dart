import 'dart:math';

import 'package:math_game/widget/game/class/bird_fly/bird_fly_user.dart';

String currentQuestionType = '';
String currentQuestionOperator = '';
int randomIndex = 0;
List<String> animals = [
  'bluebird',
  'redbird',
];

Future<void> generateQuestion(int currentLevel) async {
  randomIndex = Random().nextInt(3);
  if (currentLevel == 1) {
    // Level 1: Only counting questions
    switch (randomIndex) {
      case 0:
        currentQuestionType = 'bluebird';
        question = 'Số lượng chim xanh là số chẵn hay số lẻ ?';
        break;
      case 1:
        currentQuestionType = 'redbird';
        question = 'Số lượng chim đỏ là số chẵn hay số lẻ ?';
        break;
      case 2:
        currentQuestionType = 'all';
        question = 'Số lượng chim trên màn hình là số chẵn hay số lẻ ?';
        break;
    }
  } else if (currentLevel == 2) {
    question = 'Số lượng chim xanh lớn hơn, nhỏ hơn hay bằng với số lượng chim đỏ ?';
  } 
}