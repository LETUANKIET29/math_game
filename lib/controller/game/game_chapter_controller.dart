import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:math_game/firebase/firebase_configs.dart';
import 'package:math_game/model/game_model.dart';
import 'package:math_game/screens/game/game_drag_and_drop_screen.dart';
import 'package:math_game/screens/game/game_list_screen.dart';
import 'package:math_game/screens/game/game_shopping_screen.dart';
import 'package:math_game/screens/game/happy_farm_screen.dart';
import 'package:math_game/screens/game/math_screen.dart';
import 'package:math_game/screens/game/ocean_adventure_screen.dart';
import 'package:math_game/screens/game/odd_and_even_screen.dart';
import 'package:math_game/utils/api_endpoint.dart';

class GameChapterController extends GetxController {
  final loadingStatus = LoadingStatus.loading.obs;
  var isLoading = false.obs;
  var selectedGame = RxnString();
  var shouldReset = false.obs;
  List<dynamic> games = [].obs;
  late String gameId;

  // @override
  // void onInit() {
  //   gameId = Get.parameters['game_id'] ?? '';
  //   if (gameId.isEmpty) {
  //     print('Error: gameId is empty');
  //   } else {
  //     print('gameId: $gameId');
  //   }
  //   fetchGameList();
  //   fetchDataGameAnimal();
  //   fetchDataItem();
  //   super.onInit();
  // }


  @override
  void onInit() {
    gameId = Get.parameters['game_id']!;
    if (gameId.isEmpty) {
      print('Error: gameId is empty');
    } else {
      print('gameId: $gameId');
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchGameList();
    fetchDataGameAnimal();
    fetchDataItem();
  }


  void navigateToGameList() {
    Get.toNamed(GameListScreen.routeName);
  }

  Future<void> fetchGameList() async {
    isLoading.value = true; // Đặt trạng thái tải
    try {
      final response = await http.get(
          Uri.parse('$newBaseApiUrl/games'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
            'ngrok-skip-browser-warning': 'true',
          });

      if (response.statusCode == 200) {
        final body = response.body;
        final decoded = jsonDecode(body);

        if (decoded is Map<String, dynamic> &&
            decoded['data'] is Map<String, dynamic>) {
          games = decoded['data']['items'];
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load game list');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load games');
    } finally {
      isLoading.value =
      false; // Đặt trạng thái tải thành false sau khi hoàn tất
    }
  }

  Future<void> fetchDataGameAnimal() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestore.collection('animal').get();
      List<GameAnimalModel> items = snapshot.docs
          .map((doc) => GameAnimalModel.fromSnapshot(doc))
          .toList();
      animalslist = List<GameAnimalModel>.from(items);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchDataItem() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestore.collection('itemstore').get();
      List<ItemModel> items =
      snapshot.docs.map((doc) => ItemModel.fromSnapshot(doc)).toList();
      startLowerItemModel = items;
      lowerItemModel = List<ItemModel>.from(startLowerItemModel);
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Widget buildGameWidget(String gameId) {
    switch (gameId) {
    // happy farm game
      case '49299e7c-fa16-45fd-84e4-1a725c118a9f':
        return HappyFarmScreen(level: 1, gameid: gameId);
      case 'a65534d6-b34c-43d1-e2f6-08dcb0b903bd':
        return HappyFarmScreen(level: 2, gameid: gameId);
      case '9400fa00-e27d-40a1-e2f7-08dcb0b903bd':
        return HappyFarmScreen(level: 3, gameid: gameId);
    // ocean adventure game
      case '3ae42c10-7dbe-4e71-a52c-c19c44e3c4a0':
        return OceanAdventureScreen(level: 1, gameid: gameId);
      case 'd9db0faa-49e7-488e-e2f8-08dcb0b903bd':
        return OceanAdventureScreen(level: 2, gameid: gameId);
      case '6d69ec97-28c8-4c34-e2f9-08dcb0b903bd':
        return OceanAdventureScreen(level: 3, gameid: gameId);
    // sorting numbers game
      case 'ead13199-827d-4c48-5d08-08dcafad932c':
        return MathDragAndDropScreen(level: 1, gameid: gameId);
      case '3e2e9eee-07bb-4548-e2fa-08dcb0b903bd':
        return MathDragAndDropScreen(level: 2, gameid: gameId);
      case '6011f3e5-d1fd-439c-e2fb-08dcb0b903bd':
        return MathDragAndDropScreen(level: 3, gameid: gameId);
    // odd and even game
      case '59141c9e-7dd3-4c76-5d0a-08dcafad932c':
        return GameOddAndEvenScreen(level: 1, gameid: gameId);
      case 'b2b05dc0-d4d4-4dfb-e2fc-08dcb0b903bd':
        return GameOddAndEvenScreen(level: 2, gameid: gameId);
    // shopping game
      case 'c296495f-342e-4fd6-5d09-08dcafad932c':
        return GameShoppingScreen();
    // math game
      case '134a1896-37a0-481c-76b8-08dcb1f69dd7':
        return MathGameScreeen(level: 1, gameid: gameId);
      case 'd9ebd726-6f2b-4609-76b9-08dcb1f69dd7':
        return MathGameScreeen(level: 2, gameid: gameId);
      case '2395575f-74e2-4809-76ba-08dcb1f69dd7':
        return MathGameScreeen(level: 3, gameid: gameId);
      default:
        return const GameListScreen();
    }
  }
}
