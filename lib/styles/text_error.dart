import 'package:flutter/material.dart';

class TextError extends StatelessWidget {

  final String text;

  const TextError({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: 17,
      color: Colors.red,
      fontFamily: "OpenSans",

    ),
      textAlign: TextAlign.left,
    );
  }
}
