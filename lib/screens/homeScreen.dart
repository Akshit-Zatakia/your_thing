import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:your_thing/components/showPost_component.dart';
import 'package:http/http.dart' as http;
import 'package:your_thing/screens/detailsScreen.dart';
import 'package:your_thing/utils/url.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future _data;
  String email;
  String e;

  Future _getPosts() async {
    var data1 = {
      'email': e.toString().trim(),
    };
    var response = await http.post(URL + "viewPost.php", body: data1);
    return json.decode(response.body);
  }

  @override
  void initState() {
    _data = _getPosts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Posts',
          style: TextStyle(
            color: Colors.deepOrange,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.deepOrange,
            ),
            onPressed: () {
              setState(() {
                _data = _getPosts();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          if (snapshot.data.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No data!"),
                  RaisedButton(
                    color: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        _data = _getPosts();
                      });
                    },
                    child: Text(
                      'Reload',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var id = snapshot.data[index]['post_id'];
                var title = snapshot.data[index]['title'];
                var image = snapshot.data[index]['image'];
                var location = snapshot.data[index]['location'];
                var price = snapshot.data[index]['price'];
                var desc = snapshot.data[index]['description'];
                var email = snapshot.data[index]['email'];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            title,
                            image,
                            desc,
                            location,
                            price,
                            email,
                          ),
                        ));
                  },
                  child: ShowPostComponent(
                    id,
                    title,
                    image,
                    location,
                    price,
                    false,
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
