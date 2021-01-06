import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/object/comment.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterapp/link.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReplyPost extends StatelessWidget {
  static const String routeName = "/ReplyPost";
  final comments;
  var time;
  ReplyPost(this.comments);
  TextEditingController contentController = new TextEditingController();

  _postData(context) async {
    var userName = "Unknown User";
    final prefs = await SharedPreferences.getInstance();
    var allComments = this.comments["comments"];

    print('checked loggedIn Value saved -- ' + (prefs.getString('userName')));
    var result = prefs.getString('userName');

    if (result != "" || result != null) {
      userName = result;
    }

    Map data = {
      'date' : time,
      'userName': userName,
      'body': contentController.text
    };

   allComments.add(data);

    Map addedComments = {
      'comments': allComments
    };
    //encode Map to JSON
    var body = json.encode(addedComments);
    print('body = ' + body);

    final response = await http.put(addPostLink+'/'+this.comments['id'],
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      print(response.body);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Success"),
          );
        },
      ).then((val) {
        Navigator.of(context).pop(true);
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


  Future<String> _fetchComment() async {
    print("Attempting to fetch data from api");

    final response = await http.get(timeLink);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      return map['currentDateTime'].toString();

    }else{
      return "error";
    }
    
  }

  Future<void> postData(context) async{
    print("Adding comment...");
    time = await _fetchComment();
    
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
          "Reply Post",
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.send, color: Colors.white),
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
                  padding: EdgeInsets.only(top: 30.0, left : 15 , right: 15),
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
                            labelText: 'Comment',
                            hintText: 'Enter comment',
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
