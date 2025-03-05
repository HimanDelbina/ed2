// To parse this JSON data, do
//
//     final leaveModel = leaveModelFromJson(jsonString);

import 'dart:convert';

List<LeaveModel> leaveModelFromJson(String str) =>
    List<LeaveModel>.from(json.decode(str).map((x) => LeaveModel.fromJson(x)));

String leaveModelToJson(List<LeaveModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveModel {
  int? id;
  bool? isDays;
  bool? isClock;
  String? daysSelect;
  String? managerSelect;
  bool? isAccept;
  bool? isReject;
  DateTime? clockLeaveDate;
  DateTime? daysStartDate;
  DateTime? daysEndDate;
  String? clockStartTime;
  String? clockEndTime;
  String? description;
  DateTime? createAt;
  DateTime? updateAt;
  int? user;

  LeaveModel({
    this.id,
    this.isDays,
    this.isClock,
    this.daysSelect,
    this.managerSelect,
    this.isAccept,
    this.isReject,
    this.clockLeaveDate,
    this.daysStartDate,
    this.daysEndDate,
    this.clockStartTime,
    this.clockEndTime,
    this.description,
    this.createAt,
    this.updateAt,
    this.user,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        id: json["id"],
        isDays: json["is_days"],
        isClock: json["is_clock"],
        daysSelect: json["days_select"],
        managerSelect: json["manager_select"],
        isAccept: json["is_accept"],
        isReject: json["is_reject"],
        clockLeaveDate: json["clock_leave_date"] == null
            ? null
            : DateTime.parse(json["clock_leave_date"]),
        daysStartDate: json["days_start_date"] == null
            ? null
            : DateTime.parse(json["days_start_date"]),
        daysEndDate: json["days_end_date"] == null
            ? null
            : DateTime.parse(json["days_end_date"]),
        clockStartTime: json["clock_start_time"],
        clockEndTime: json["clock_end_time"],
        description: utf8.decode(json["description"].codeUnits),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_days": isDays,
        "is_clock": isClock,
        "days_select": daysSelect,
        "manager_select": managerSelect,
        "is_accept": isAccept,
        "is_reject": isReject,
        "clock_leave_date": clockLeaveDate?.toIso8601String(),
        "days_start_date": daysStartDate?.toIso8601String(),
        "days_end_date": daysEndDate?.toIso8601String(),
        "clock_start_time": clockStartTime,
        "clock_end_time": clockEndTime,
        "description": description,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "user": user,
      };
}
