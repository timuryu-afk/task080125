import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task080125/main.dart' as mn;

import '../styles/text_header1.dart';
import '../styles/text_normal1.dart';
import '../styles/text_normal2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  bool newPassObstructed = true;
  bool confirmPassObstructed = true;

  var currentIndex = 2;

  String newPassword = "";
  String confirmPassword = "";


  //Bools to check password
  bool confirmMatchesNewPassword = false;

  bool passIsNotUsername = false;
  bool passIsNotOldPassword = false;
  bool passCorrectLength = false;
  bool passContainsLowercase = false;
  bool passContainsUppercase = false;
  bool passContainsNumber = false;
  bool passContainsSpecialCharacter = false;

  bool isPasswordCorrect = false;

  final storage = FlutterSecureStorage();



  Future<void> savePassword()
  async {
    await storage.write(key: "password", value: newPassword);
  }


  void passwordChecker()
  {
    setState(() {
      if(newPassword.isNotEmpty) {

        //check if new password matches confirm password
        confirmMatchesNewPassword = (newPassword == confirmPassword);

        //check if new password not matches old password
        passIsNotOldPassword = (newPassword != mn.globalKey.currentState?.currentPassword);

        //check if new password is not the same as username
        passIsNotUsername = (newPassword != mn.globalKey.currentState?.login);

        //check if new password is correct length
        passCorrectLength = (newPassword.length >= 8 && newPassword.length <= 20);

        //check if new password contains a lowercase letter
        passContainsLowercase = (newPassword.contains(RegExp("[a-z]")));

        //check if new password contains an uppercase letter
        passContainsUppercase = (newPassword.contains(RegExp("[A-Z]")));

        //check if new password contains a number
        passContainsNumber = (newPassword.contains(RegExp("[0-9]")));

        //check if new password contains a special character
        passContainsSpecialCharacter = (newPassword.contains(RegExp("[!@#\$^&_+=()<>]")));


        //one big password checker
        isPasswordCorrect = (
            confirmMatchesNewPassword && passIsNotOldPassword
            && passIsNotUsername && passCorrectLength
            && passContainsLowercase && passContainsUppercase
            && passContainsNumber && passContainsSpecialCharacter
        );

      }
      else
      {
        //a bad way to insure the gui is correct
        confirmMatchesNewPassword = false;
        passIsNotOldPassword = false;
        passIsNotUsername = false;
        passCorrectLength = false;
        passContainsLowercase = false;
        passContainsUppercase = false;
        passContainsNumber = false;
        passContainsSpecialCharacter = false;



      }


    });

  }


  void updatePassword()
  {
    setState(() {

      if(isPasswordCorrect)
      {



        showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Update Your password?'),
              content: Text("Your current password is: ${mn.globalKey.currentState?.currentPassword}\nYour new password would be: $newPassword\n\nPress OK to update your password (You will need to re-login)"),
              actions: [
                TextButton(
                  onPressed: () {



                    Navigator.of(context).pop(); // Close dialog first
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      savePassword().whenComplete(() {
                        mn.globalKey.currentState?.currentPassword = newPassword;
                        mn.globalKey.currentState?.resetValueKeys();
                        mn.globalKey.currentState?.changeScreen(0); // Then switch to OTP screen
                      });

                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

      }


      //mn.globalKey.currentState?.changeScreen(1);


    });

  }













  void notifyOfIncorrectData() {
    Fluttertoast.cancel();
    String incorrectMessage = "";

    if (!mn.globalKey.currentState!.dataConfirmed) {
      incorrectMessage = "Your Data is not confirmed";
    } else if (!mn.globalKey.currentState!.correctOTP) {
      incorrectMessage = "You did not enter your OTP or it is incorrect.";
    }

    Fluttertoast.showToast(
        msg: incorrectMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }


  void onNavBarClicked() {
    switch (currentIndex) {
      case 0:
        return setState(() {
          currentIndex = 2;
          mn.globalKey.currentState?.changeScreen(1);
        });
      case 1:
        return setState(() {
          if (mn.globalKey.currentState!.dataConfirmed) {
            currentIndex = 2;
            mn.globalKey.currentState?.changeScreen(2);
          } else {
            currentIndex = 2;
            notifyOfIncorrectData();
          }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          onNavBarClicked();
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey.shade500,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), label: "Basic Info"),
          BottomNavigationBarItem(
              icon: Icon(Icons.abc), label: "Code Confirmation"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Password")
        ],
      ),
      backgroundColor: Colors.cyan.shade200,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(padding: EdgeInsets.only(top: 80)),
                TextHeader1(text: "Create your password"),

                Padding(padding: EdgeInsets.only(top: 30)),


                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15),
                  child: TextNormal1(text: "New password"),
                ),

                Padding(padding: EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                  child: Stack(
                    children: [
                      TextField(
                        onChanged:  (value) {
                    newPassword = value;
                    passwordChecker();
                    },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(25),
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9!@#\$^&_+=()<>]")),
                        ],
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: newPassObstructed,
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
                          hintText: 'New Password',
                          hintStyle: const TextStyle(
                            fontFamily: "OpenSans",
                            color: Colors.blueGrey,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10, // Adjust the position as needed
                        top: 10, // Adjust the position as needed
                        child: IconButton(
                          icon: Icon(newPassObstructed ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              newPassObstructed = !newPassObstructed;
                            });
                            // Toggle password visibility logic
                          },
                        ),
                      ),
                    ],
                  )
                ),


                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10),
                  child: TextNormal1(text: "Confirm password"),
                ),

                Padding(padding: EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                    child: Stack(
                      children: [
                        TextField(
                          onChanged: (value) {
                            confirmPassword = value;
                            passwordChecker();
                          },
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(25),
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9!@#\$^&_+=()<>]")),
                          ],
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: confirmPassObstructed,
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
                            hintText: 'Confirm Password',
                            hintStyle: const TextStyle(
                              fontFamily: "OpenSans",
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10, // Adjust the position as needed
                          top: 10, // Adjust the position as needed
                          child: IconButton(
                            icon: Icon(confirmPassObstructed ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                confirmPassObstructed = !confirmPassObstructed;
                              });
                              // Toggle password visibility logic
                            },
                          ),
                        ),
                      ],
                    )
                ),



                //checkboxes

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Icon(confirmMatchesNewPassword ? Icons.check : Icons.close,
                        color: confirmMatchesNewPassword ? Colors.lightGreenAccent : Colors.red,),
                      TextNormal2(text: " Entered passwords match"),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(passIsNotOldPassword ? Icons.check : Icons.close,
                        color: passIsNotOldPassword ? Colors.lightGreenAccent : Colors.red,),
                      TextNormal2(text: " Must not match your old password"),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(passIsNotUsername ? Icons.check : Icons.close,
                        color: passIsNotUsername ? Colors.lightGreenAccent : Colors.red,),
                      TextNormal2(text: " Must not be the same as username"),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(passCorrectLength ? Icons.check : Icons.close,
                        color: passCorrectLength ? Colors.lightGreenAccent : Colors.red,),
                      TextNormal2(text: " Must be between 8 and 20 characters"),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(passContainsLowercase ? Icons.check : Icons.close,
                        color: passContainsLowercase ? Colors.lightGreenAccent : Colors.red,),
                      TextNormal2(text: " Must contain a lowercase letter"),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(passContainsUppercase ? Icons.check : Icons.close,
                        color: passContainsUppercase ? Colors.lightGreenAccent : Colors.red,),
                      TextNormal2(text: " Must contain an uppercase letter"),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(passContainsNumber ? Icons.check : Icons.close,
                        color: passContainsNumber ? Colors.lightGreenAccent : Colors.red,),
                      TextNormal2(text: " Must contain a number"),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(passContainsSpecialCharacter ? Icons.check : Icons.close,
                        color: passContainsSpecialCharacter ? Colors.lightGreenAccent : Colors.red,),
                      Flexible(
                          child: TextNormal2(text: " Must contain one of the following special characters:  ! @ # \$ ^ &_ + = () <>")),
                    ],
                  ),
                ),





                Padding(padding: EdgeInsets.all(15),

                  child: Opacity(
                    opacity: isPasswordCorrect ? 1 : 0,
                    child: MaterialButton(

                      color: Colors.white,
                      height: 55,
                      minWidth: double.maxFinite,


                      shape: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white,
                            width: 5.0),
                        borderRadius: BorderRadius.circular(10),
                      ),


                      onPressed: isPasswordCorrect ? updatePassword : null,
                      // onHover: ,
                      child: Text("Confirm Password", style: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.black,
                          fontSize: 20),),

                    ),
                  ),
                ),










              ],
            ),
          ),
        ),
      ),
    );
  }
}
