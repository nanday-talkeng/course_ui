import 'package:course_ui/services/secure_screen.dart';
import 'package:course_ui/view/home.dart';
import 'package:flutter/material.dart';

void main() {
  secureScreen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: MyHomePage(),
    );
  }
}
