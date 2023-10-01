// To parse this JSON data, do
//
//     final comments = commentsFromJson(jsonString);

import 'dart:convert';

List<Comments> commentsFromJson(String str) =>
    List<Comments>.from(json.decode(str).map((x) => Comments.fromJson(x)));

String commentsToJson(List<Comments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comments {
  DateTime dateCreated;
  String userDocId;
  String comment;
  String storeId;
  String userName;
  String id;

  Comments({
    required this.dateCreated,
    required this.userDocId,
    required this.comment,
    required this.storeId,
    required this.userName,
    required this.id,
  });

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        dateCreated: DateTime.parse(json["dateCreated"]),
        userDocId: json["userDocID"],
        comment: json["comment"],
        storeId: json["storeID"],
        userName: json["userName"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "dateCreated": dateCreated.toIso8601String(),
        "userDocID": userDocId,
        "comment": comment,
        "storeID": storeId,
        "userName": userName,
        "id": id,
      };
}
