import 'dart:convert';

class User {
  int id;
  String username;

  User({this.id, this.username});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["user"],
      );

  Map<String, dynamic> toJson() => {"id": id, "user": username};
}
