// To parse this JSON data, do
//
//     final allReportShiftModel = allReportShiftModelFromJson(jsonString);

import 'dart:convert';

List<AllReportShiftModel> allReportShiftModelFromJson(String str) => List<AllReportShiftModel>.from(json.decode(str).map((x) => AllReportShiftModel.fromJson(x)));

String allReportShiftModelToJson(List<AllReportShiftModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllReportShiftModel {
    int? userId;
    String? firstName;
    String? lastName;
    String? companyCode;
    String? phoneNumber;
    List<Month>? months;

    AllReportShiftModel({
        this.userId,
        this.firstName,
        this.lastName,
        this.companyCode,
        this.phoneNumber,
        this.months,
    });

    factory AllReportShiftModel.fromJson(Map<String, dynamic> json) => AllReportShiftModel(
        userId: json["user_id"],
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
        companyCode: json["company_code"],
        phoneNumber: json["phone_number"],
        months: json["months"] == null ? [] : List<Month>.from(json["months"]!.map((x) => Month.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "company_code": companyCode,
        "phone_number": phoneNumber,
        "months": months == null ? [] : List<dynamic>.from(months!.map((x) => x.toJson())),
    };
}

class Month {
    int? month;
    List<ShiftType>? shiftTypes;
    int? totalShiftsInMonth;
    int? approvedShiftsInMonth;

    Month({
        this.month,
        this.shiftTypes,
        this.totalShiftsInMonth,
        this.approvedShiftsInMonth,
    });

    factory Month.fromJson(Map<String, dynamic> json) => Month(
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
