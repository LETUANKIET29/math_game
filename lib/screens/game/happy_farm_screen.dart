import 'package:cached_network_image/cached_network_image.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:math_game/controller/controllers.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/screens/game/game_list_screen.dart';
import 'package:math_game/utils/my_button.dart';
import 'package:math_game/widget/common/progress_widgets.dart';
import 'package:math_game/widget/game/class/audio.dart';
import 'package:math_game/widget/game/class/happy_farm/happy_farm_level.dart';
import 'package:math_game/widget/game/class/happy_farm/happy_farm_user.dart';
import 'package:math_game/widget/game/class/score_cal.dart';
import 'package:math_game/widget/game/class/timer.dart';
import 'package:math_game/widget/game/widget/game_happy_farm/happy_farm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class HappyFarmScreen extends StatefulWidget {
  final int level;
  final String gameid;
  const HappyFarmScreen({super.key, required this.level, required this.gameid});
  @override
  _HappyFarmScreenState createState() => _HappyFarmScreenState();
}

class _HappyFarmScreenState extends State<HappyFarmScreen> {
  final FocusNode _resultFocusNode = FocusNode();
  final Audio _audio = Audio();
  late VideoPlayerController _videoPlayerController;
  late HappyFarm _happyFarm;
  final TimeRecord _timeRecord = TimeRecord();

  bool _isLoading = true;
  bool isCorrect = false;

  var whiteTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white);
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    '\u2190',
    '1',
    '2',
    '3',
    '=',
    '0',
    '/'
  ];

  List<String> numberPadMobie = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    'C',
    '\u2190',
    '/',
    '='
  ];

  @override
  void dispose() {
    _resultFocusNode.dispose();
    _videoPlayerController.dispose();
    _timeRecord.timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((value) => setState(() {}));
    userAnswer = '';
    userPoint = 0;
    userProgress = 0;
    _happyFarm = HappyFarm(level: widget.level);
    generateQuestion(widget.level);
    delay3Seconds();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isWideScreen = screenSize.width / screenSize.height > 16 / 9;
    FocusScope.of(context).requestFocus(_resultFocusNode);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
      return Stack(
        children: [
          KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent) {
                final logicalKey = event.logicalKey;
                if (logicalKey == LogicalKeyboardKey.enter) {
                  if (showResultDialog) {
                    goToNextQuestion();
                  } else {
                    checkResult();
                  }
                } else if (logicalKey == LogicalKeyboardKey.backspace) {
                  buttonTapped('\u2190');
                }
                final input = logicalKey.keyLabel;
                if (RegExp(r'^[0-9]$').hasMatch(input)) {
                  handleNumberButtonPress(input);
                }
              }
            },
            child: Scaffold(
              backgroundColor: Colors.blue[100],
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 25,
                    ),
                    height: 60,
                    color: Colors.deepPurple,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Text(
                            'Số điểm của bạn : $userPoint',
                            style: whiteTextStyle,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                title: const Text('Hướng dẫn'),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fhappy_farm%2Fhappy_farm_tutorial1.png?alt=media&token=cacc979b-d2bc-422d-bea9-bb0ae75cd7a3',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: const Text(
                                            'Tên của các loại động vật hiển thị trên màn hình',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Image.network(                              
                                          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fhappy_farm%2Fhappy_farm_tutorial2.png?alt=media&token=191df3f0-a529-4bbc-b34c-221616bbcd9e',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: const Text(
                                            'Bạn sẽ đếm số lượng các động vật hiển thị trên màn hình, đọc câu hỏi đang hiển thị và nhập kết quả',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding:
                                const EdgeInsets.all(10), // Điều chỉnh kích thước nút
                          ),
                          child: const Icon(
                            Icons.help,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 60,
                      color: Colors.deepPurple,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              question,
                              style: whiteTextStyle,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                              color: Colors.blue[100],
                              child: Text(
                                userAnswer,
                                style:
                                    whiteTextStyle.copyWith(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    child: isWideScreen
                        ? Row(
                            // desktop view
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  margin: const EdgeInsets.only(
                                      top: 15, left: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        width: 5,
                                        color: Theme.of(context)
                                            .cardColor
                                            .withAlpha(100)),
                                  ),
                                  child: Stack(
                                    children: [
                                      GameWidget(game: _happyFarm),
                                      Visibility(
                                        visible: _isLoading,
                                        child: const Center(
                                          child: ProgressWidgets(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GridView.builder(
                                    itemCount: numberPad.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio: 0.9),
                                    itemBuilder: (context, index) {
                                      return MyButton(
                                        child: numberPad[index],
                                        onTap: () => buttonTapped(numberPad[index]),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            // mobile view
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        width: 5,
                                        color: Theme.of(context)
                                            .cardColor
                                            .withAlpha(100)),
                                  ),
                                  child: Stack(
                                    children: [
                                      GameWidget(game: _happyFarm),
                                      Visibility(
                                        visible: _isLoading,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GridView.builder(
                                    itemCount: numberPadMobie.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 7,
                                            childAspectRatio: 2.2),
                                    itemBuilder: (context, index) {
                                      return MyButton(
                                        child: numberPadMobie[index],
                                        onTap: () =>
                                            buttonTapped(numberPadMobie[index]),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Focus(
                    focusNode: _resultFocusNode,
                    child: SizedBox(
                      height: 0,
                      width: 0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
          visible: _isLoading,
          child: Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: ProgressWidgets(),
            ),
          ),
        ),
        ],
      );
    
  }

  // show dialog error
  void _showDialogError(
    String message,
  ) {
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
        });
  }

  // show dialog completed
  void _showDialogCompleted(
      String message, String lottieAsset, bool lockScreens, int userPoint) {
    showDialog(
        context: context,
        barrierDismissible: lockScreens,
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
                    const SizedBox(height: 16),
                    Lottie.asset(lottieAsset, height: 100),
                    const SizedBox(height: 16),
                    Text(
                      'Số điểm của bạn: $userPoint/$totalQuestion',
                      style: whiteTextStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Thời gian hoàn thành trò chơi: ${_timeRecord.seconds} giây',
                      style: whiteTextStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Số điểm bạn đạt được: ${calculateScore(userPoint, totalQuestion, _timeRecord.seconds).toString()}',
                      style: whiteTextStyle,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: resetGame,
                          child: Row(
                            children: [
                              Text(
                                'Chơi lại ',
                                style: whiteTextStyle,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple[300],
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: backtoHome,
                          child: Row(
                            children: [
                              Text(
                                'Trở về trang chủ ',
                                style: whiteTextStyle,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple[300],
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // show dialog correct or wrong
  void _showDialog(String message, String lottieAsset, bool lockScreen,
      bool showNextQuestion, bool showVideo) {
    showDialog(
        context: context,
        barrierDismissible: lockScreen,
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
                    const SizedBox(height: 16),
                    Lottie.asset(lottieAsset, height: 100),
                    const SizedBox(height: 16),
                    if (showNextQuestion) const SizedBox(height: 16),
                    if (showNextQuestion)
                      GestureDetector(
                        onTap: goToNextQuestion,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[300],
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void buttonTapped(String button) {
    _audio.playButtonSound();
    setState(() {
      if (button == '=') {
        checkResult();
      } else if (button == 'C') {
        userAnswer = '';
      } else if (button == '\u2190') {
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 4) {
        userAnswer += button;
      }
    });
  }

  void handleNumberButtonPress(String number) {
    setState(() {
      if (userAnswer.length < 4) {
        userAnswer += number;
      }
    });
  }

  void resetGame() {
    Navigator.of(context).pop();
    setState(() {
      userAnswer = '';
      userPoint = 0;
      userProgress = 0;
      _timeRecord.seconds = 0;
      _timeRecord.startTimer();
      _happyFarm = HappyFarm(level: widget.level);
    });
  }

  void backtoHome() {
    final GameController controller = Get.find();
    resetGame();
    setState(() {
      controller.shouldReset.value = true;
      Get.offAllNamed(GameListScreen.routeName);
    });
  }

  void checkResult() {
    if (userAnswer.isEmpty) {
      _showDialogError('Bạn chưa nhập số !');
      return;
    }
    userProgress += 1;
    setState(() {
      showResultDialog = true;
    });

    if (widget.level == 1) {
      // Level 1: Counting
      if (currentQuestionType == 'chicken') {
        isCorrect = globalChickenCount == int.parse(userAnswer);
      } else if (currentQuestionType == 'duck') {
        isCorrect = globalDuckCount == int.parse(userAnswer);
      }
    } else if (widget.level == 2) {
      // Level 2: Addition and Subtraction
      List<String> questionParts = currentQuestionType.split(' ');
      int num1 = getAnimalCountByType(questionParts[0]); // First animal
      int num2 = getAnimalCountByType(questionParts[2]); // Second animal
      print('num1: $num1, num2: $num2');
      String operator = questionParts[1];
      int correctAnswer = calculateAnswerLevel2(num1, num2, operator);
      isCorrect = correctAnswer == int.parse(userAnswer);
    } else if (widget.level == 3) {
      // Level 3: Addition, Subtraction, Multiplication, and Division
      List<String> questionParts = currentQuestionType.split(' ');
      int num1 = getAnimalCountByType(questionParts[0]); // First animal
      int num2 = getAnimalCountByType(questionParts[2]); // Second animal
      print('num1: $num1, num2: $num2');
      String operator = questionParts[1];

      if (operator == '/') {
        if (userAnswer.contains('/')) {
          int correctAnswerQuotient = calculateAnswerLevel3(num1, num2, '/');
          int correctAnswerRemainder = calculateAnswerLevel3(num1, num2, '%');
          print(
              'Correct Answer: $correctAnswerQuotient, $correctAnswerRemainder');

          List<String> parts = userAnswer.split('/');
          int numerator = int.parse(parts[0]);
          int denominator = int.parse(parts[1]);
          print('$numerator / $denominator');
          // Perform integer division and modulus
          int quotient = calculateAnswerLevel3(numerator, denominator, '/');
          int remainder = calculateAnswerLevel3(numerator, denominator, '%');
          print('Quotient: $quotient, Remainder: $remainder');
          isCorrect = (quotient == correctAnswerQuotient &&
              remainder == correctAnswerRemainder);
        } else {
          int correctAnswer = calculateAnswerLevel3(num1, num2, operator);
          isCorrect = correctAnswer == int.parse(userAnswer);
        }
      } else {
        int correctAnswer = calculateAnswerLevel3(num1, num2, operator);
        isCorrect = correctAnswer == int.parse(userAnswer);
      }
    }

    if (isCorrect) {
      userPoint += 1;
      _audio.playSuccessSound();
      if (userProgress == totalQuestion) {
        _audio.playCompleteSound();
        String lottieAsset = _getLottieAsset(userPoint);
        _timeRecord.stopTimer();
        _showDialogCompleted('Xin chúc mừng bạn đã hoàn thành trò chơi!',
            lottieAsset, false, userPoint);
        return;
      }
      _showDialog(
          'Đúng rồi !', 'assets/lotties/success.json', false, true, false);
    } else {
      if (userProgress == totalQuestion) {
        _audio.playCompleteSound();
        String lottieAsset = _getLottieAsset(userPoint);
        _timeRecord.stopTimer();
        _showDialogCompleted('Xin chúc mừng bạn đã hoàn thành trò chơi!',
            lottieAsset, false, userPoint);
        return;
      }
      _audio.playWrongSound();
      _showDialog('Sai rồi!', 'assets/lotties/wrong.json', false, true, true);
    }
  }

  String _getLottieAsset(int userPoint) {
    switch (userPoint) {
      case 1:
        return 'assets/lotties/bronze_medal.json';
      case 2:
        return 'assets/lotties/silver_medal.json';
      case 3:
        return 'assets/lotties/gold_medal.json';
      default:
        return 'assets/lotties/wrong.json';
    }
  }

  void goToNextQuestion() {
    if (showResultDialog) {
      Navigator.of(context).pop();
      setState(() {
        userAnswer = '';
        _happyFarm = HappyFarm(level: widget.level);
        showResultDialog = false;
      });
    }
  }

  Future<void> delay3Seconds() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showGuide = prefs.getBool('showGuideGameHappyFarm') ?? true;

    setState(() {
      if (showGuide) {
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Hướng dẫn'),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fhappy_farm%2Fhappy_farm_tutorial1.png?alt=media&token=cacc979b-d2bc-422d-bea9-bb0ae75cd7a3',
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: const Text(
                            'Tên của các loại động vật hiển thị trên màn hình',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fhappy_farm%2Fhappy_farm_tutorial2.png?alt=media&token=191df3f0-a529-4bbc-b34c-221616bbcd9e',
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: const Text(
                            'Bạn sẽ đếm số lượng các động vật hiển thị trên màn hình, đọc câu hỏi đang hiển thị và nhập kết quả',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      prefs.setBool('showGuideGameHappyFarm', false);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      }
      _timeRecord.startTimer();
    });
  }
}
