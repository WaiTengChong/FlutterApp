import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddPost extends StatelessWidget {
  static const String routeName = "/AddPost";
  var title = "";
  var content = "";

  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();

  _postData(context) async {
    print("Attempting to fetch data from api");

    final url =
        "https://jzleyu8iq3.execute-api.eu-west-2.amazonaws.com/dev/post";

    print("data = " + contentController.text);

    Map data = {
      'userName': "Testing",
      'title': titleController.text,
      'body': contentController.text
    };
    print("data = " + data.toString());
    //encode Map to JSON
    var body = json.encode(data);
    print(body);

    final response = await http.post(url,
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
    print("Reloading...");

    _postData(context);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff191919),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff1d1d1d),
        title: Text(
          "Add Post",
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
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
                        contentPadding:
                            new EdgeInsets.fromLTRB(20.0, 10.0, 100.0, 10.0),
                        labelText: 'Title',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey)),
                  ))),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
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
                  ))),
          new RaisedButton(
            onPressed: () {
              postData(context);
            },
            child: const Text('Submit', style: TextStyle(fontSize: 20)),
            color: Colors.white,
            textColor: Colors.black,
            elevation: 5,
          )
        ],
      )),
    );
  }
}
