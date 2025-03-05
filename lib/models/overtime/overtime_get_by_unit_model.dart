// To parse this JSON data, do
//
//     final ovretimeReportUnitModel = ovretimeReportUnitModelFromJson(jsonString);

import 'dart:convert';

OvretimeReportUnitModel ovretimeReportUnitModelFromJson(String str) => OvretimeReportUnitModel.fromJson(json.decode(str));

String ovretimeReportUnitModelToJson(OvretimeReportUnitModel data) => json.encode(data.toJson());

class OvretimeReportUnitModel {
    String? unit;
    List<User>? users;

    OvretimeReportUnitModel({
        this.unit,
        this.users,
    });

    factory OvretimeReportUnitModel.fromJson(Map<String, dynamic> json) => OvretimeReportUnitModel(
        unit: json["unit"],
        users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "unit": unit,
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
    };
}

class User {
    int? id;
    String? name;
    List<OvertimeSummary>? overtimeSummary;

    User({
        this.id,
        this.name,
        this.overtimeSummary,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
        overtimeSummary: json["overtime_summary"] == null ? [] : List<OvertimeSummary>.from(json["overtime_summary"]!.map((x) => OvertimeSummary.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overtime_summary": overtimeSummary == null ? [] : List<dynamic>.from(overtimeSummary!.map((x) => x.toJson())),
    };
}

class OvertimeSummary {
    String? select;
    double? totalTime;

    OvertimeSummary({
        this.select,
        this.totalTime,
    });

    factory OvertimeSummary.fromJson(Map<String, dynamic> json) => OvertimeSummary(
        select: json["select"],
        totalTime: json["total_time"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "select": select,
        "total_time": totalTime,
    };
}
