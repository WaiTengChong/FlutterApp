import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<StatefulWidget> {
  var _isLoading = true;
  var post;

  _fetchData() async {
    print("Attempting to fetch data from api");

    final url = "http://127.0.0.1:3000/json";
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
                                          builder: (context) => Post(post)),
                                    );
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
  final detials;
  Post(this.detials);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d1d1d),
      appBar: AppBar(
        backgroundColor: Color(0xff1d1d1d),
        title: Text(detials["title"]),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          new Container(
              width: 300,
              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text(
                detials["userName"],
                textAlign: TextAlign.start,
                style: TextStyle(color: Color(0xff33a1c3)),
              )),
          new Container(
              width: 300,
              child: new Text(
                detials["body"],
                textAlign: TextAlign.start,
                style: TextStyle(color: Color(0xffc8c0b9)),
              )),
          new Divider(color: Color(0xff353433))
        ],
      )),
    );
  }
}
