import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_game/controller/controllers.dart';
import 'package:math_game/screens/game/game_list_screen.dart';
import 'package:math_game/widget/firebase_options.dart';

void main() async{
  await initFireBase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Math Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameListScreen(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<GameController>(() => GameController());
      }),
    );
  }
}
Future<void> initFireBase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}