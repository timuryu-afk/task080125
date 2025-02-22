import 'package:flutter/material.dart';

class TextHeader1 extends StatelessWidget {

  final String text;

  const TextHeader1({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: 40,
      color: Colors.black,
      fontFamily: "OpenSans",
      fontWeight: FontWeight.bold,

    ),
      textAlign: TextAlign.center,
    );
  }
}
