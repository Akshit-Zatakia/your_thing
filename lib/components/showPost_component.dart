import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:your_thing/screens/editPost.dart';
import 'package:http/http.dart' as http;
import 'package:your_thing/utils/url.dart';

class ShowPostComponent extends StatefulWidget {
  final bool yo;
  final id;
  final title;
  final image;
  final location;
  final price;
  ShowPostComponent(
      this.id, this.title, this.image, this.location, this.price, this.yo);

  @override
  _ShowPostComponentState createState() => _ShowPostComponentState();
}

class _ShowPostComponentState extends State<ShowPostComponent> {
  Future _deletePost() async {
    await http.post(URL + "deletePost.php", body: {'id': widget.id});
  }

  _dialog() {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this item ?'),
          actions: [
            FlatButton(
              onPressed: () {
                _deletePost();
              },
              child: Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
      context: context,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        color: const Color(0xffffffff),
        border: Border.all(width: 1.0, color: const Color(0xffe9e5e5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.0),
              image: DecorationImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            margin: EdgeInsets.all(8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(widget.location),
                  Text("Rs." +
                      NumberFormat('#,###')
                          .format(double.parse(widget.price))
                          .toString()),
                ]),
          ),
          widget.yo
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditPost(widget.id),
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {
                          _dialog();
                        },
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
