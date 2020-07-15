import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/AllPost.dart';

class Login extends StatefulWidget {
  static const String routeName = "/Login";

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xff191919),
            appBar: new AppBar(
              title: new Text("Login"),
              backgroundColor: Color(0xff1d1d1d),
            ),
            body: new Center(
              child: new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Column(children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 70),
                    ),
                    Column(
                      children: <Widget>[
                        TextField(
                          autofocus: false,
                          style: TextStyle(
                              fontSize: 22.0, color: Color(0xff191919)),
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
                          onChanged: (text) {
                            print("First text field: $text");
                          },
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
                              controller: myController,
                            )),
                        Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: FlatButton.icon(
                                icon: Icon(Icons.arrow_right),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AllPost.routeName);
                                },
                                label: Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff191919)),
                                )))
                      ],
                    ),
                  ])),
            )));
  }
}
