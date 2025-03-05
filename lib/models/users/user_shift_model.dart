import 'dart:convert';

List<UserShiftModel> userShiftModelFromJson(String str) =>
    List<UserShiftModel>.from(
        json.decode(str).map((x) => UserShiftModel.fromJson(x)));

String userShiftModelToJson(List<UserShiftModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserShiftModel {
  int? id;
  String? firstName;
  String? lastName;
  int? unitId;
  bool? isActive;
  List<Shift>? shifts;

  UserShiftModel({
    this.id,
    this.firstName,
    this.lastName,
    this.unitId,
    this.isActive,
    this.shifts,
  });

  factory UserShiftModel.fromJson(Map<String, dynamic> json) => UserShiftModel(
        id: json["id"],
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
        unitId: json["unit_id"],
        isActive: json["is_active"],
        shifts: json["shifts"] == null
            ? []
            : List<Shift>.from(json["shifts"]!.map((x) => Shift.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "unit_id": unitId,
        "is_active": isActive,
        "shifts": shifts == null
            ? []
            : List<dynamic>.from(shifts!.map((x) => x.toJson())),
      };
}

class Shift {
  int? id;
  String? daysSelect;
  DateTime? shiftDate;
  int? shiftCount;
  bool? isCheck;

  Shift({
    this.daysSelect,
    this.shiftDate,
    this.shiftCount,
    this.isCheck,
    this.id,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        daysSelect: json["days_select"],
        shiftDate: json["shift_date"] == null
            ? null
            : DateTime.parse(json["shift_date"]),
        shiftCount: json["shift_count"],
        isCheck: json["is_check"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "days_select": daysSelect,
        "shift_date": shiftDate?.toIso8601String(),
        "shift_count": shiftCount,
        "is_check": isCheck,
      };
}
