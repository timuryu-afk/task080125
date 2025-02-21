import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldPassword extends StatelessWidget {

  final String hintText;
  final String errorText;
  final bool errorCondition;
  final void Function(String value) onTextEdited;
  final List<TextInputFormatter> textInputFormatters;
  final bool isPasswordObstructed;

  const TextFieldPassword({super.key, required this.hintText, required this.errorText, required this.errorCondition, required this.onTextEdited, required this.textInputFormatters, required this.isPasswordObstructed});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onTextEdited,
      inputFormatters: textInputFormatters,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isPasswordObstructed,
      style: const TextStyle(
        fontFamily: "OpenSans",
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: "OpenSans",
          color: Colors.blueGrey,
          fontSize: 20,
        ),

        errorText: errorCondition
            ? errorText
            : null,
      ),
    );
  }
}
