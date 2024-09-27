import 'dart:math';

import 'package:math_game/widget/game/class/math_game/math_game_user.dart';

List<int> values = [];
String? operator;
Fraction? correctAnswer;
List<Fraction> choice = [];
bool isAnswered = false;
bool isCorrect = false;
String currentQuestionType = '';
String currentQuestionOperator = '';
String formattedQuestion = '';

class Fraction {
  int numerator;
  int denominator;

  Fraction(this.numerator, this.denominator) {
    _reduce();
  }

  void _reduce() {
    int gcd = _gcd(numerator, denominator);
    numerator ~/= gcd;
    denominator ~/= gcd;
  }

  int _gcd(int a, int b) {
    return b == 0 ? a : _gcd(b, a % b);
  }

  Fraction operator +(Fraction other) {
    int num = numerator * other.denominator + other.numerator * denominator;
    int den = denominator * other.denominator;
    return Fraction(num, den);
  }

  Fraction operator -(Fraction other) {
    int num = numerator * other.denominator - other.numerator * denominator;
    int den = denominator * other.denominator;
    return Fraction(num, den);
  }

  Fraction operator *(Fraction other) {
    return Fraction(
        numerator * other.numerator, denominator * other.denominator);
  }

  Fraction operator /(Fraction other) {
    return Fraction(
        numerator * other.denominator, denominator * other.numerator);
  }

  @override
  String toString() {
    return denominator == 1 ? "$numerator" : "$numerator/$denominator";
  }
}

void restartGame(int level) {
  nextQuestion(level);
  userPoint = 0;
  userProgress = 0;
}

void nextQuestion(int level) {
  bool validQuestion = false;
  List<String> operators = [];

  while (!validQuestion) {
    int numCount =
        level + 1; // Level 1: 2 numbers, Level 2: 3 numbers, Level 3: 4 numbers
    values = getRandomValues(numCount);
    List<String> operators = getRandomOperators(numCount - 1, level);

    if (operators.contains('-')) {
      values.sort((a, b) => b.compareTo(
          a)); // Sort values in descending order if subtraction is involved
    }

    correctAnswer = calculateAnswer(values, operators);
    // Check if the answer is negative
    if (correctAnswer!.numerator >= 0) {
      validQuestion = true;
    }
    formatQuestion(values, operators); // Update the formatted question string
  }

  choice.clear();
  choice.add(correctAnswer!);
  for (int i = 0; i < 2; i++) {
    if (operators.contains('/')) {
      choice.add(Fraction(Random().nextInt(50) + 1, Random().nextInt(50) + 1));
    } else {
      choice.add(Fraction(Random().nextInt(50) + 1, 1));
    }
  }
  choice.shuffle();
}

List<String> getRandomOperators(int operatorCount, int level) {
  List<String> operators = ['+', '-'];
  if (level >= 2) {
    operators.add('*');
    operators.add('/');
  }
  List<String> selectedOperators = [];
  for (int i = 0; i < operatorCount; i++) {
    selectedOperators.add(operators[Random().nextInt(operators.length)]);
  }
  return selectedOperators;
}

Fraction calculateAnswer(List<int> nums, List<String> operators) {
  Fraction result = Fraction(nums[0], 1);
  for (int i = 0; i < operators.length; i++) {
    Fraction current = Fraction(nums[i + 1], 1);
    switch (operators[i]) {
      case '+':
        result = result + current;
        break;
      case '-':
        result = result - current;
        break;
      case '*':
        result = result * current;
        break;
      case '/':
        result = result / current;
        break;
      default:
        throw ArgumentError('Invalid operator');
    }
  }
  return result;
}

List<int> getRandomValues(int numCount) {
  List<int> values = [];
  for (int i = 0; i < numCount; i++) {
    values.add(Random().nextInt(50) + 5);
  }
  return values;
}

String formatQuestion(List<int> values, List<String> operators) {
  String question = values[0].toString();
  for (int i = 0; i < operators.length; i++) {
    question += " ${operators[i]} ${values[i + 1]}";
  }
  formattedQuestion = question;
  return formattedQuestion;
}
