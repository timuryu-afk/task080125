import 'package:flutter/material.dart';

class TextNormal1 extends StatelessWidget {

  final String text;

  const TextNormal1({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontFamily: "OpenSans",

    ),
      textAlign: TextAlign.center,
    );
  }
}
