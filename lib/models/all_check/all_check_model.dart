import 'dart:convert';

AllCheckModel allCheckModelFromJson(String str) =>
    AllCheckModel.fromJson(json.decode(str));

String allCheckModelToJson(AllCheckModel data) => json.encode(data.toJson());

class AllCheckModel {
  int? totalDaysSum;
  double? sumData;
  double? dayToClock;
  double? clockToDay;
  double? sumAllClock;
  double? sumAllDay;
  double? sumMonthDay;
  double? sumMonthClock;
  double? remainingDaysLeave;
  double? remainingHours;
  SumDataBySelect? sumDataBySelect;
  int? gharardadDaysBetween;
  int? gharardadRemainingDays;
  DateTime? gharardadStartGh;
  DateTime? gharardadEndGh;

  AllCheckModel({
    this.totalDaysSum,
    this.sumData,
    this.dayToClock,
    this.clockToDay,
    this.sumAllClock,
    this.sumAllDay,
    this.sumMonthDay,
    this.sumMonthClock,
    this.remainingDaysLeave,
    this.remainingHours,
    this.sumDataBySelect,
    this.gharardadDaysBetween,
    this.gharardadRemainingDays,
    this.gharardadStartGh,
    this.gharardadEndGh,
  });

  factory AllCheckModel.fromJson(Map<String, dynamic> json) => AllCheckModel(
        totalDaysSum: json["total_days_sum"],
        sumData: json["sum_data"]?.toDouble(),
        dayToClock: json["day_to_clock"]?.toDouble(),
        clockToDay: json["clock_to_day"]?.toDouble(),
        sumAllClock: json["sum_all_clock"]?.toDouble(),
        sumAllDay: json["sum_all_day"]?.toDouble(),
        sumMonthDay: json["sum_month_day"]?.toDouble(),
        sumMonthClock: json["sum_month_clock"]?.toDouble(),
        remainingDaysLeave: json["remaining_days_leave"],
        remainingHours: json["remaining_hours"]?.toDouble(),
        sumDataBySelect: json["sum_data_by_select"] == null
            ? null
            : SumDataBySelect.fromJson(json["sum_data_by_select"]),
        gharardadDaysBetween: json["gharardad_days_between"],
        gharardadRemainingDays: json["gharardad_remaining_days"],
        gharardadStartGh: json["gharardad_start_gh"] == null
            ? null
            : DateTime.parse(json["gharardad_start_gh"]),
        gharardadEndGh: json["gharardad_end_gh"] == null
            ? null
            : DateTime.parse(json["gharardad_end_gh"]),
      );

  Map<String, dynamic> toJson() => {
        "total_days_sum": totalDaysSum,
        "sum_data": sumData,
        "day_to_clock": dayToClock,
        "clock_to_day": clockToDay,
        "sum_all_clock": sumAllClock,
        "sum_all_day": sumAllDay,
        "sum_month_day": sumMonthDay,
        "sum_month_clock": sumMonthClock,
        "remaining_days_leave": remainingDaysLeave,
        "remaining_hours": remainingHours,
        "sum_data_by_select": sumDataBySelect?.toJson(),
        "gharardad_days_between": gharardadDaysBetween,
        "gharardad_remaining_days": gharardadRemainingDays,
        "gharardad_start_gh": gharardadStartGh?.toIso8601String(),
        "gharardad_end_gh": gharardadEndGh?.toIso8601String(),
      };
}

class SumDataBySelect {
  double? go;
  double? ez;
  double? ta;
  double? ma;

  SumDataBySelect({
    this.go,
    this.ez,
    this.ta,
    this.ma,
  });

  factory SumDataBySelect.fromJson(Map<String, dynamic> json) =>
      SumDataBySelect(
        go: json["GO"]?.toDouble(),
        ez: json["EZ"]?.toDouble(),
        ta: json["TA"]?.toDouble(),
        ma: json["MA"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "GO": go,
        "EZ": ez,
        "TA": ta,
        "MA": ma,
      };
}
