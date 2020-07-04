import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatelessWidget {
  static const String routeName = "/AddPost";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d1d1d),
      appBar: AppBar(
        backgroundColor: Color(0xff1d1d1d),
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Color(0xffc8c0b9),
                  border: OutlineInputBorder(),
                  contentPadding:
                      new EdgeInsets.fromLTRB(20.0, 10.0, 100.0, 10.0),
                  labelText: 'Title',
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextFormField(
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
                  labelStyle:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                validator: (value) =>
                    value.isNotEmpty ? null : 'content can\'t be empty',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
                //onSaved: (content) => _content = content,
              ))
        ],
      )),
    );
  }
}
