import 'dart:convert';

class Poi {
  Poi({
    this.id,
    this.name,
    this.image,
  });

  int id = -1;
  String name = 'UNKNOWN';
  String image;

  factory Poi.fromRawJson(String str) => Poi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Poi.fromJson(Map<String, dynamic> json) => Poi(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}
