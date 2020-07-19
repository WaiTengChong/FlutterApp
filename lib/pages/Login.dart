import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutterapp/link.dart';
import 'package:flutterapp/globals.dart' as globals;

class Login extends StatefulWidget {
  static const String routeName = "/Login";

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login>
    with AutomaticKeepAliveClientMixin<Login> {
  var userName = "";
  var password = "";

  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  var _loggedIn = false;
  var userDetail;

  //This is to set the page not reload when changing tab to tab
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    login().then((value) {
      print('Async done');
    });
    super.initState();
  }

  _fetchData() async {
    print("Attempting to fetch data from api");

    final url = userLink +
        "/" +
        userNameController.text +
        "/" +
        passwordController.text;
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);

      final userDetail = json.decode(response.body);

      setState(() {
        _loggedIn = false;
        this.userDetail = userDetail;
        globals.globalUserName = userDetail["userName"];
      });
    } else {
      print(response.body);
      final error = json.decode(response.body)["error"];
      if (error != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(error),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Error something missing"),
            );
          },
        );
      }
    }
  }

  Future<void> login() {
    print("Reloading...");
    _fetchData();
    setState(() {
      _loggedIn = true;
    });
    return Future.value();
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
              child: _loggedIn
                  ? new Padding(
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
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(25.7),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(25.7),
                                    ),
                                  ),
                                  controller: passwordController,
                                )),
                            Container(
                                margin: const EdgeInsets.only(top: 30),
                                child: FlatButton.icon(
                                    icon: Icon(Icons.arrow_right),
                                    color: Colors.white,
                                    onPressed: login,
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
                      ]))
                  : new Container(
                      child: Text(
                        "Welcome back " + userDetail["userName"] + "!",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Color(0xff848484)),
                      )),
            )));
  }
}
