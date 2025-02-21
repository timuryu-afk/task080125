import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldNormal extends StatelessWidget {

  final String hintText;
  final String errorText;
  final bool errorCondition;
  final void Function(String value) onTextEdited;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? textInputFormatters;

  const TextFieldNormal({super.key, required this.hintText, required this.errorText, required this.errorCondition, required this.onTextEdited, this.textInputFormatters, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(

      style: const TextStyle(fontFamily: "OpenSans",
          color: Colors.black,
          fontSize: 20),
      onChanged: onTextEdited,

      inputFormatters: textInputFormatters,

      textInputAction: TextInputAction.done,
      keyboardType: (keyboardType != null) ? keyboardType : TextInputType.text,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white,
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white,
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white,
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(fontFamily: "OpenSans",
            color: Colors.blueGrey,
            fontSize: 20),


        errorText: errorCondition
            ? errorText
            : null,
      ),
    );
  }
}
