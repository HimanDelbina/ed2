import 'dart:convert';

ShiftReportUserModel shiftReportUserModelFromJson(String str) => ShiftReportUserModel.fromJson(json.decode(str));

String shiftReportUserModelToJson(ShiftReportUserModel data) => json.encode(data.toJson());

class ShiftReportUserModel {
    DateTime? today;
    List<TodayShift>? todayShifts;
    List<MonthlyShift>? monthlyShifts;

    ShiftReportUserModel({
        this.today,
        this.todayShifts,
        this.monthlyShifts,
    });

    factory ShiftReportUserModel.fromJson(Map<String, dynamic> json) => ShiftReportUserModel(
        today: json["today"] == null ? null : DateTime.parse(json["today"]),
        todayShifts: json["today_shifts"] == null ? [] : List<TodayShift>.from(json["today_shifts"]!.map((x) => TodayShift.fromJson(x))),
        monthlyShifts: json["monthly_shifts"] == null ? [] : List<MonthlyShift>.from(json["monthly_shifts"]!.map((x) => MonthlyShift.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "today": "${today!.year.toString().padLeft(4, '0')}-${today!.month.toString().padLeft(2, '0')}-${today!.day.toString().padLeft(2, '0')}",
        "today_shifts": todayShifts == null ? [] : List<dynamic>.from(todayShifts!.map((x) => x.toJson())),
        "monthly_shifts": monthlyShifts == null ? [] : List<dynamic>.from(monthlyShifts!.map((x) => x.toJson())),
    };
}

class MonthlyShift {
    int? month;
    List<ShiftType>? shiftTypes;
    int? totalShiftsInMonth;
    int? approvedShiftsInMonth;

    MonthlyShift({
        this.month,
        this.shiftTypes,
        this.totalShiftsInMonth,
        this.approvedShiftsInMonth,
    });

    factory MonthlyShift.fromJson(Map<String, dynamic> json) => MonthlyShift(
        month: json["month"],
        shiftTypes: json["shift_types"] == null ? [] : List<ShiftType>.from(json["shift_types"]!.map((x) => ShiftType.fromJson(x))),
        totalShiftsInMonth: json["total_shifts_in_month"],
        approvedShiftsInMonth: json["approved_shifts_in_month"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "shift_types": shiftTypes == null ? [] : List<dynamic>.from(shiftTypes!.map((x) => x.toJson())),
        "total_shifts_in_month": totalShiftsInMonth,
        "approved_shifts_in_month": approvedShiftsInMonth,
    };
}

class ShiftType {
    String? shiftType;
    String? shiftTypeName;
    int? totalShifts;
    int? approvedShifts;

    ShiftType({
        this.shiftType,
        this.shiftTypeName,
        this.totalShifts,
        this.approvedShifts,
    });

    factory ShiftType.fromJson(Map<String, dynamic> json) => ShiftType(
        shiftType: json["shift_type"],
        shiftTypeName: utf8.decode(json["shift_type_name"].codeUnits),
        totalShifts: json["total_shifts"],
        approvedShifts: json["approved_shifts"],
    );

    Map<String, dynamic> toJson() => {
        "shift_type": shiftType,
        "shift_type_name": shiftTypeName,
        "total_shifts": totalShifts,
        "approved_shifts": approvedShifts,
    };
}

class TodayShift {
    String? shiftType;
    String? shiftTypeName;
    DateTime? shiftDate;
    bool? isApproved;

    TodayShift({
        this.shiftType,
        this.shiftTypeName,
        this.shiftDate,
        this.isApproved,
    });

    factory TodayShift.fromJson(Map<String, dynamic> json) => TodayShift(
        shiftType: json["shift_type"],
        shiftTypeName: utf8.decode(json["shift_type_name"].codeUnits),
        shiftDate: json["shift_date"] == null ? null : DateTime.parse(json["shift_date"]),
        isApproved: json["is_approved"],
    );

    Map<String, dynamic> toJson() => {
        "shift_type": shiftType,
        "shift_type_name": shiftTypeName,
        "shift_date": shiftDate?.toIso8601String(),
        "is_approved": isApproved,
    };
}
