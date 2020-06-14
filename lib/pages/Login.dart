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
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Scaffold(
            backgroundColor: Color(0xff1d1d1d),
            appBar: new AppBar(
              title: new Text("Login"),
              backgroundColor: Color(0xff1d1d1d),
            ),
            body: new Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (text) {
                        print("First text field: $text");
                      },
                    ),
                    TextField(
                      controller: myController,
                    ),
                    FlatButton.icon(
                        icon: Icon(Icons.refresh),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, AllPost.routeName);
                        },
                        label: Text(
                          "My Orders",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),
                        ))
                  ],
                ),
              ),
            )));
  }
}
