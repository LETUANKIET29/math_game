import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:math_game/firebase/firebase_configs.dart';
import 'package:math_game/model/leader_board_model.dart';
import 'package:math_game/utils/logger.dart';

class LeaderBoardController extends GetxController {
  // quiz
  final leaderBoard = <LeaderBoardData>[].obs;
  final myScores = Rxn<LeaderBoardData>();
  final loadingStatus = LoadingStatus.completed.obs;

  void getAll(String paperId) async {
    loadingStatus.value = LoadingStatus.loading;
    try {
      final QuerySnapshot<Map<String, dynamic>> leaderBoardSnapShot =
          await getleaderBoard(paperId: paperId)
              .orderBy("points", descending: true)
              .limit(50)
              .get();
      final allData = leaderBoardSnapShot.docs
          .map((score) => LeaderBoardData.fromSnapShot(score))
          .toList();

      for (var data in allData) {
        final userSnapshot = await userFR.doc(data.userId).get();
        data.user = UserData.fromSnapShot(userSnapshot);
      }

      leaderBoard.assignAll(allData);
      loadingStatus.value = LoadingStatus.completed;
    } catch (e) {
      loadingStatus.value = LoadingStatus.error;
      AppLogger.e(e);
    }
  }
}
