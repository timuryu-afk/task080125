import 'dart:math';
import 'package:flutter/material.dart';
import 'package:task080125/screens/homeScreen.dart';
import 'package:task080125/screens/loginScreen.dart';
import 'package:task080125/screens/newPasswordScreen.dart';
import 'package:task080125/screens/otpScreen.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';



void main() {
  runApp(const MyApp());
}

GlobalKey<MyHomePageState> globalKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(key: globalKey),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required Key key}) : super(key: key);
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  String phoneNumber = "380XXXXXXXXX";
  String login = "administrator";
  String currentPassword = "12345";

  bool dataConfirmed = false;
  bool correctOTP = false;

  int currentScreenID = 0;

  String loginScreenValueKey = "login";
  String homeScreenValueKey = "home";
  String otpScreenValueKey = "otp";
  String newPasswordScreenValueKey = "password";


  final storage = FlutterSecureStorage();


  Future<void> retrievePassword()
  async {
    String? value = await storage.read(key: "password");

    if(value != null){
      currentPassword = value.isNotEmpty ? value : "12345";
    }


  }

  void changeScreen(int newID) {
    setState(() {
      currentScreenID = newID;
    });
  }


  void resetValueKeys()
  {

    retrievePassword().then((value) {
        setState(() {
          loginScreenValueKey = Random().nextInt(999999).toString();
          homeScreenValueKey = Random().nextInt(999999).toString();
          otpScreenValueKey = Random().nextInt(999999).toString();
          newPasswordScreenValueKey = Random().nextInt(999999).toString();
          dataConfirmed = false;
          correctOTP = false;
          phoneNumber = "380XXXXXXXXX";
        });
    });

  }



  @override
  void initState()
  {
    super.initState();


    retrievePassword();


  }











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentScreenID,  // Show the screen at this index
        children: [
          LoginScreen(key: ValueKey(loginScreenValueKey)),
          HomeScreen(key: ValueKey(homeScreenValueKey)),
          OtpScreen(key: ValueKey(otpScreenValueKey), phoneNumber: phoneNumber),
          NewPasswordScreen(key: ValueKey(newPasswordScreenValueKey)),
        ],
      ),
    );
  }
}
