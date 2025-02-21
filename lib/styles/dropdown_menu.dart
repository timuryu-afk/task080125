import 'package:flutter/material.dart';

class DropdownMenuDefault extends StatelessWidget {

  final ValueChanged onSelected;
  final String hintText;
  final List<DropdownMenuEntry> dropdownMenuEntries;

  const DropdownMenuDefault({super.key, required this.onSelected, required this.hintText, required this.dropdownMenuEntries});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: MediaQuery.of(context).size.width-30,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),

      ),

      onSelected: onSelected,

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: "OpenSans",
        ),
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontFamily: "OpenSans",
        ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white,
              width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), borderRadius: BorderRadius.circular(10), ),

      ),

      hintText: hintText,
      dropdownMenuEntries: dropdownMenuEntries,
    );
  }
}
