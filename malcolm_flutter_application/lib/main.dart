import 'package:flutter/material.dart';
import 'package:malcolm_flutter_application/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 26),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
            headline6: TextStyle(fontSize: 28.0),
            bodyText2: TextStyle(fontSize: 20.0),
            button: TextStyle(fontSize: 36.0)),
      ),
      home: const MyHomePage(title: 'Hacket Upskilling App'),
    );
  }
}
