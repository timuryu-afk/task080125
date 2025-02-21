import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:task080125/main.dart' as mn;
import 'package:task080125/styles/text_error.dart';
import 'package:task080125/styles/text_normal1.dart';
import '../styles/text_header1.dart';
import '../widgets/otpBox.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  var currentIndex = 1;
  String incorrectText = "";
  FocusNode textFocus = FocusNode();

  final List<GlobalKey<OtpBoxState>> otpBoxKeys =
  List.generate(6, (index) => GlobalKey<OtpBoxState>());

  void updateOtpBox(int index, String newText) {
    if (index >= 0 && index < otpBoxKeys.length) {
      otpBoxKeys[index].currentState?.updateText(newText);
    }
  }

  void notifyOfIncorrectData()
  {
    Fluttertoast.cancel();
    String incorrectMessage = "";

    if(!mn.globalKey.currentState!.dataConfirmed){incorrectMessage = "Your Data is not confirmed";}
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

  void onNavBarClicked()
  {
    switch(currentIndex) {

      case 0: return  setState(() {
        currentIndex = 1;
        mn.globalKey.currentState?.changeScreen(1);

      });

      case 2: return setState(() {
        if(mn.globalKey.currentState!.dataConfirmed && mn.globalKey.currentState!.correctOTP) {
          currentIndex = 1;
          deFocus();
          mn.globalKey.currentState?.changeScreen(3);
        }
        else
        {
          currentIndex = 1;
          notifyOfIncorrectData();
        }
      });
    }
  }

  void focusOnTextField() { FocusScope.of(context).requestFocus(textFocus); }
  void deFocus() { FocusScope.of(context).unfocus(); }


  void updateAllText(String value) {
    for (int i = 0; i < 6; i++) {
      String digit = (i < value.length) ? value[i] : "x";
      updateOtpBox(i, digit);
    }
    setState(() {
      incorrectText = (value != "123456" && value.length == 6) ? "This code is incorrect." : "";
      mn.globalKey.currentState!.correctOTP = (value != "123456") ? false : true;

      if(value.length == 6)
      {
        if(value == "123456")
        {
          currentIndex = 1;
          deFocus();
          mn.globalKey.currentState?.changeScreen(3);
        }
        else
        {
          notifyOfIncorrectData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
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

        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 80)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: TextHeader1(text: "Code Confirmation"),
                  ),
                ),

            Padding(padding: EdgeInsets.only(top: 20)),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextNormal1(text: "Enter your One-Time Password (OTP) \n We've sent your code to '${mn.globalKey.currentState?.phoneNumber}'"),
              ),
            ),



            Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 5),
                    child: Opacity(
                      opacity: 0.0,
                      child: TextField(
                        enabled: true,
                        autofocus: true,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        onChanged: updateAllText,
                        keyboardType: TextInputType.number,
                        focusNode: textFocus,
                        style: const TextStyle(fontFamily: "OpenSans",
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                ),

            Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  child: Row(
                    children: List.generate(6, (index) {
                      return OtpBox(
                        key: otpBoxKeys[index],
                        onPress: () => focusOnTextField(), // Pass function to OtpBox
                      );
                    }),
                  ),
                ),

            Padding(padding: EdgeInsets.only(top: 5)),
            Flexible(

              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: TextError(text: incorrectText),
              ),
            ),
          ],
        ),
    );
  }
}
