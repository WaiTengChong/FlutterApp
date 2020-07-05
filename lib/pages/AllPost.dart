import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutterapp/pages/Post.dart';
import 'package:flutterapp/pages/AddPost.dart';

class AllPost extends StatefulWidget {
  static const String routeName = "/AllPost";

  @override
  _AllPostState createState() => new _AllPostState();
}

class _AllPostState extends State<AllPost>
    with AutomaticKeepAliveClientMixin<AllPost> {
  var _isLoading = false;
  var post;

  //This is to set the page not reload when changing tab to tab
  @override
  bool get wantKeepAlive => true;

    @override
  void initState() {
    refresh().then((value){
      print('Async done');
    });
    super.initState();
  }

  _fetchData() async {
    print("Attempting to fetch data from api");

    final url =
        "https://jzleyu8iq3.execute-api.eu-west-2.amazonaws.com/dev/posts";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);

      final map = json.decode(response.body);
      final mapPost = map;

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
                icon: new Icon(Icons.add, color: Color(0xffc8c0b9)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPost())),
              ),
              title: new Text("Posts"),
              backgroundColor: Color(0xff1d1d1d),
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.refresh), onPressed: refresh)
              ],
            ),
            body: new RefreshIndicator(
                onRefresh: refresh,
                child: new Center(
                    child: new ListView.builder(
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
                                  style: TextStyle(color: Color(0xff33a1c3)),
                                )),
                            new Container(
                                width: 300,
                                child: new Text(
                                  post["title"],
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Color(0xffc8c0b9)),
                                )),
                            new Divider(color: Color(0xff353433))
                          ],
                        ));
                  },
                )))));
  }
}
