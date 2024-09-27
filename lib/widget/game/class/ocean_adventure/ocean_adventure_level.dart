import 'dart:math';

import 'package:math_game/model/game_model.dart';
import 'package:math_game/widget/game/class/ocean_adventure/ocean_adventure_user.dart';

String currentQuestionType = ''; // To track the type of animal
String currentQuestionOperator = '';
int randomIndex = 0;
List<String> animals = [
  'bluefish',
  'redfish',
  'violetfish',
  'moonfish',
  'octopus'
];

void generateQuestion(int currentLevel) async {
  randomIndex = Random().nextInt(5);
  if (currentLevel == 1) {
    switch (randomIndex) {
      case 0:
        currentQuestionType = 'bluefish';
        question = 'Có bao nhiêu con cá màu xanh dương ?';
        break;
      case 1:
        currentQuestionType = 'redfish';
        question = 'Có bao nhiêu con cá màu đỏ ?';
        break;
      case 2:
        currentQuestionType = 'violetfish';
        question = 'Có bao nhiêu con cá màu tím ?';
        break;
      case 3:
        currentQuestionType = 'moonfish';
        question = 'Có bao nhiêu con cá ngựa xanh lá ?';
        break;
      case 4:
        currentQuestionType = 'octopus';
        question = 'Có bao nhiêu con bạch tuộc ?';
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
      int count1 = getAnimalCountByType(animal1);
      int count2 = getAnimalCountByType(animal2);
      if (count1 < count2) {
        String tempAnimal = animal1;
        animal1 = animal2;
        animal2 = tempAnimal;
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
      int count1 = getAnimalCountByType(animal1);
      int count2 = getAnimalCountByType(animal2);
      if (count1 < count2) {
        String tempAnimal = animal1;
        animal1 = animal2;
        animal2 = tempAnimal;
      }
    }
    question =
        'Số lượng ${getDisplayAnimalName(animal1)} ${getDisplayOperator(currentQuestionOperator)} số lượng ${getDisplayAnimalName(animal2)} là ';
    currentQuestionType = '$animal1 $currentQuestionOperator $animal2';
  }
}

String getRandomOperatorLevel2() {
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
    case 'bluefish':
      return globalBlueFishCount;
    case 'redfish':
      return globalRedFishCount;
    case 'violetfish':
      return globalVioletFishCount;
    case 'moonfish':
      return globalMoonFishCount;
    case 'octopus':
      return globalOctopusCount;
    default:
      throw ArgumentError('Invalid animal type');
  }
}

String getDisplayAnimalName(String animal) {
  switch (animal) {
    case 'bluefish':
      return 'cá màu xanh dương';
    case 'redfish':
    
      return 'cá màu đỏ';
    case 'violetfish':
      return 'cá màu tím';
    case 'moonfish':
      return 'cá ngựa xanh lá';
    case 'octopus':
      return 'bạch tuộc';
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
