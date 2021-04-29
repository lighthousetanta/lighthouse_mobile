import 'dart:convert';

class Poi {
  Poi({
    this.id,
    this.name,
    this.images,
  });

  final int id;
  final String name;
  final List<String> images;

  factory Poi.fromRawJson(String str) => Poi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Poi.fromJson(Map<String, dynamic> json) => Poi(
        id: json["id"],
        name: json["name"],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
