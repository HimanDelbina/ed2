// To parse this JSON data, do
//
//     final unitModel = unitModelFromJson(jsonString);

import 'dart:convert';

List<UnitModel> unitModelFromJson(String str) => List<UnitModel>.from(json.decode(str).map((x) => UnitModel.fromJson(x)));

String unitModelToJson(List<UnitModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnitModel {
    int? id;
    String? name;

    UnitModel({
        this.id,
        this.name,
    });

    factory UnitModel.fromJson(Map<String, dynamic> json) => UnitModel(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
