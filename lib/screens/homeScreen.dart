import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task080125/main.dart' as mn;
import 'package:task080125/styles/button_normal.dart';
import 'package:task080125/styles/dropdown_menu.dart';
import 'package:task080125/styles/text_normal1.dart';
import 'package:task080125/styles/textfield_normal.dart';

import '../styles/text_header1.dart';


import 'package:file_picker/file_picker.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var _currentIndex = 0;

  bool isNameEmpty = true;
  bool isEmailEmpty = true;
  bool isPhoneEmpty = true;

  bool isNameShort = false;
  bool isPhoneIncorrect = false;
  bool isEmailAddressIncorrect = false;
  bool isGenderNotSelected = true;
  bool isLanguageNotSelected = true;

  String filePath = "";
  String uploadedFileText = "Upload File... (10mb Max)";
  File pickedFile = File("");

  String dropResult = "";
  
  Map userData = {
    'Name' : "",
    'Phone' : "",
    'Email' : "",
    'Gender' : "",
    'Language' : "",
    'File Path' : "files.pgh"
  };


  String makeMapReadable()
  {
    String result = "";

    for(int index = 0; index < userData.length; index++)
    {
      result = "$result ${userData.keys.elementAt(index)} : ${userData.values.elementAt(index)}\n";
    }

    return result;
  }

  String convertMapToJSON(Map mapInput)
  {
    try {
      String result = json.encode(mapInput);
      return result;

    } catch(e) {

      return "";
    }

  }

  Future<void> writeJsonToFile(String jsonString) async {
    try {
      // Get the application documents directory (safe for Android & iOS)
      Directory documentsDir = await getApplicationDocumentsDirectory();

      // Define the file path inside the documents directory
      File file = File('${documentsDir.path}/userdata-${DateTime.timestamp()}.json');

      // Write JSON string to the file
      await file.writeAsString(jsonString);

      print("JSON written successfully to: ${file.path}");
    } catch (e) {
      print("Error writing JSON: $e");
    }
  }

  void onLoginPressed() {
    setState(() {

      if(!isNameShort && !isNameEmpty && !isEmailEmpty && !isPhoneEmpty && !isPhoneIncorrect && !isEmailAddressIncorrect && !isGenderNotSelected && !isLanguageNotSelected && filePath.isNotEmpty)
      {
        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Your Data'),
              content: Text("${makeMapReadable()}\nPress OK to save this JSON data in Documents folder"),
              actions: [
                TextButton(
                  onPressed: () {
                    writeJsonToFile(convertMapToJSON(userData));
                    mn.globalKey.currentState!.dataConfirmed = true;

                    Navigator.of(context).pop(); // Close dialog first
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      mn.globalKey.currentState?.phoneNumber = userData['Phone'];
                      mn.globalKey.currentState?.changeScreen(2); // Then switch to OTP screen
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
      else
      {
        notifyOfEmptyFields();
      }
    });
  }

  void notifyOfEmptyFields()
  {
    Fluttertoast.cancel();
    String incorrectMessage = "";

    if(isNameShort || isNameEmpty){incorrectMessage = "Entered Name is too short.";}
    else if(isPhoneIncorrect || isPhoneEmpty){incorrectMessage = "Entered Phone Number is incorrect.";}
    else if(isEmailAddressIncorrect || isEmailEmpty){incorrectMessage = "Entered Email Address is incorrect.";}
    else if(isGenderNotSelected){incorrectMessage = "Please select Gender.";}
    else if(isLanguageNotSelected){incorrectMessage = "Please select your preferred Language.";}
    else if(filePath.isEmpty){incorrectMessage = "Please upload an Image File.";}
    else if(!mn.globalKey.currentState!.dataConfirmed){incorrectMessage = "Please confirm your data first.";}
    else if(!mn.globalKey.currentState!.correctOTP){incorrectMessage = "You did not enter your OTP or it is incorrect.";}

    Fluttertoast.showToast(
        msg: incorrectMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  void onTextEditedName(String text) {
    setState(() {
      if (text.length < 4) {
        isNameShort = true;
        isNameEmpty = false;
      }
      else if (text.isEmpty) {
        isNameEmpty = true;
      }
      else {
        isNameShort = false;
        isNameEmpty = false;
        userData['Name'] = text;
      }
    });
  }

  void onTextEditedPhone(String text) {
    setState(() {
      if (text.length < 12  || text.length > 12  || !containsPhoneNumber(text)) {
        isPhoneIncorrect = true;
        isPhoneEmpty = false;
      }
      else if(text.isEmpty)
      {
        isPhoneEmpty = true;

      }
      else {
        isPhoneIncorrect = false;
        isPhoneEmpty = false;
        userData['Phone'] = text;

      }
    });
  }

  void onTextEditedEmail(String text) {
    setState(() {
      if (!containsEmail(text)) {
        isEmailAddressIncorrect = true;
        isEmailEmpty = false;
      }
      else if(text.isEmpty)
      {
        isEmailEmpty = true;

      }
      else {
        isEmailAddressIncorrect = false;
        isEmailEmpty = false;
        userData['Email'] = text;

      }
    });
  }

  Future<void> uploadFileAsync()
  async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      filePath = result.files.single.path!;
      userData['File Path'] = filePath;

      pickedFile = File(result.files.single.path!);
      if(pickedFile.lengthSync() > 10000000){
        filePath = "";
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: "Selected file is too big(max 10MB)",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }

  void uploadFile()
  {
    uploadFileAsync().then((data) => setState(() {
      if(filePath.isEmpty)
      {
        uploadedFileText = "Upload File... (10mb Max)";
      }
      else
      {
        uploadedFileText = "Picked: ${trimFileName(basename(pickedFile.path))}";
      }
    }));
  }

  void onGenderPicked(value)
  {
    isGenderNotSelected = false;
    userData['Gender'] = value;
  }

  void onLanguagePicked(value)
  {
    isLanguageNotSelected = false;
    userData['Language'] = value;
  }



  String trimFileName(String fileName) {

    int lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1 || lastDotIndex == 0) {
      return fileName;
    }
    String namePart = fileName.substring(0, lastDotIndex);
    String extensionPart = fileName.substring(lastDotIndex-5);
    String trimmedName = namePart.length > 10 ? namePart.substring(0, 10) : namePart;
    return "$trimmedName...$extensionPart";
  }

  bool containsPhoneNumber(String input) {
    final pattern = r'\+?380\s?\d{2}\s?\d{3}\s?\d{4}';
    final regex = RegExp(pattern);
    return regex.hasMatch(input);
  }

  bool containsEmail(String input) {
    final pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(input);
  }

  void onNavBarClicked()
  {
    switch(_currentIndex) {
      case 1: return setState(() {
        if(mn.globalKey.currentState!.dataConfirmed)
        {
          _currentIndex = 0;
          mn.globalKey.currentState?.changeScreen(2);
        }
        else
        {
          notifyOfEmptyFields();
          _currentIndex = 0;
        }
      });

      case 2: return setState(() {
        if(mn.globalKey.currentState!.dataConfirmed && mn.globalKey.currentState!.correctOTP) {
          _currentIndex = 0;
          mn.globalKey.currentState?.changeScreen(3);
        }
        else
        {
          notifyOfEmptyFields();
          _currentIndex = 0;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green.shade100,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            onNavBarClicked();
          },
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey.shade500,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.account_box), label: "Basic Info"),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "Code Confirmation"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Password")
          ],
        ),


        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

              Padding(padding: EdgeInsets.only(top: 80)),
              TextHeader1(text: "Basic Information"),

              Padding(padding: EdgeInsets.only(top: 20)),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15),
                  child: TextNormal1(text: "To start, please provide us with some basic info"),
              ),
              ),


              Padding(padding: EdgeInsets.only(
                  left: 15, right: 15, top: 30, bottom: 5),
                child: TextFieldNormal(hintText: "Name",
                    errorText: "Name can't be shorter than 4 symbols.",
                    errorCondition: (isNameShort && !isNameEmpty),
                    onTextEdited: onTextEditedName,
                    textInputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                    ],)
              ),

              Padding(padding: EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5),
                  child: TextFieldNormal(hintText: "Phone number",
                      errorText: "This phone number is invalid.",
                      errorCondition: (isPhoneIncorrect && !isPhoneEmpty),
                      onTextEdited: onTextEditedPhone,
                      keyboardType: TextInputType.phone,
                  )
              ),

              Padding(padding: EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5),
                  child: TextFieldNormal(
                      hintText: "Email address",
                      errorText: "This email address is invalid.",
                      errorCondition: (isEmailAddressIncorrect && !isEmailEmpty),
                      onTextEdited: onTextEditedEmail,
                      keyboardType: TextInputType.emailAddress)
              ),

              Padding(padding: EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5),
                  child: DropdownMenuDefault(onSelected: onGenderPicked, hintText: "Gender",
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: "Male", label: "Male"),
                        DropdownMenuEntry(value: "Female", label: "Female"),
                        DropdownMenuEntry(value: "Other", label: "Other"),
                      ])
              ),
              Padding(padding: EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5),
                  child: DropdownMenuDefault(onSelected: onLanguagePicked, hintText: "Preferred language",
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: "English", label: "English"),
                        DropdownMenuEntry(value: "French", label: "French"),
                        DropdownMenuEntry(value: "German", label: "German"),
                        DropdownMenuEntry(value: "Ukrainian", label: "Ukrainian"),
                      ])
              ),

              Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: ButtonNormal(text: uploadedFileText, onButtonPressed: uploadFile)
              ),

              Padding(padding: EdgeInsets.all(15),
                  child: ButtonNormal(text: "Confirm Data", onButtonPressed: onLoginPressed)
              ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
