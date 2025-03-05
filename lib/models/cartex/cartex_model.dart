// To parse this JSON data, do
//
//     final cartexGetModel = cartexGetModelFromJson(jsonString);

import 'dart:convert';

CartexGetModel cartexGetModelFromJson(String str) => CartexGetModel.fromJson(json.decode(str));

String cartexGetModelToJson(CartexGetModel data) => json.encode(data.toJson());

class CartexGetModel {
    int? count;
    List<Datum>? data;

    CartexGetModel({
        this.count,
        this.data,
    });

    factory CartexGetModel.fromJson(Map<String, dynamic> json) => CartexGetModel(
        count: json["count"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    DateTime? createAt;
    DateTime? updateAt;
    String? name;
    int? user;

    Datum({
        this.id,
        this.createAt,
        this.updateAt,
        this.name,
        this.user,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null ? null : DateTime.parse(json["update_at"]),
        name: utf8.decode(json["name"].codeUnits),
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "name": name,
        "user": user,
    };
}
