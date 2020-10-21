import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:your_thing/screens/dashboard.dart';
import 'package:your_thing/screens/homeScreen.dart';
import 'package:your_thing/screens/registerScreen.dart';
import 'package:your_thing/utils/url.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email = TextEditingController();
  var password = TextEditingController();
  bool isDone = false;

  Future _login() async {
    setState(() {
      isDone = true;
    });
    var e = email.text;
    var p = password.text;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var check;
    var msg;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(e);

    if (e != "" && p != "") {
      if (emailValid) {
        var data = {
          'email': e.trim(),
          'password': p.trim(),
        };

        var response = await http.post(URL + "login.php", body: data);
        check = response.body;
        print(check);

        if (check == '1') {
          setState(() {
            isDone = false;
          });
          preferences.setString('email', e);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DashBoard(),
          ));
        } else {
          setState(() {
            isDone = false;
          });
          msg = 'Email or Password is invalid';
          dialog(msg);
        }
      } else {
        setState(() {
          isDone = false;
        });
        msg = 'Please enter valid email';
        dialog(msg);
      }
    } else {
      setState(() {
        isDone = false;
      });
      msg = 'Please Fill all fields';
      dialog(msg);
    }
  }

  void dialog(var msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(msg),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  cursorColor: Colors.deepOrange,
                  keyboardType: TextInputType.emailAddress,
                  controller: email,
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  cursorColor: Colors.deepOrange,
                  controller: password,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                isDone
                    ? Container(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center,
                      )
                    : RaisedButton(
                        onPressed: () {
                          _login();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.deepOrange,
                      ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ));
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
