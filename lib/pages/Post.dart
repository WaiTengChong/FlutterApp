import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
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
