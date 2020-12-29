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
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.white,
                        primaryColorDark: Colors.white,
                      ),
                      child: TextField(
                        controller: titleController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: new EdgeInsets.fromLTRB(
                                20.0, 10.0, 100.0, 10.0),
                            labelText: 'Title',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                      ))),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.white,
                        primaryColorDark: Colors.white,
                      ),
                      child: TextFormField(
                        controller: contentController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 16,
                        maxLength: 512,
                        maxLengthEnforced: true,
                        //initialValue: _content,
                        decoration: InputDecoration(
                            labelText: 'Content',
                            hintText: 'Enter contetn',
                            fillColor: Color(0xffc8c0b9),
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                            labelStyle: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey)),
                        validator: (value) =>
                            value.isNotEmpty ? null : 'content can\'t be empty',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        //onSaved: (content) => _content = content,
                      )))
            ],
          )),
    );
  }
}
