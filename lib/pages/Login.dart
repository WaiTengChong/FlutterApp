import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutterapp/link.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapp/pages/SignUp.dart';

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
  var userDetail;

  //This is to set the page not reload when changing tab to tab
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  _fetchData() async {
    print("Attempting to fetch data from api");

    final url = userLink +
        "/" +
        userNameController.text +
        "/" +
        passwordController.text;

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);

      final userDetail = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', true);
      print(
          'loggedIn Value saved -- ' + (prefs.getBool('loggedIn').toString()));
      setState(() {
        prefs.setString('userName', userDetail["userName"]);
        this.userDetail = prefs.getString('userName');
      });
    } else {
      print(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('loggedIn', false);
      print(
          'loggedIn Value saved -- ' + (prefs.getBool('loggedIn').toString()));
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

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    print('checked loggedIn Value saved -- ' +
        (prefs.getBool('loggedIn').toString()));
    var result = prefs.getBool('loggedIn') ?? false;

    this.userDetail = prefs.getString('userName') ?? "";
    return result;
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    print('checked loggedIn Value saved -- ' + (prefs.getString('userName')));
    var result = prefs.getString('userName');
    return result;
  }

  Future<void> login() {
    print("Loging in...");
    setState(() {});
    _fetchData();

    return Future.value();
  }

  Future<void> logout() async {
    print("Loging out...");
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
    prefs.setString('userName', "");
    setState(() {});
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xff191919),
          appBar: new AppBar(
            title: new Text("Login"),
            backgroundColor: Color(0xff1d1d1d),
          ),
          body: FutureBuilder<bool>(
            future:
                checkLogin(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return new ListView(children: <Widget>[
                    Center(
                        child: new Column(children: <Widget>[
                      Text(
                        "Welcome back " + userDetail + "!",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Color(0xff848484)),
                      ),
                      FlatButton.icon(
                          icon: Icon(Icons.arrow_right),
                          color: Colors.white,
                          onPressed: logout,
                          label: Text(
                            "Logout",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff191919)),
                          ))
                    ]))
                  ]);
                } else {
                  return new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Column(children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 70),
                        ),
                        Wrap(
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
                                    ))),
                            Container(
                                margin: const EdgeInsets.only(top: 30, left: 50),
                                child: FlatButton.icon(
                                    icon: Icon(Icons.arrow_right),
                                    color: Colors.white,
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Signup())),
                                    label: Text(
                                      "Sign Up",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff191919)),
                                    )))
                          ],
                        ),
                      ]));
                }
              } else if (snapshot.hasError) {
                children = <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[new CircularProgressIndicator()],
                ),
              );
            },
          ),
        ));
  }
}
