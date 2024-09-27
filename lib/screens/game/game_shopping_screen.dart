import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:math_game/configs/configs.dart';
import 'package:math_game/controller/controllers.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/screens/game/game_list_screen.dart';
import 'package:math_game/utils/my_button.dart';
import 'package:math_game/widget/common/progress_widgets.dart';
import 'package:math_game/widget/game/class/audio.dart';
import 'package:math_game/widget/game/class/score_cal.dart';
import 'package:math_game/widget/game/class/timer.dart';
import 'package:math_game/widget/game/widget/game_drag_and_drop_shoping/shopping_split_panels.dart';
import 'package:math_game/widget/game/widget/game_drag_and_drop_shoping/shopping_split_panels_mobie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
class GameShoppingScreen extends StatefulWidget {
  const GameShoppingScreen({super.key});

  @override
  _GameShoppingScreenState createState() => _GameShoppingScreenState();
}

class _GameShoppingScreenState extends State<GameShoppingScreen> {
  final FocusNode _resultFocusNode = FocusNode();
  final _audio = Audio();
  late VideoPlayerController _videoPlayerController;
  late ShopingSplitPanels _shopingSplitPanels;
  late ShopingSplitPanelsMobie _shopingSplitPanelsMobie;
  final TimeRecord _timeRecord = TimeRecord();

  bool showResultDialog = false;
  bool _isLoading = true;
  String gameId = 'c296495f-342e-4fd6-5d09-08dcafad932c';

  var whiteTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white);

  List<String> numberPad = [
    'XONG',
    'KHÔI PHỤC',
  ];

  int userPoint = 0;
  int userProgress = 0;
  int totalQuestion = 3;

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
      ..initialize().then((value) => {setState(() {})});
    _shopingSplitPanels = const ShopingSplitPanels();
    _shopingSplitPanelsMobie = const ShopingSplitPanelsMobie();
    delay3Seconds();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    const double thresholdWidth = 600;
    final bool isWideScreen = screenSize.width > thresholdWidth;
    FocusScope.of(context).requestFocus(_resultFocusNode);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
    return Stack(
      children: [
        Container(
          child: KeyboardListener(
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
                }
              }
            },
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 25,
                    ),
                    height: 60,
                    decoration: BoxDecoration(gradient: mainGradient(context)),
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
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fshopping%2Fshopping.png?alt=media&token=9b4c59e4-62bc-45c3-b81a-68d8978c06c3',
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: const Text(
                              'Người chơi đọc câu hỏi trên màn hình, sau đó kéo thả các món hàng vào ô chữ nhật, khi số tiền còn lại của bạn bằng với số tiền yêu cầu, nhấn nút "XONG" để kiểm tra kết quả.',
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
                    decoration: BoxDecoration(gradient: mainGradient(context)),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Kéo thả sản phẩm cho đến khi số tiền bạn có bằng với số tiền cần giữ lại theo yêu cầu',
                            style: whiteTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: isWideScreen
                        ? Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_shopping_game.png?alt=media&token=31e87e92-f432-4c3f-a661-b29f6d4cdf33'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.7),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    child: _shopingSplitPanelsMobie,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: GridView.builder(
                                      itemCount: numberPad.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding:
                                          const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1, // Số cột
                                        childAspectRatio: 4, // Tỷ lệ khung hình
                                      ),
                                      itemBuilder: (context, index) {
                                        return MyButton(
                                          child: numberPad[index],
                                          onTap: () =>
                                              buttonTapped(numberPad[index]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_shopping_game.png?alt=media&token=31e87e92-f432-4c3f-a661-b29f6d4cdf33'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    child: _shopingSplitPanelsMobie,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: GridView.builder(
                                      itemCount: numberPad.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding:
                                          const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1, // Số cột
                                        childAspectRatio: 4, // Tỷ lệ khung hình
                                      ),
                                      itemBuilder: (context, index) {
                                        return MyButton(
                                          child: numberPad[index],
                                          onTap: () =>
                                              buttonTapped(numberPad[index]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Focus(
                    focusNode: _resultFocusNode,
                    child: const SizedBox(
                      height: 0,
                      width: 0,
                    ),
                  )
                ],
              ),
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

  void _showDialogCompleted(
      String message, String lottieAsset, bool lockScreen, int userPoint) {
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
    try {
      if (button == 'KHÔI PHỤC') {
        setState(() {
          balance = 100;
          lastbalance = 20;
          upperItemModel.clear();
          lowerItemModel = List.from(startLowerItemModel);
          _shopingSplitPanels = const ShopingSplitPanels();
          _shopingSplitPanelsMobie = const ShopingSplitPanelsMobie();
        });
      }
      if (button == 'XONG') {
        checkResult();
      }
    } catch (e) {
      print(e);
    }
  }

  void resetGame() {
    try {
      Navigator.of(context).pop();
      setState(() {
        balance = 100;
        lastbalance = 20;
        userPoint = 0;
        userProgress = 0;
        _timeRecord.seconds = 0;
        _timeRecord.startTimer();
        upperItemModel = [];
        lowerItemModel = List<ItemModel>.from(startLowerItemModel);
        _shopingSplitPanels = const ShopingSplitPanels();
        _shopingSplitPanelsMobie = const ShopingSplitPanelsMobie();
      });
    } catch (e) {
      print(e);
    }
  }

  void backtoHome() {
    // go to GameList
    final GameController controller = Get.find();
    resetGame();
    setState(() {
      controller.shouldReset.value = true;
      Get.offAllNamed(GameListScreen.routeName);
    });
  }

  void checkResult() {
    try {
      if (upperItemModel.isEmpty) {
        _showDialogError('Bạn chưa chọn sản phẩm nào!');
        return;
      }

      userProgress += 1;
      setState(() {
        showResultDialog = true;
      });
      if (balance == lastbalance) {
        userPoint += 1;
        _audio.playSuccessSound();
        ();
        if (userProgress == totalQuestion) {
          _audio.playCompleteSound();
          ();
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
          ();
          String lottieAsset = _getLottieAsset(userPoint);
          _timeRecord.stopTimer();
          _showDialogCompleted('Xin chúc mừng bạn đã hoàn thành trò chơi!',
              lottieAsset, false, userPoint);
          return;
        }
        _audio.playWrongSound();
        ();
        _showDialog('Sai rồi!', 'assets/lotties/wrong.json', false, true, true);
      }
    } catch (e) {
      print(e);
    }
  }

  String _getLottieAsset(int userPoint) {
    print(userPoint);
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
    try {
      if (showResultDialog) {
        Navigator.of(context).pop();
        setState(() {
          balance = 100;
          lastbalance = 20;
          upperItemModel.clear();
          lowerItemModel = List.from(startLowerItemModel);
          _shopingSplitPanels = const ShopingSplitPanels();
          _shopingSplitPanelsMobie = const ShopingSplitPanelsMobie();
        });
        setState(() {
          showResultDialog = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void delay3Seconds() {
    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool showGuide = prefs.getBool('showGuideGameShopping') ?? true;

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
                            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fshopping%2Fshopping.png?alt=media&token=9b4c59e4-62bc-45c3-b81a-68d8978c06c3',
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: const Text(
                              'Người chơi đọc câu hỏi trên màn hình, sau đó kéo thả các món hàng vào ô chữ nhật, khi số tiền còn lại của bạn bằng với số tiền yêu cầu, nhấn nút "XONG" để kiểm tra kết quả.',
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
                        prefs.setBool('showGuideGameShopping', false);
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
    });
  }
}
