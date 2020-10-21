import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_thing/screens/dashboard.dart';
import 'package:your_thing/screens/loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future goToNextScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var str = preferences.getString('email');
    Timer(
        Duration(milliseconds: 2000),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => str == null ? LoginScreen() : DashBoard(),
            )));
  }

  @override
  void initState() {
    goToNextScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.0, color: const Color(0xffe3d2d2)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Your Thing',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
