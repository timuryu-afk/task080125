import 'package:flutter/material.dart';

class ButtonNormal extends StatelessWidget {

  final String text;
  final VoidCallback onButtonPressed;

  const ButtonNormal({super.key, required this.text, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(

      color: Colors.white,
      height: 55,
      minWidth: double.maxFinite,

      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white,
            width: 5.0),
        borderRadius: BorderRadius.circular(10),
      ),






      onPressed: onButtonPressed,
      // onHover: ,
      child: Text(text, style: TextStyle(
          fontFamily: "OpenSans",
          color: Colors.black,
          fontSize: 20),),

    );
  }
}
