import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:math_game/controller/controllers.dart';
import 'package:math_game/screens/game/game_list_screen.dart';
import 'package:math_game/utils/my_button.dart';
import 'package:math_game/widget/common/progress_widgets.dart';
import 'package:math_game/widget/game/class/audio.dart';
import 'package:math_game/widget/game/class/drag_and_drop/math_sort_level.dart';
import 'package:math_game/widget/game/class/drag_and_drop/math_sort_user.dart';
import 'package:math_game/widget/game/class/score_cal.dart';
import 'package:math_game/widget/game/class/timer.dart';
import 'package:math_game/widget/game/widget/game_sort%20numbers/split_panels.dart';
import 'package:math_game/widget/game/widget/game_sort%20numbers/split_panels_mobie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class MathDragAndDropScreen extends StatefulWidget {
  final int level;
  final String gameid;
  const MathDragAndDropScreen(
      {super.key, required this.level, required this.gameid});
  @override
  _MathDragAndDropScreenState createState() => _MathDragAndDropScreenState();
}

class _MathDragAndDropScreenState extends State<MathDragAndDropScreen> {
  final FocusNode _resultFocusNode = FocusNode();
  final Audio _audio = Audio();
  late VideoPlayerController _videoPlayerController;
  late SplitPanels _splitPanels;
  late SplitPanelsMobie _splitPanelsMobie;
  late final TimeRecord _timeRecord = TimeRecord();

  bool showResultDialog = false;
  bool _isLoading = true;

  int userPoint = 0;
  int userProgress = 0;
  int totalQuestion = 3;
  String userAnswer = '';
  String background =
      'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_math_sort_1.png?alt=media&token=39e27f13-3fc8-42b8-9365-0b635c9ee860';

  var whiteTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white);

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
    resetGameSortNumber(widget.level);
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((value) => {setState(() {})});
    _splitPanels = SplitPanels(level: widget.level);
    _splitPanelsMobie = SplitPanelsMobie(level: widget.level);
    generateSortingQuestion();
    delay3Seconds();
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
        Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: Container(
              key: ValueKey<String>(background),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      background), // Thay 'url' bằng đường dẫn URL thực tế của hình ảnh
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 25,
                    ),
                    height: 60,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        children: [
                                          Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fdrag_and_drop%2Fsort_number.png?alt=media&token=884f4329-308e-4023-ae95-a08ccb4bdde8',
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
                                              'Người chơi đọc câu hỏi trên màn hình, sau đó kéo thả các thẻ số theo đề bài yêu cầu, khi đã sắp xếp đúng thứ tự, nhấn nút "XONG" để kiểm tra kết quả.',
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
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            question,
                            style: whiteTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: isWideScreen
                        ? Container(
                            padding: const EdgeInsets.all(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    alignment: Alignment.topCenter,
                                    child: _splitPanelsMobie,
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
                        : Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: _splitPanelsMobie,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: GridView.builder(
                                    itemCount: numberPad.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      'Số câu trả lời đúng: $userPoint/$totalQuestion',
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
    setState(() {
      if (button == 'XONG' || button == 'KIỂM TRA') {
        checkResult();
      } else if (button == 'KHÔI PHỤC') {
        upper.clear();
        lower = List.from(startLower);
        _splitPanels = SplitPanels(level: widget.level);
        _splitPanelsMobie = SplitPanelsMobie(level: widget.level);
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

  void checkResult() {
    setState(() {
      showResultDialog = true;
    });

    // Check if the upper list is empty
    if (upper.isEmpty) {
      _showDialogError(
          'Bạn chưa đặt các thẻ số lên phía trên \nhãy xếp số theo thứ tự đề bài yêu cầu!');
      return;
    }

    // Check if the upper list is sorted in ascending order
    bool isSortedAscending = true;
    for (int i = 0; i < upper.length - 1; i++) {
      if (upper[i] > upper[i + 1]) {
        isSortedAscending = false;
        break;
      }
    }

    // Check if the upper list is sorted in descending order
    bool isSortedDescending = true;
    for (int i = 0; i < upper.length - 1; i++) {
      if (upper[i] < upper[i + 1]) {
        isSortedDescending = false;
        break;
      }
    }

    if (upper.length == 10) {
      userProgress += 1;
      setState(() {
        changeBackgroundColor();
      });
      if ((sortingOrder == 'ascending' && isSortedAscending) ||
          (sortingOrder == 'descending' && isSortedDescending)) {
        userPoint += 1;
        _audio.playSuccessSound();
        if (userProgress == totalQuestion) {
          _audio.playCompleteSound();
          String lottieAsset = _getLottieAsset(userPoint);
          _timeRecord.stopTimer();
          setState(() {
            resetGameSortNumber(widget.level);
          });
          _showDialogCompleted('Xin chúc mừng bạn đã hoàn thành trò chơi!',
              lottieAsset, false, userPoint);
          return;
        }
        setState(() {
          resetGameSortNumber(widget.level);
        });
        _showDialog(
            'Đúng rồi !', 'assets/lotties/success.json', false, true, false);
      } else {
        if (userProgress == totalQuestion) {
          _audio.playCompleteSound();
          String lottieAsset = _getLottieAsset(userPoint);
          _timeRecord.stopTimer();
          setState(() {
            resetGameSortNumber(widget.level);
          });
          _showDialogCompleted('Xin chúc mừng bạn đã hoàn thành trò chơi!',
              lottieAsset, false, userPoint);
          return;
        }
        setState(() {
          resetGameSortNumber(widget.level);
        });
        _showDialog(
            'Sai rồi !', 'assets/lotties/wrong.json', false, true, true);
      }
    } else if ((sortingOrder == 'ascending' && isSortedAscending) ||
        (sortingOrder == 'descending' && isSortedDescending)) {
      _showDialog(
          'Đúng rồi !', 'assets/lotties/success.json', true, false, false);
    } else {
      _audio.playWrongSound();
      _showDialog('Sai rồi !', 'assets/lotties/wrong.json', true, false, true);
    }
  }

  void goToNextQuestion() {
    if (showResultDialog) {
      Navigator.of(context).pop();
      setState(() {
        resetGameSortNumber(widget.level);
        lower = List.from(startLower);
        _splitPanels = SplitPanels(
          level: widget.level,
        );
        _splitPanelsMobie = SplitPanelsMobie(
          level: widget.level,
        );
        userAnswer = '';
        generateSortingQuestion();
      });
      setState(() {
        showResultDialog = false;
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
  }

  void resetGame() {
    Navigator.of(context).pop();
    setState(() {
      userPoint = 0;
      userProgress = 0;
      resetGameSortNumber(widget.level);
      _timeRecord.seconds = 0;
      _timeRecord.startTimer();
      _splitPanels = SplitPanels(
        level: widget.level,
      );
      _splitPanelsMobie = SplitPanelsMobie(
        level: widget.level,
      );
      generateSortingQuestion();
      changeBackgroundColor();
    });
  }

  void backtoHome() {
    // go to GameList
    final GameController controller = Get.find();
    setState(() {
      controller.shouldReset.value = true;
      Get.offAllNamed(GameListScreen.routeName);
    });
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

  void changeBackgroundColor() {
    setState(() {
      if (userProgress == 0) {
        background =
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_math_sort_1.png?alt=media&token=39e27f13-3fc8-42b8-9365-0b635c9ee860';
      } else if (userProgress == 1) {
        background =
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_math_sort_2.png?alt=media&token=e408883e-3659-40a8-98c2-8f67f652aaf7';
      } else if (userProgress == 2) {
        background =
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_math_sort_3.png?alt=media&token=4ef2ebe9-0629-4016-b813-3aae768bfc7e';
      } else {
        background =
            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_math_sort_1.png?alt=media&token=39e27f13-3fc8-42b8-9365-0b635c9ee860';
      }
    });
  }

  void delay3Seconds() {
    Future.delayed(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool showGuide = prefs.getBool('showGuideGameDragAndDrop') ?? true;

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
                            'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/game_tutorial_images%2Fdrag_and_drop%2Fsort_number.png?alt=media&token=884f4329-308e-4023-ae95-a08ccb4bdde8',
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: const Text(
                              'Người chơi đọc câu hỏi trên màn hình, sau đó kéo thả các thẻ số theo đề bài yêu cầu, khi đã sắp xếp đúng thứ tự, nhấn nút "XONG" để kiểm tra kết quả.',
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
                        prefs.setBool('showGuideGameDragAndDrop', false);
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
