import 'package:flutter/material.dart';
import 'package:your_thing/screens/registerScreen.dart';
import 'package:your_thing/screens/splashScreen.dart';

void main() {
  runApp(YourThing());
}

class YourThing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your Thing',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        accentColor: Colors.deepOrangeAccent,
      ),
      home: SplashScreen(),
    );
  }
}
