import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Comments{
  List<Comment> comments;

  Comments({this.comments});

  factory Comments.fromJson(List<dynamic> parsedJson){

    List<Comment> comments = List<Comment>();
    comments = parsedJson.map((i)=>Comment.fromJson(i)).toList();

    return Comments(
      comments: comments,
    );
  }
}

class Comment {
    Comment({
        this.date,
        this.userName,
        this.body,
    });

    String date;
    String userName;
    String body;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        date: json["date"],
        userName: json["userName"],
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "userName": userName,
        "body": body,
    };
    
}