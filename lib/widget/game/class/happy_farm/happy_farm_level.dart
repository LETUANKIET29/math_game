import 'dart:math';

import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/class/happy_farm/happy_farm_user.dart';

String currentQuestionType = '';
String currentQuestionOperator = '';
int randomIndex = 0;
List<String> animals = [
  'chicken',
  'duck',
];

Future<void> generateQuestion(int currentLevel) async {
  randomIndex = Random().nextInt(2);
  if (currentLevel == 1) {
    // Level 1: Only counting questions
    switch (randomIndex) {
      case 0:
        currentQuestionType = 'chicken';
        question = 'Có bao nhiêu con gà ?';
        break;
      case 1:
        currentQuestionType = 'duck';
        question = 'Có bao nhiêu con vịt ?';
        break;
    }
  } else if (currentLevel == 2) {
    // Level 2: Addition and Subtraction with different animal types
    String animal1 = animals[Random().nextInt(animals.length)];
    String animal2 = animals[Random().nextInt(animals.length)];
    while (animal1 == animal2) {
      animal2 = animals[Random().nextInt(animals.length)];
    }
    currentQuestionOperator = getRandomOperatorLevel2();
    if (currentQuestionOperator == '-') {
      int num1 = getAnimalCountByType(animal1);
      int num2 = getAnimalCountByType(animal2);
      if (num1 < num2) {
        String temp = animal1;
        animal1 = animal2;
        animal2 = temp;
      }
    }
    question =
        'Số lượng ${getDisplayAnimalName(animal1)} ${getDisplayOperator(currentQuestionOperator)} số lượng ${getDisplayAnimalName(animal2)} là ';
    currentQuestionType = '$animal1 $currentQuestionOperator $animal2';
  } else if (currentLevel == 3) {
    // Level 3: Addition, Subtraction, Multiplication, and Division with different animal types
    String animal1 = animals[Random().nextInt(animals.length)];
    String animal2 = animals[Random().nextInt(animals.length)];
    while (animal1 == animal2) {
      animal2 = animals[Random().nextInt(animals.length)];
    }
    currentQuestionOperator = getRandomOperatorLevel3();
    if (currentQuestionOperator == '-') {
      int num1 = getAnimalCountByType(animal1);
      int num2 = getAnimalCountByType(animal2);
      if (num1 < num2) {
        String temp = animal1;
        animal1 = animal2;
        animal2 = temp;
      }
    }
    question =
        'Số lượng ${getDisplayAnimalName(animal1)} ${getDisplayOperator(currentQuestionOperator)} số lượng ${getDisplayAnimalName(animal2)} là ';
    currentQuestionType = '$animal1 $currentQuestionOperator $animal2';
  }
}

String getRandomOperatorLevel2() {
  //List<String> operators = ['+', '-'];
  List<String> operators = ['+', '-'];
  return operators[Random().nextInt(operators.length)];
}

String getRandomOperatorLevel3() {
  List<String> operators = ['+', '-', '*', '/'];
  //List<String> operators = ['/', '/', '/', '/'];
  return operators[Random().nextInt(operators.length)];
}

int calculateAnswerLevel2(int num1, int num2, String operator) {
  switch (operator) {
    case '+':
      return num1 + num2;
    case '-':
      if (num1 < num2) {
        return num2 - num1;
      }
      return num1 - num2;
    default:
      throw ArgumentError('Invalid operator for Level 2');
  }
}

int calculateAnswerLevel3(int num1, int num2, String operator) {
  switch (operator) {
    case '+':
      return num1 + num2;
    case '-':
      return num1 - num2;
    case '*':
      return num1 * num2;
    case '/':
      if (num2 == 0) {
        throw ArgumentError('Division by zero is not allowed');
      }
      return num1 ~/ num2;
    case '%':
      return num1 % num2;
    default:
      throw ArgumentError('Invalid operator for Level 3');
  }
}

String getDisplayOperator(String operator) {
  switch (operator) {
    case '+':
      return 'cộng với';
    case '-':
      return 'trừ đi';
    case '*':
      return 'nhân với';
    case '/':
      return 'chia cho';
    default:
      throw ArgumentError('Invalid operator');
  }
}

int getAnimalCountByType(String animal) {
  switch (animal) {
    case 'chicken':
      return globalChickenCount;
    case 'duck':
      return globalDuckCount;
    default:
      throw ArgumentError('Invalid animal type');
  }
}

String getDisplayAnimalName(String animal) {
  switch (animal) {
    case 'chicken':
      return 'con gà';
    case 'duck':
      return 'con vịt';
    default:
      throw ArgumentError('Invalid animal type');
  }
}

String getAnimalFromOperator(String operator, String position) {
  List<String> parts = operator.split(' ');
  if (position == 'first') {
    return parts[0];
  } else {
    return parts[parts.length - 1];
  }
}
