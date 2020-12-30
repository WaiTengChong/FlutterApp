import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterapp/link.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPost extends StatelessWidget {
  static const String routeName = "/AddPost";

  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();

  _postData(context) async {
    var userName = "Unknown User";
    final prefs = await SharedPreferences.getInstance();

    print('checked loggedIn Value saved -- ' + (prefs.getString('userName')));
    var result = prefs.getString('userName');

    if (result != "" || result != null) {
      userName = result;
    }

    Map data = {
      'userName': userName,
      'title': titleController.text,
      'body': contentController.text
    };
    print("data = " + data.toString());
    //encode Map to JSON
    var body = json.encode(data);
    print(body);

    final response = await http.post(addPostLink,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      print(response.body);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Success"),
          );
        },
      ).then((val) {
        Navigator.of(context).pop();
      });
    } else {
      print(response.body);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(json.decode(response.body)["error"]),
          );
        },
      );
    }
  }

  Future<void> postData(context) {
    print("Adding post...");

    _postData(context);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xff191919),
      appBar: AppBar(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1d1d1d),
        title: Text(
          "Add Post",
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add, color: Colors.white),
              onPressed: () {
                postData(context);
              })
        ],
      ),
      body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.white,
                        primaryColorDark: Colors.white,
                      ),
                      child: TextField(
                        cursorColor: Colors.white,
                        controller: titleController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xff222222),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 3.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            contentPadding: new EdgeInsets.fromLTRB(
                                10.0, 30.0, 100.0, 10.0),
                            labelText: 'Title',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ))),
              Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.white,
                        primaryColorDark: Colors.white,
                      ),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: contentController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 16,
                        maxLength: 512,
                        maxLengthEnforced: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xff222222),
                            labelText: 'Content',
                            hintText: 'Enter content',
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 3.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        validator: (value) =>
                            value.isNotEmpty ? null : 'content can\'t be empty',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      )))
            ],
          )),
    );
  }
}
