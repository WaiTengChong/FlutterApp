import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      AllPost.routeName: (BuildContext context) => new AllPost(),
      LoginPage.routeName: (BuildContext context) => new LoginPage()
    };
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      routes: routes,
    );
  }
}

class LoginPage extends StatefulWidget {
  static const String routeName = "/LoginPage";

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

class AllPost extends StatefulWidget {
  static const String routeName = "/AllPost";

  @override
  _AllPostState createState() => new _AllPostState();
}

class _AllPostState extends State<StatefulWidget> {
  var _isLoading = true;
  var post;

  _fetchData() async {
    print("Attempting to fetch data from api");

    final url = "https://private-7e9736-flutter3.apiary-mock.com/post";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);

      final map = json.decode(response.body);
      final mapPost = map["post"];

      setState(() {
        _isLoading = false;
        this.post = mapPost;
      });
    }
  }

  Future<void> refresh() {
    print("Reloading...");
    setState(() {
      _isLoading = true;
    });
    _fetchData();
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            backgroundColor: Color(0xff1d1d1d),
            appBar: new AppBar(
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: new Text("Posts"),
              backgroundColor: Color(0xff1d1d1d),
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.refresh), onPressed: refresh)
              ],
            ),
            body: RefreshIndicator(
                onRefresh: refresh,
                child: new Center(
                    child: _isLoading
                        ? new CircularProgressIndicator()
                        : new ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: this.post != null ? this.post.length : 0,
                            itemBuilder: (context, rowNumber) {
                              final post = this.post[rowNumber];
                              return new GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Post(post)));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      new Container(
                                          width: 300,
                                          margin: const EdgeInsets.only(
                                              top: 5.0, bottom: 5.0),
                                          child: Text(
                                            post["userName"],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color(0xff33a1c3)),
                                          )),
                                      new Container(
                                          width: 300,
                                          child: new Text(
                                            post["title"],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color(0xffc8c0b9)),
                                          )),
                                      new Divider(color: Color(0xff353433))
                                    ],
                                  ));
                            },
                          )))));
  }
}

class Post extends StatelessWidget {
  static const String routeName = "/Post";

  final detials;
  Post(this.detials);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d1d1d),
      appBar: AppBar(
        backgroundColor: Color(0xff1d1d1d),
        title: Text(detials["userName"]),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          new Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 30, left: 20),
              child: Text(
                detials["title"],
                textAlign: TextAlign.start,
                style: TextStyle(color: Color(0xff33a1c3)),
              )),
          new Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Color(0xff222222),
              margin: const EdgeInsets.only(top: 20),
              child: new Text(
                detials["body"],
                textAlign: TextAlign.start,
                style: TextStyle(color: Color(0xffc8c0b9)),
              )),
          new Divider(color: Color(0xff353433)),
          new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: detials["image"] != null ? detials["image"].length : 0,
              itemBuilder: (context, rowNumber) {
                final image = detials["image"][rowNumber];
                return new Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: new Image.network(
                    image,
                    height: 200,
                    width: 200,
                  ),
                );
              })
        ],
      )),
    );
  }
}
