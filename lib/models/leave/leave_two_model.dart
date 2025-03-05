// To parse this JSON data, do
//
//     final leaveTwoModel = leaveTwoModelFromJson(jsonString);

import 'dart:convert';

LeaveTwoModel leaveTwoModelFromJson(String str) =>
    LeaveTwoModel.fromJson(json.decode(str));

String leaveTwoModelToJson(LeaveTwoModel data) => json.encode(data.toJson());

class LeaveTwoModel {
  List<Leave>? leaveEntries;
  List<Leave>? leaveDataClock;
  int? totalDaysSum;
  double? sumData;
  double? dayToClock;
  double? clockToDay;
  double? sumAllClock;
  double? sumAllDay;
  double? sumMonthDay;
  double? sumMonthClock;
  double? remainingDays;
  double? remainingHours;

  LeaveTwoModel({
    this.leaveEntries,
    this.leaveDataClock,
    this.totalDaysSum,
    this.sumData,
    this.dayToClock,
    this.clockToDay,
    this.sumAllClock,
    this.sumAllDay,
    this.sumMonthDay,
    this.sumMonthClock,
    this.remainingDays,
    this.remainingHours,
  });

  factory LeaveTwoModel.fromJson(Map<String, dynamic> json) => LeaveTwoModel(
        leaveEntries: json["leave_entries"] == null
            ? []
            : List<Leave>.from(
                json["leave_entries"]!.map((x) => Leave.fromJson(x))),
        leaveDataClock: json["leave_data_clock"] == null
            ? []
            : List<Leave>.from(
                json["leave_data_clock"]!.map((x) => Leave.fromJson(x))),
        totalDaysSum: json["total_days_sum"],
        sumData: json["sum_data"]?.toDouble(),
        dayToClock: json["day_to_clock"]?.toDouble(),
        clockToDay: json["clock_to_day"]?.toDouble(),
        sumAllClock: json["sum_all_clock"]?.toDouble(),
        sumAllDay: json["sum_all_day"]?.toDouble(),
        sumMonthDay: json["sum_month_day"]?.toDouble(),
        sumMonthClock: json["sum_month_clock"]?.toDouble(),
        remainingDays: json["remaining_days"]?.toDouble(),
        remainingHours: json["remaining_hours"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "leave_entries": leaveEntries == null
            ? []
            : List<dynamic>.from(leaveEntries!.map((x) => x.toJson())),
        "leave_data_clock": leaveDataClock == null
            ? []
            : List<dynamic>.from(leaveDataClock!.map((x) => x.toJson())),
        "total_days_sum": totalDaysSum,
        "sum_data": sumData,
        "day_to_clock": dayToClock,
        "clock_to_day": clockToDay,
        "sum_all_clock": sumAllClock,
        "sum_all_day": sumAllDay,
        "sum_month_day": sumMonthDay,
        "sum_month_clock": sumMonthClock,
        "remaining_days": remainingDays,
        "remaining_hours": remainingHours,
      };
}

class Leave {
  int? id;
  bool? isDays;
  bool? isClock;
  String? daysSelect;
  String? managerSelect;
  bool? isAccept;
  bool? managerAccept;
  bool? salonAccept;
  String? clockLeaveDate;
  String? daysStartDate;
  String? daysEndDate;
  String? clockStartTime;
  String? clockEndTime;
  String? description;
  String? allDate;
  String? createAt;
  String? updateAt;
  int? user;
  double? finalTime;
  int? totalDays;
  int? minusDate;
  bool? finalAccept;
  bool? isReject;

  Leave({
    this.id,
    this.isDays,
    this.isClock,
    this.daysSelect,
    this.managerSelect,
    this.isAccept,
    this.managerAccept,
    this.salonAccept,
    this.clockLeaveDate,
    this.daysStartDate,
    this.daysEndDate,
    this.clockStartTime,
    this.clockEndTime,
    this.description,
    this.allDate,
    this.createAt,
    this.updateAt,
    this.user,
    this.finalTime,
    this.totalDays,
    this.minusDate,
    this.finalAccept,
    this.isReject,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        id: json["id"],
        isDays: json["is_days"],
        isClock: json["is_clock"],
        daysSelect: json["days_select"],
        managerSelect: json["manager_select"],
        isAccept: json["is_accept"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        clockLeaveDate: json["clock_leave_date"],
        daysStartDate: json["days_start_date"],
        daysEndDate: json["days_end_date"],
        clockStartTime: json["clock_start_time"],
        clockEndTime: json["clock_end_time"],
        description: utf8.decode(json["description"].codeUnits),
        allDate: json["all_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        user: json["user"],
        isReject: json["is_reject"],
        finalAccept: json["final_accept"],
        finalTime: json["final_time"]?.toDouble(),
        totalDays: json["total_days"],
        minusDate: json["minus_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_days": isDays,
        "is_clock": isClock,
        "days_select": daysSelect,
        "manager_select": managerSelect,
        "is_accept": isAccept,
        "manager_accept": managerAccept,
        "salon_accept": isAccept,
        "clock_leave_date": clockLeaveDate,
        "days_start_date": daysStartDate,
        "days_end_date": daysEndDate,
        "clock_start_time": clockStartTime,
        "clock_end_time": clockEndTime,
        "description": description,
        "all_date": allDate,
        "create_at": createAt,
        "update_at": updateAt,
        "user": user,
        "is_reject": isReject,
        "final_accept": finalAccept,
        "final_time": finalTime,
        "total_days": totalDays,
        "minus_date": minusDate,
      };
}
