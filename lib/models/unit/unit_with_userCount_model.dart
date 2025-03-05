import 'dart:convert';

UnitWithUserCountModel unitWithUserCountModelFromJson(String str) => UnitWithUserCountModel.fromJson(json.decode(str));

String unitWithUserCountModelToJson(UnitWithUserCountModel data) => json.encode(data.toJson());

class UnitWithUserCountModel {
    int? totalUsersCount;
    List<Unit>? unit;

    UnitWithUserCountModel({
        this.totalUsersCount,
        this.unit,
    });

    factory UnitWithUserCountModel.fromJson(Map<String, dynamic> json) => UnitWithUserCountModel(
        totalUsersCount: json["total_users_count"],
        unit: json["unit"] == null ? [] : List<Unit>.from(json["unit"]!.map((x) => Unit.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_users_count": totalUsersCount,
        "unit": unit == null ? [] : List<dynamic>.from(unit!.map((x) => x.toJson())),
    };
}

class Unit {
    int? id;
    String? name;
    int? userCount;

    Unit({
        this.id,
        this.name,
        this.userCount,
    });

    factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
        userCount: json["user_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_count": userCount,
    };
}
