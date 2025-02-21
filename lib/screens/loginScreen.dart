import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task080125/main.dart' as mn;
import 'package:task080125/styles/button_normal.dart';
import 'package:task080125/styles/textfield_normal.dart';
import 'package:task080125/styles/textfield_password.dart';

import '../styles/text_header1.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isPassShort = false;
  bool isLoginShort = false;

  bool isPassEmpty = true;
  bool isLoginEmpty = true;

  bool passObstructed = true;




  Map accountData = {
    'Login' : "",
    'Password' : ""
  };



  void onLoginPressed() {
    setState(() {
      //currentButtonColor = Colors.white54;
      if(!isPassShort && !isLoginShort && !isPassEmpty && !isLoginEmpty && accountData['Login'] == mn.globalKey.currentState?.login && accountData['Password'] == mn.globalKey.currentState?.currentPassword) {
        mn.globalKey.currentState?.changeScreen(1);
      }
      else if(accountData['Login'] != mn.globalKey.currentState?.login || accountData['Password'] != mn.globalKey.currentState?.currentPassword)
      {

        notifyOfIncorrectData();
      }



    });
  }

  void notifyOfIncorrectData()
  {
    Fluttertoast.cancel();
    String incorrectMessage = "";

    if(accountData['Login'] != mn.globalKey.currentState?.login){incorrectMessage = "This Login is incorrect.";}
    else if(accountData['Password'] != mn.globalKey.currentState?.currentPassword){incorrectMessage = "This Password is incorrect.";}



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

  void onTextEditedPass(String text) {
    setState(() {
      //currentButtonColor = Colors.white54;
      if (text.length < 4) {
        isPassShort = true;
        isPassEmpty = false;
      }
      else if (text.isEmpty) {
        isPassEmpty = true;
        isPassShort = false;
      }
      else {
        isPassShort = false;
        isPassEmpty = false;
        accountData['Password'] = text;
      }
    });
  }

  void onTextEditedLogin(String text) {
    setState(() {
      //currentButtonColor = Colors.white54;
      if (text.length < 4) {
        isLoginShort = true;
        isLoginEmpty = false;
      }
      else if (text.isEmpty) {
        isLoginEmpty = true;
        isLoginShort = false;
      }
      else {
        isLoginShort = false;
        isLoginEmpty = false;
        accountData['Login'] = text;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan.shade100,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 300)),
                    TextHeader1(text: "Welcome"),

                  ],
                ),

                Padding(padding: EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                  child: TextFieldNormal(hintText: "Login",
                      errorText: "Login can't be shorter than 4 symbols.",
                      errorCondition: (isLoginShort && !isLoginEmpty),
                      onTextEdited: onTextEditedLogin,
                      textInputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      ]),
                ),

                Padding(padding: EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                    child: Stack(
                      children: [
                        TextFieldPassword(hintText: "Password",
                            errorText: "Login can't be shorter than 4 symbols.",
                            errorCondition: (isPassShort && !isPassEmpty),
                            onTextEdited: onTextEditedPass,
                            textInputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9!@#\$^&_+=()<>]")),
                            ],
                            isPasswordObstructed: passObstructed),
                        Positioned(
                          right: 10, // Adjust the position as needed
                          top: 10, // Adjust the position as needed
                          child: IconButton(
                            icon: Icon(passObstructed ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                passObstructed = !passObstructed;
                              });
                              // Toggle password visibility logic
                            },
                          ),
                        ),
                      ],
                    )
                ),

                Padding(padding: EdgeInsets.all(15),
                  child: ButtonNormal(text: "Login", onButtonPressed: onLoginPressed)
                ),
              ],
            ),
          ),
        )

    );

  }
}
