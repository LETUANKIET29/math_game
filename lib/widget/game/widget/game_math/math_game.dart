// import 'dart:math';

// import 'package:beanmind_flutter/widgets/game/class/math_game/math_game_level.dart';
// import 'package:beanmind_flutter/widgets/game/class/math_game/math_game_user.dart';
// import 'package:flutter/material.dart';

// class MathGame extends StatefulWidget {
//   const MathGame({super.key});

//   @override
//   State<MathGame> createState() => _MathGameState();
// }

// class _MathGameState extends State<MathGame> {
//   String background =
//       'https://firebasestorage.googleapis.com/v0/b/beanmind-2911.appspot.com/o/background_images%2Fbackground_math_sort_1.png?alt=media&token=39e27f13-3fc8-42b8-9365-0b635c9ee860';

//   @override
//   void initState() {
//     restartGame();
//     super.initState();
//   }

//   answer({index}) {
//   if (!isAnswered) {
//     setState(() {
//       userProgress += 1;
//       isAnswered = true;
//       if (choice.elementAt(index) == correctAnswer) {
//         isCorrect = true;    
//         userPoint = userPoint + 1;
//       } else {
//         isCorrect = false;
//       }
//       nextQuestion();
//     });

//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         isAnswered = false;
//       });
//     });
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.sizeOf(context).width,
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     width: double.infinity,
//                     key: ValueKey<String>(background),
//                     alignment: Alignment.topCenter,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: NetworkImage(
//                             background),
//                         fit: BoxFit.fill,
//                         colorFilter: ColorFilter.mode(
//                           Colors.black.withOpacity(0.5),
//                           BlendMode.darken,
//                         ),
//                       ),
//                     ),
//                     child: Stack(
//                       children: [
//                         Column(
//                           children: [
//                             Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                         "Câu số ${userProgress + 1}",
//                                         style: TextStyle(
//                                           fontSize: 50,
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     // timer 60s count down
//                                   ],
//                                 ),
//                                 Center(
//                                   child: Container(
//                                     margin: EdgeInsets.only(
//                                         top: MediaQuery.sizeOf(context).height *
//                                             0.2),
//                                             padding: EdgeInsets.only(left: 10, right: 10),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: Colors.white,
//                                     ),
//                                     child: Text(
//                                       "${firstValue} ${operator} ${secondValue}",
//                                       style: TextStyle(
//                                         fontSize: 50,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Spacer(),
//                             Container(
//                               margin: EdgeInsets.symmetric(horizontal: 20),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: List.generate(choice.length, (index) {
//                                   return GestureDetector(
//                                     onTap: () {
//                                       answer(index: index);
//                                     },
//                                     child: Container(
//                                       width: 180,
//                                       height: 100,
//                                       padding: EdgeInsets.all(5),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(50),
//                                         color: Colors.white,
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           choice.elementAt(index).toString(),
//                                           style: TextStyle(
//                                             fontSize: 50,
//                                             fontWeight: FontWeight.w900,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 20,
//                             )
//                           ],
//                         ),
//                         Visibility(
//                           visible: isAnswered,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.8),
//                             ),
//                             child: Center(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         isCorrect
//                                             ? Icon(
//                                                 Icons.check,
//                                                 color: Colors.green,
//                                                 size: 100,
//                                               )
//                                             : Icon(
//                                                 Icons.close,
//                                                 color: Colors.red,
//                                                 size: 100,
//                                               ),
//                                         Text(
//                                           isCorrect ? "Correct" : "Wrong",
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w900,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


