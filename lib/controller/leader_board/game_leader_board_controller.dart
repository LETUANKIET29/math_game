import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:math_game/firebase/firebase_configs.dart';
import 'package:math_game/model/leader_board_model.dart';
import 'package:math_game/utils/api_endpoint.dart';
import 'package:math_game/utils/logger.dart';

class GameLeaderBoardController extends GetxController {
  // game
  final gameloadingStatus = LoadingStatus.completed.obs;
  var gamesLeaderBoard = <LeaderBoardGameData>[];

  // leader board for game
  Future<void> getAllGame(String gameId) async {
    gameloadingStatus.value = LoadingStatus.loading;
    try {
      final String apiUrl =
          "$newBaseApiUrl/game-histories/leader-board?GameId=$gameId&Top=10";
      final response =
          await http.get(Uri.parse(apiUrl), headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
        'ngrok-skip-browser-warning': 'true',
      });

      if (response.statusCode == 200) {
        final body = response.body;
        final decoded = jsonDecode(body);

        // Check JSON format and access data
        if (decoded is Map<String, dynamic> &&
            decoded['data'] is List<dynamic>) {
          final data = decoded['data'] as List<dynamic>;

          final allData =
              data.map((item) => LeaderBoardGameData.fromJson(item)).toList();

          // Assuming userFR and AppLogger are defined and used somewhere in your code
          for (var data in allData) {
            final userSnapshot = await userFR.doc(data.userName).get();
            // Do something with userSnapshot if needed
          }

          gamesLeaderBoard = allData;
          gameloadingStatus.value = LoadingStatus.completed;
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        gameloadingStatus.value = LoadingStatus.error;
        throw Exception(
            'Failed to fetch leaderboard. Status code: ${response.statusCode}');
      }
    } catch (e) {
      gameloadingStatus.value = LoadingStatus.error;
      AppLogger.e(e);
    }
  }
}
