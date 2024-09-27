import 'dart:async';

class TimeRecord {
  Timer? timer;
  int seconds = 0;

  void startTimer() {
    const Duration oneSecond = Duration(seconds: 1);
    timer = Timer.periodic(oneSecond, (Timer timer) {
      seconds++;
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null; // Set _timer to null to ensure it stops
    }
  }
}
