import 'dart:convert';

LeaveReportUnitModel leaveReportUnitModelFromJson(String str) =>
    LeaveReportUnitModel.fromJson(json.decode(str));

String leaveReportUnitModelToJson(LeaveReportUnitModel data) =>
    json.encode(data.toJson());

class LeaveReportUnitModel {
  int? unit;
  List<User>? users;

  LeaveReportUnitModel({
    this.unit,
    this.users,
  });

  factory LeaveReportUnitModel.fromJson(Map<String, dynamic> json) =>
      LeaveReportUnitModel(
        unit: json["unit"],
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unit": unit,
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class User {
  int? userId;
  String? userName;
  double? dailyLeaves;
  double? clockLeaves;
  double? convertedDaysToClock;
  double? convertedClockToDays;
  double? totalLeavesInDays;
  double? totalLeavesInHours;

  User({
    this.userId,
    this.userName,
    this.dailyLeaves,
    this.clockLeaves,
    this.convertedDaysToClock,
    this.convertedClockToDays,
    this.totalLeavesInDays,
    this.totalLeavesInHours,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: utf8.decode(json["user_name"].codeUnits),
        dailyLeaves: json["daily_leaves"]?.toDouble(),
        clockLeaves: json["clock_leaves"]?.toDouble(),
        convertedDaysToClock: json["converted_days_to_clock"]?.toDouble(),
        convertedClockToDays: json["converted_clock_to_days"]?.toDouble(),
        totalLeavesInDays: json["total_leaves_in_days"]?.toDouble(),
        totalLeavesInHours: json["total_leaves_in_hours"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "daily_leaves": dailyLeaves,
        "clock_leaves": clockLeaves,
        "converted_days_to_clock": convertedDaysToClock,
        "converted_clock_to_days": convertedClockToDays,
        "total_leaves_in_days": totalLeavesInDays,
        "total_leaves_in_hours": totalLeavesInHours,
      };
}
