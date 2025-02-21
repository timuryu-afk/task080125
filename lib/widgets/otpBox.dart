import 'package:flutter/material.dart';

class OtpBox extends StatefulWidget {
  final VoidCallback onPress; // Callback function for tap event

  const OtpBox({super.key, required this.onPress});

  @override
  OtpBoxState createState() => OtpBoxState();
}

class OtpBoxState extends State<OtpBox> {
  String digitText = "x";

  void updateText(String newText) {
    setState(() {
      digitText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {

      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: MaterialButton(
        onPressed: widget.onPress,
          color: Colors.white,
          disabledColor: Colors.white,
          height: 55,
          minWidth: 55,
          shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 5.0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            digitText,
            style: const TextStyle(
              fontFamily: "OpenSans",
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
      );

  }
}
