// // import 'package:the_lighthouse/models/user.dart';

// import 'package:json_annotation/json_annotation.dart';

// part 'poi.g.dart';

// @JsonSerializable(explicitToJson: true)
// class Poi {
//   int id;
//   String name;
//   // final int age;
//   // final String address;
//   List<String> images;
//   // final User contact;
//   Poi(
//       {this.id,
//       this.name,
//       // this.age = 999,
//       // this.contact,
//       // this.address = 'Unknown',
//       this.images});
//   factory Poi.fromJson(Map<String, dynamic> data) => _$PoiFromJson(data);
//   Map<String, dynamic> toJson() => _$PoiToJson(this);
// }
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