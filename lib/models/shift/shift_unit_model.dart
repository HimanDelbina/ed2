// To parse this JSON data, do
//
//     final shiftAllUnitModel = shiftAllUnitModelFromJson(jsonString);

import 'dart:convert';

List<ShiftAllUnitModel> shiftAllUnitModelFromJson(String str) =>
    List<ShiftAllUnitModel>.from(
        json.decode(str).map((x) => ShiftAllUnitModel.fromJson(x)));

String shiftAllUnitModelToJson(List<ShiftAllUnitModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShiftAllUnitModel {
  int? id;
  List<int>? access;
  dynamic image;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? companyCode;
  String? melliCode;
  String? insuranceCode;
  String? password;
  bool? isAdmin;
  bool? isShift;
  bool? isUser;
  bool? isActive;
  bool? isManager;
  bool? isAnbar;
  bool? isKargozini;
  bool? isSalonManager;
  bool? isUnitManager;
  DateTime? createAt;
  DateTime? updateAt;
  int? company;
  int? unit;
  Map<String, ShiftReport>? shiftReport;
  int? shiftCount;
  TodayShift? todayShift;

  ShiftAllUnitModel({
    this.id,
    this.access,
    this.image,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.companyCode,
    this.melliCode,
    this.insuranceCode,
    this.password,
    this.isAdmin,
    this.isShift,
    this.isUser,
    this.isActive,
    this.isManager,
    this.isAnbar,
    this.isKargozini,
    this.isSalonManager,
    this.isUnitManager,
    this.createAt,
    this.updateAt,
    this.company,
    this.unit,
    this.shiftReport,
    this.shiftCount,
    this.todayShift,
  });

  factory ShiftAllUnitModel.fromJson(Map<String, dynamic> json) =>
      ShiftAllUnitModel(
        id: json["id"],
        access: json["access"] == null
            ? []
            : List<int>.from(json["access"]!.map((x) => x)),
        image: json["image"],
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
        phoneNumber: json["phone_number"],
        companyCode: json["company_code"],
        melliCode: json["melli_code"],
        insuranceCode: json["insurance_code"],
        password: json["password"],
        isAdmin: json["is_admin"],
        isShift: json["is_shift"],
        isUser: json["is_user"],
        isActive: json["is_active"],
        isManager: json["is_manager"],
        isAnbar: json["is_anbar"],
        isKargozini: json["is_kargozini"],
        isSalonManager: json["is_salon_manager"],
        isUnitManager: json["is_unit_manager"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        company: json["company"],
        unit: json["unit"],
        shiftReport: Map.from(json["shift_report"]!).map((k, v) =>
            MapEntry<String, ShiftReport>(k, ShiftReport.fromJson(v))),
        shiftCount: json["shift_count"],
        todayShift: json["today_shift"] == null
            ? null
            : TodayShift.fromJson(json["today_shift"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "access":
            access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
        "image": image,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "company_code": companyCode,
        "melli_code": melliCode,
        "insurance_code": insuranceCode,
        "password": password,
        "is_admin": isAdmin,
        "is_shift": isShift,
        "is_user": isUser,
        "is_active": isActive,
        "is_manager": isManager,
        "is_anbar": isAnbar,
        "is_kargozini": isKargozini,
        "is_salon_manager": isSalonManager,
        "is_unit_manager": isUnitManager,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "company": company,
        "unit": unit,
        "shift_report": Map.from(shiftReport!)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "shift_count": shiftCount,
        "today_shift": todayShift?.toJson(),
      };
}

class ShiftReport {
  int? totalShifts;
  int? confirmedShifts;
  ShiftTypes? shiftTypes;

  ShiftReport({
    this.totalShifts,
    this.confirmedShifts,
    this.shiftTypes,
  });

  factory ShiftReport.fromJson(Map<String, dynamic> json) => ShiftReport(
        totalShifts: json["total_shifts"],
        confirmedShifts: json["confirmed_shifts"],
        shiftTypes: json["shift_types"] == null
            ? null
            : ShiftTypes.fromJson(json["shift_types"]),
      );

  Map<String, dynamic> toJson() => {
        "total_shifts": totalShifts,
        "confirmed_shifts": confirmedShifts,
        "shift_types": shiftTypes?.toJson(),
      };
}

class ShiftTypes {
  int? so;
  int? shiftTypesAs;
  int? sh;

  ShiftTypes({
    this.so,
    this.shiftTypesAs,
    this.sh,
  });

  factory ShiftTypes.fromJson(Map<String, dynamic> json) => ShiftTypes(
        so: json["SO"],
        shiftTypesAs: json["AS"],
        sh: json["SH"],
      );

  Map<String, dynamic> toJson() => {
        "SO": so,
        "AS": shiftTypesAs,
        "SH": sh,
      };
}

class TodayShift {
  DateTime? shiftDate;
  String? daysSelect;
  bool? isChecked;

  TodayShift({
    this.shiftDate,
    this.daysSelect,
    this.isChecked,
  });

  factory TodayShift.fromJson(Map<String, dynamic> json) => TodayShift(
        shiftDate: json["shift_date"] == null
            ? null
            : DateTime.parse(json["shift_date"]),
        daysSelect: json["days_select"],
        isChecked: json["is_checked"],
      );

  Map<String, dynamic> toJson() => {
        "shift_date":
            "${shiftDate!.year.toString().padLeft(4, '0')}-${shiftDate!.month.toString().padLeft(2, '0')}-${shiftDate!.day.toString().padLeft(2, '0')}",
        "days_select": daysSelect,
        "is_checked": isChecked,
      };
}
