import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressWidgets extends StatefulWidget {
  const ProgressWidgets({super.key});

  @override
  State<ProgressWidgets> createState() => _ProgressWidgetsState();
}

class _ProgressWidgetsState extends State<ProgressWidgets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/lotties/loading_animation_01.json", height: MediaQuery.of(context).size.height * 0.5),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: LinearPercentIndicator(
            width: MediaQuery.of(context).size.width *0.9,
            animation: true,
            lineHeight: 30.0,
            animationDuration: 2500,
            percent: 1,
            center: const Text(
              "Xin chờ ...",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.green,
            alignment: MainAxisAlignment.center,
          ),
        ),
      ],
    )));
  }
}

class LoadingWidgets extends StatefulWidget {
  const LoadingWidgets({super.key});

  @override
  State<LoadingWidgets> createState() => _LoadingWidgetsState();
}

class _LoadingWidgetsState extends State<LoadingWidgets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/lotties/loading_animation_02.json",
            height: MediaQuery.of(context).size.height * 0.1),
      ],
    )));
  }
}
