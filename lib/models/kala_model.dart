import 'dart:convert';

List<CommodityModel> commodityModelFromJson(String str) =>
    List<CommodityModel>.from(
        json.decode(str).map((x) => CommodityModel.fromJson(x)));

String commodityModelToJson(List<CommodityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommodityModel {
  int? id;
  String? name;
  String? code;
  String? unit;

  CommodityModel({
    this.id,
    this.name,
    this.code,
    this.unit,
  });

  factory CommodityModel.fromJson(Map<String, dynamic> json) => CommodityModel(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
        code: json["code"],
        unit: utf8.decode(json["unit"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "unit": unit,
      };
}
