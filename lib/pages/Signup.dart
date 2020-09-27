import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../link.dart';

class Signup extends StatefulWidget {
  static const String routeName = "/Signup";

  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  int group;

  @override
  void initState() {
    setState(() {
      group = 1;
    });
    super.initState();
  }

  Future<void> postData(context) {
    print("Signing up...");

    _postData(context);
    return Future.value();
  }

  _postData(context) async {
    Map data = {
      'userName': userNameController.text,
      'password': passwordController.text,
      'email': emailController.text,
      'gender': group.toString()
    };
    print("data = " + data.toString());
    //encode Map to JSON
    var body = json.encode(data);
    print(body);

    final response = await http.post(userLink,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      print(response.body);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("User created. Welcome " + userNameController.text),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff191919),
        appBar: new AppBar(
          title: new Text("Sign Up"),
          backgroundColor: Color(0xff1d1d1d),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Theme(
                data: new ThemeData(
                  primaryColor: Colors.white,
                  primaryColorDark: Colors.white,
                  unselectedWidgetColor: Colors.white,
                ),
                child: new Wrap(children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                  ),
                  Column(
                    children: <Widget>[
                      TextField(
                        autofocus: false,
                        style:
                            TextStyle(fontSize: 22.0, color: Color(0xff191919)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Username',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        controller: userNameController,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: TextField(
                            autofocus: false,
                            style: TextStyle(
                                fontSize: 22.0, color: Color(0xFFbdc6cf)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Pasword',
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            controller: passwordController,
                          )),
                      Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: TextField(
                            autofocus: false,
                            style: TextStyle(
                                fontSize: 22.0, color: Color(0xff191919)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            controller: emailController,
                          )),
                      Container(
                        height: 30.0,
                        margin: const EdgeInsets.only(top: 30, left: 45),
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Text("Male",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                            Padding(padding: EdgeInsets.all(5.00)),
                            Radio(
                                value: 1,
                                groupValue: group,
                                activeColor: Colors.white,
                                onChanged: (int e) {
                                  setState(() {
                                    group = e;
                                  });
                                  print(e);
                                }),
                            Padding(padding: EdgeInsets.all(5.00)),
                            Text("Female",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white)),
                            Radio(
                                value: 0,
                                groupValue: group,
                                activeColor: Colors.white,
                                onChanged: (int e) {
                                  setState(() {
                                    group = e;
                                  });
                                  print(e);
                                }),
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: FlatButton.icon(
                              icon: Icon(Icons.arrow_right),
                              color: Colors.white,
                              onPressed: () {
                                postData(context);
                              },
                              label: Text(
                                "Sign up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff191919)),
                              )))
                    ],
                  ),
                ]))));
  }
}
