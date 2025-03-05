import 'dart:convert';

OvretimeReportAllModel ovretimeReportAllModelFromJson(String str) =>
    OvretimeReportAllModel.fromJson(json.decode(str));

String ovretimeReportAllModelToJson(OvretimeReportAllModel data) =>
    json.encode(data.toJson());

class OvretimeReportAllModel {
  List<User>? users;

  OvretimeReportAllModel({
    this.users,
  });

  factory OvretimeReportAllModel.fromJson(Map<String, dynamic> json) =>
      OvretimeReportAllModel(
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
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
        overtimeSummary: json["overtime_summary"] == null
            ? []
            : List<OvertimeSummary>.from(json["overtime_summary"]!
                .map((x) => OvertimeSummary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overtime_summary": overtimeSummary == null
            ? []
            : List<dynamic>.from(overtimeSummary!.map((x) => x.toJson())),
      };
}

class OvertimeSummary {
  String? select;
  double? totalTime;

  OvertimeSummary({
    this.select,
    this.totalTime,
  });

  factory OvertimeSummary.fromJson(Map<String, dynamic> json) =>
      OvertimeSummary(
        select: json["select"],
        totalTime: json["total_time"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "select": select,
        "total_time": totalTime,
      };
}
