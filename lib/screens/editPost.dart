import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_thing/utils/url.dart';

class EditPost extends StatefulWidget {
  final id;
  EditPost(this.id);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  var _imageController;
  var _titleController;
  var _descriptionController;
  var _locationController;
  var _priceController;
  bool isRegistered = false;
  String email;

  void _getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  Future<List<dynamic>> getOldData() async {
    final response = await http.post(URL + "getAPostData.php", body: {
      'id': widget.id,
    });
    return json.decode(response.body);
  }

  String _title(dynamic data) {
    return data['title'];
  }

  String _image(dynamic data) {
    return data['image'];
  }

  String _desc(dynamic data) {
    return data['description'];
  }

  String _location(dynamic data) {
    return data['location'];
  }

  String _price(dynamic data) {
    return data['price'];
  }

  Future _editPost() async {
    setState(() {
      isRegistered = true;
    });

    var msg;
    var image = _imageController.text;
    var title = _titleController.text;
    var desc = _descriptionController.text;
    var location = _locationController.text;
    var price = _priceController.text;
    var date = DateTime.now().toString();

    if (title != "" &&
        image != "" &&
        desc != "" &&
        location != "" &&
        price != "" &&
        date != "") {
      var data = {
        'id': widget.id,
        'title': title,
        'desc': desc,
        'image': image,
        'location': location,
        'price': price,
      };

      var response = await http.post(URL + 'editPost.php', body: data);
      msg = response.body;
      _titleController.clear();
      _imageController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _priceController.clear();

      if (response.statusCode == 200) {
        if (msg == '0') {
          msg = 'Something went wrong';
          setState(() {
            isRegistered = false;
          });
          _dialog(msg);
        }
        if (msg == '1') {
          msg = 'Post Updated successfully';
          setState(() {
            isRegistered = false;
          });
          _titleController.clear();
          _imageController.clear();
          _descriptionController.clear();
          _locationController.clear();
          _priceController.clear();
          _dialog(msg);
        }
      } else {
        setState(() {
          isRegistered = false;
        });
        msg = 'Server problem occured';
        _dialog(msg);
      }
    } else {
      msg = "Please fill all fields";
      setState(() {
        isRegistered = false;
      });
      _dialog(msg);
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
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
            padding: EdgeInsets.all(8),
            child: Expanded(
              child: FutureBuilder(
                future: getOldData(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      _imageController = TextEditingController(
                          text: _image(snapshot.data[index]));
                      _titleController = TextEditingController(
                          text: _title(snapshot.data[index]));
                      _descriptionController = TextEditingController(
                          text: _desc(snapshot.data[index]));
                      _locationController = TextEditingController(
                          text: _location(snapshot.data[index]));
                      _priceController = TextEditingController(
                          text: _price(snapshot.data[index]));
                      return Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Update Post",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Title',
                              ),
                              controller: _titleController,
                            ),
                            TextField(
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Description',
                              ),
                              keyboardType: TextInputType.multiline,
                              controller: _descriptionController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Price',
                              ),
                              keyboardType: TextInputType.number,
                              controller: _priceController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Location',
                              ),
                              controller: _locationController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: _imageController.text.isEmpty == null
                                      ? Text('Enter Image URL')
                                      : FittedBox(
                                          child: Image.network(
                                            _imageController.text,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Image URL',
                                    ),
                                    keyboardType: TextInputType.url,
                                    controller: _imageController,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            isRegistered == false
                                ? RaisedButton(
                                    onPressed: _editPost,
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: Colors.deepOrange,
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
