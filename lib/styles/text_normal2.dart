import 'package:flutter/material.dart';

class TextNormal2 extends StatelessWidget {

  final String text;

  const TextNormal2({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontFamily: "OpenSans",

    ),
      textAlign: TextAlign.left,
    );
  }
}
