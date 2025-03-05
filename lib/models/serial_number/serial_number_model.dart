import 'dart:convert';

List<SerialNumberModel> serialNumberModelFromJson(String str) =>
    List<SerialNumberModel>.from(
        json.decode(str).map((x) => SerialNumberModel.fromJson(x)));

String serialNumberModelToJson(List<SerialNumberModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SerialNumberModel {
  int? id;
  DateTime? createAt;
  String? name;
  String? serial;

  SerialNumberModel({
    this.id,
    this.createAt,
    this.name,
    this.serial,
  });

  factory SerialNumberModel.fromJson(Map<String, dynamic> json) =>
      SerialNumberModel(
        id: json["id"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        name: utf8.decode(json["name"].codeUnits),
        serial: json["serial"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": createAt?.toIso8601String(),
        "name": name,
        "serial": serial,
      };
}
