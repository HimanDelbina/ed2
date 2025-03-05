import 'dart:convert';

List<AccessModel> accessModelFromJson(String str) => List<AccessModel>.from(
    json.decode(str).map((x) => AccessModel.fromJson(x)));

String accessModelToJson(List<AccessModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccessModel {
  int? id;
  String? name;
  String? tag;

  AccessModel({
    this.id,
    this.name,
    this.tag,
  });

  factory AccessModel.fromJson(Map<String, dynamic> json) => AccessModel(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
      };
}
