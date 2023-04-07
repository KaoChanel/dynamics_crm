// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

Blog blogFromJson(String str) => Blog.fromJson(json.decode(str));

List<Blog> blogListFromJson(String str) => List<Blog>.from(json.decode(str).map((x) => Blog.fromJson(x)));

String blogToJson(Blog data) => json.encode(data.toJson());

String blogListToJson(List<Blog> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Blog {
  Blog({
    this.newsId,
    this.title,
    this.description,
    this.remark,
    this.attachment,
    this.mention,
    this.hashTag,
    this.createDate,
    this.createBy,
    this.updateDate,
    this.updateBy,
  });

  int? newsId;
  String? title;
  String? description;
  String? remark;
  String? attachment;
  String? mention;
  String? hashTag;
  DateTime? createDate;
  String? createBy;
  DateTime? updateDate;
  String? updateBy;

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
    newsId: json["newsId"] == null ? null : json["newsId"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    remark: json["remark"] == null ? null : json["remark"],
    attachment: json["attachment"] == null ? null : json["attachment"],
    mention: json["mention"] == null ? null : json["mention"],
    hashTag: json["hashTag"] == null ? null : json["hashTag"],
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
    createBy: json["createBy"] == null ? null : json["createBy"],
    updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
    updateBy: json["updateBy"] == null ? null : json["updateBy"],
  );

  Map<String, dynamic> toJson() => {
    "newsId": newsId == null ? null : newsId,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "remark": remark == null ? null : remark,
    "attachment": attachment == null ? null : attachment,
    "mention": mention == null ? null : mention,
    "hashTag": hashTag == null ? null : hashTag,
    "createDate": createDate == null ? null : createDate!.toIso8601String(),
    "createBy": createBy == null ? null : createBy,
    "updateDate": updateDate == null ? null : updateDate!.toIso8601String(),
    "updateBy": updateBy == null ? null : updateBy,
  };
}
