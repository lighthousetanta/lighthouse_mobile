import 'dart:convert';
import '/models/user.dart';

class Poi {
  Poi({this.id, this.name, this.image, this.reporter});

  int id = -1;
  String name = 'UNKNOWN';
  String image;
  User reporter;

  factory Poi.fromRawJson(String str) => Poi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Poi.fromJson(Map<String, dynamic> json) => Poi(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        reporter: User.fromJson(json["reported_by"]),
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "image": image, "reported_by": reporter.toJson()};
}
