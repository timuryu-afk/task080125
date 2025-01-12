import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task080125/styles/text_header1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning

  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {
    Color currentButtonColor = Colors.white;

    void onLoginHover(bool isHover)
    {

      setState(() {
        currentButtonColor = Colors.white54;
      });
    }

    var loginButton = TextButton(


      style: ButtonStyle(

        backgroundColor: WidgetStatePropertyAll(currentButtonColor),
        fixedSize: WidgetStatePropertyAll(Size.fromWidth(double.maxFinite)),


      ),


      onPressed: null,
      onHover: onLoginHover,
      child: Text("Login", style: TextStyle(fontFamily: "OpenSans", color: Colors.black, fontSize: 20),),

    );


    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Container(
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

            Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: TextField(
                style: const TextStyle(fontFamily: "OpenSans", color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Login',
                  hintStyle: const TextStyle(fontFamily: "OpenSans", color: Colors.blueGrey, fontSize: 20),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              child: TextField(
                style: const TextStyle(fontFamily: "OpenSans", color: Colors.black, fontSize: 20),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Password',

                  hintStyle: const TextStyle(fontFamily: "OpenSans", color: Colors.blueGrey, fontSize: 20),
                ),
              ),
            ),

            Padding(padding: EdgeInsets.all(15),

              child: loginButton,
            ),
          ],
        ),
        )

      );


  }
}
