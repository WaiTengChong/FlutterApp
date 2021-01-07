import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutterapp/pages/ReplyPost.dart';
import 'package:http/http.dart' as http;
import '../link.dart';
import 'dart:convert';

class Post extends StatefulWidget {
  static const String routeName = "/Post";
  final detials;
  Post(this.detials);
  @override
  _PostState createState() => new _PostState();
}

class _PostState extends State<Post>
    with AutomaticKeepAliveClientMixin<Post>, WidgetsBindingObserver {
  var fromReply = false;
  var newPost;
  var _isLoading;

  //This is to set the page not reload when changing tab to tab
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    newPost = widget.detials;
    fromReply = false;
    super.initState();
  }

  _fetchData() async {
    print("Attempting to fetch data from api");

    final response = await http.get(addPostLink + "/" + widget.detials['id']);

    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      final mapPost = map;

      setState(() {
        _isLoading = false;
        newPost = mapPost;
        fromReply = true;
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
    return Scaffold(
      backgroundColor: Color(0xff191919),
      appBar: AppBar(
        backgroundColor: Color(0xff1d1d1d),
        title: Text(widget.detials["title"]),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.reply, color: Colors.white),
              onPressed: () => _navigateAndRefresh(context))
        ],
      ),
      body: new RefreshIndicator(onRefresh: refresh, child: _body(fromReply ?? false)),
    );
  }

  Widget _body(bool isFromRely) {
    var post;
    print("_body in with $isFromRely");
    if (isFromRely) {
      post = this.newPost;
    } else {
      post = widget.detials;
    }
    return new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: 1,
        itemBuilder: (context, rowNumber) {
          return new SingleChildScrollView(
              child: Column(
            children: <Widget>[
              new Container(
                  color: Color(0xff222222),
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    post["userName"],
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Color(0xff4A9BE0), fontSize: 15),
                  )),
              new Container(
                  color: Color(0xff222222),
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 10, left: 20, bottom: 20),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          post["body"],
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(color: Color(0xffc8c0b9), fontSize: 20),
                        ),
                        if (post["image"] != null)
                          new Container(
                              padding: const EdgeInsets.only(top: 20),
                              child: new CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                  ),
                                  items: post["image"] == null
                                      ? []
                                      : post["image"].map<Widget>((item) {
                                          return Builder(
                                              builder: (BuildContext context) {
                                            return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                ),
                                                child: Image.network(
                                                  item,
                                                  fit: BoxFit.fill,
                                                ));
                                          });
                                        }).toList()))
                      ])),
              new ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                    post["comments"] != null ? post["comments"].length : 0,
                itemBuilder: (context, rowNumber) {
                  final comments = post["comments"][rowNumber];
                  return new Column(
                    children: <Widget>[
                      new Container(
                          color: Color(0xff222222),
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            comments["userName"],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color(0xff4A9BE0), fontSize: 15),
                          )),
                      new Container(
                          color: Color(0xff222222),
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, bottom: 20),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: new Text(
                            comments["body"],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color(0xffc8c0b9), fontSize: 20),
                          )),
                    ],
                  );
                },
              )
            ],
          ));
        });
  }

  _navigateAndRefresh(BuildContext context) async {
    this.fromReply = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReplyPost(widget.detials)));
    refresh();
  }
}
