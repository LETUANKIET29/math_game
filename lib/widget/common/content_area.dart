import 'package:flutter/material.dart';
import 'package:math_game/configs/themes/app_colors.dart';
import 'package:math_game/configs/themes/ui_parameters.dart';

class ContentArea extends StatelessWidget {
  const ContentArea({super.key, required this.child, this.addPadding = true, });

  final Widget child;
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)) ,
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      child: Ink(
        
        decoration: BoxDecoration(
          color: customScaffoldColor(context),
         
        ),
        padding: addPadding
            ? const EdgeInsets.only(
                top: kMobileScreenPadding,
                left: kMobileScreenPadding,
                right: kMobileScreenPadding)
            : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
