import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:your_thing/screens/loginScreen.dart';
import 'package:your_thing/utils/url.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var fnm = TextEditingController();
  var lnm = TextEditingController();
  var email = TextEditingController();
  var pwd = TextEditingController();
  bool isDone = false;

  Future _register() async {
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

        var response = await http.post(URL + "register.php", body: data);
        check = response.body;
        if (check == '0') {
          setState(() {
            msg = 'Some server error occured';
            isDone = false;
          });
        } else {
          setState(() {
            msg = 'Registered successfully';
            isDone = false;
          });
        }
      } else {
        setState(() {
          msg = "Please fill all fields";
          isDone = false;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(msg),
          actions: [
            FlatButton(
              onPressed: () {
                if (check == '0') {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
                }
              },
              child: Text("ok"),
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
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Register',
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
                decoration: InputDecoration(
                  labelText: 'Email',
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
                        _register();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Register",
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
            ],
          ),
        ),
      )),
    );
  }
}
