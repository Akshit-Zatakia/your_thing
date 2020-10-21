import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_thing/components/logo.dart';
import 'package:your_thing/screens/splashScreen.dart';
import 'package:your_thing/utils/url.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var fnm;
  var lnm;
  var email;
  var pwd;
  bool isDone = false;
  String e;

  Future<List<dynamic>> getOldData(String email) async {
    final response = await http.post(URL + "getUserData.php", body: {
      'email': email,
    });
    return json.decode(response.body);
  }

  String _fnm(dynamic data) {
    return data['first_name'];
  }

  String _lnm(dynamic data) {
    return data['last_name'];
  }

  String _password(dynamic data) {
    return data['pass'];
  }

  _getEmail() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      e = pre.getString('email').toString().trim();
    });
  }

  _removeEmail() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SplashScreen(),
    ));
  }

  Future _update() async {
    setState(() {
      isDone = true;
    });

    String f = fnm.text;
    String l = lnm.text;
    String e = email.text;
    String p = pwd.text;
    String msg;

    var check;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(e);

    if (f != null && l != null && e != null && p != null) {
      if (emailValid) {
        var data = {
          'fnm': f,
          'lnm': l,
          'email': e,
          'pwd': p,
        };

        var response =
            await http.post(URL + "updateUserProfile.php", body: data);
        check = response.body;
        if (check == '0') {
          msg = 'Some server error occured';
          setState(() {
            isDone = false;
          });
          _dialog(msg);
        } else {
          msg = 'Updated successfully';
          setState(() {
            isDone = false;
          });
          _dialog(msg);
        }
      } else {
        msg = "Please fill all fields";
        setState(() {
          isDone = false;
        });
        _dialog(msg);
      }
    }
  }

  void _dialog(String msg) {
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
              child: Text("ok"),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _getEmail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: FutureBuilder(
              future: getOldData(e),
              builder: (context, snapshot) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    fnm =
                        TextEditingController(text: _fnm(snapshot.data[index]));
                    lnm =
                        TextEditingController(text: _lnm(snapshot.data[index]));
                    email = TextEditingController(text: e);
                    pwd = TextEditingController(
                        text: _password(snapshot.data[index]));
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'First Name',
                          ),
                          cursorColor: Colors.deepOrange,
                          controller: fnm,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                          ),
                          cursorColor: Colors.deepOrange,
                          controller: lnm,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            counterText: "You can't change email",
                          ),
                          cursorColor: Colors.deepOrange,
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          cursorColor: Colors.deepOrange,
                          obscureText: true,
                          controller: pwd,
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
                                  _update();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Update",
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
                        FlatButton(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            _removeEmail();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      )),
    );
  }
}
