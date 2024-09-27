import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatefulWidget {
  final String child;
  final VoidCallback onTap;

  const MyButton({super.key, required this.child, required this.onTap});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  var buttonColor = Colors.deepPurple[600];

  var whiteTextStyle = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white,);

  @override
  Widget build(BuildContext context) {

    if(widget.child == 'C') {
      buttonColor = Colors.green;
    } else if (widget.child == '\u2190') {
      buttonColor = Colors.red;
    } else if (widget.child == '=') {
      buttonColor = Colors.deepPurple;
    } else if (widget.child == 'XONG') {
      buttonColor = Colors.green;
    }else if (widget.child == 'KIỂM TRA') {
      buttonColor = Colors.green;
    } else if (widget.child == 'KHÔI PHỤC') {
      buttonColor = Colors.red;
    } else if (widget.child =='/'){
      buttonColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              widget.child,
              style: GoogleFonts.aBeeZee(
                textStyle: whiteTextStyle,
              )
            ),
          ),
        ),
      ),
    );
  }
}
