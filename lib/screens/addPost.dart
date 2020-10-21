import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_thing/utils/url.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var _imageController = TextEditingController();
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _locationController = TextEditingController();
  var _priceController = TextEditingController();
  bool isRegistered = false;
  String email;

  void _getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString('email');
    });
  }

  Future _addPost() async {
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
        'email': email.trim(),
        'title': title,
        'desc': desc,
        'image': image,
        'location': location,
        'price': price,
        'date': date,
      };

      var response = await http.post(URL + 'addPost.php', body: data);
      msg = response.body;
      _titleController.clear();
      _imageController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _priceController.clear();

      if (response.statusCode == 200) {
        setState(() {
          isRegistered = false;
        });
        if (msg == 0) {
          msg = 'Something went wrong';
        }
        if (msg == 1) {
          msg = 'Post Added successfully';
          _titleController.clear();
          _imageController.clear();
          _descriptionController.clear();
          _locationController.clear();
          _priceController.clear();
        }
      } else {
        setState(() {
          isRegistered = false;
        });
        msg = 'Server problem occured';
      }
    } else {
      msg = "Please fill all fields";
      setState(() {
        isRegistered = false;
      });
    }

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
        child: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add Post",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
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
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.2,
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
                      onPressed: _addPost,
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.deepOrange,
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.03,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
