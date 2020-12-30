import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Post extends StatelessWidget {
  static const String routeName = "/Post";

  final detials;
  Post(this.detials);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191919),
      appBar: AppBar(
        backgroundColor: Color(0xff1d1d1d),
        title: Text(detials["title"]),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          new Container(
              color: Color(0xff222222),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Text(
                detials["userName"],
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
                      detials["body"],
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Color(0xffc8c0b9), fontSize: 20),
                    ),
                    if (detials["image"] != null)
                      new Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: new CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                aspectRatio: 2.0,
                                enlargeCenterPage: true,
                              ),
                              items: detials["image"] == null
                                  ? []
                                  : detials["image"].map<Widget>((item) {
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
            itemCount: this.detials["comment"] != null
                ? this.detials["comment"].length
                : 0,
            itemBuilder: (context, rowNumber) {
              final comment = this.detials["comment"][rowNumber];
              return new Column(
                children: <Widget>[
                  new Container(
                      color: Color(0xff222222),
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        comment["userName"],
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(color: Color(0xff4A9BE0), fontSize: 15),
                      )),
                  new Container(
                      color: Color(0xff222222),
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, bottom: 20),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: new Text(
                        comment["body"],
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(color: Color(0xffc8c0b9), fontSize: 20),
                      )),
                ],
              );
            },
          )
        ],
      )),
    );
  }
}
