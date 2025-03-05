import 'dart:convert';

List<GetChangeShiftModel> getChangeShiftModelFromJson(String str) =>
    List<GetChangeShiftModel>.from(
        json.decode(str).map((x) => GetChangeShiftModel.fromJson(x)));

String getChangeShiftModelToJson(List<GetChangeShiftModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetChangeShiftModel {
  int? id;
  String? daysSelect;
  DateTime? createAt;
  DateTime? updateAt;
  String? approvalStatus;
  Shift? shift;

  GetChangeShiftModel({
    this.id,
    this.daysSelect,
    this.createAt,
    this.updateAt,
    this.approvalStatus,
    this.shift,
  });

  factory GetChangeShiftModel.fromJson(Map<String, dynamic> json) =>
      GetChangeShiftModel(
        id: json["id"],
        daysSelect: json["days_select"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        approvalStatus: json["approval_status"],
        shift: json["shift"] == null ? null : Shift.fromJson(json["shift"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "days_select": daysSelect,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "approval_status": approvalStatus,
        "shift": shift?.toJson(),
      };
}

class Shift {
  int? id;
  String? daysSelect;
  DateTime? shiftDate;
  int? shiftCount;
  bool? isCheck;
  DateTime? createAt;
  DateTime? updateAt;
  int? user;

  Shift({
    this.id,
    this.daysSelect,
    this.shiftDate,
    this.shiftCount,
    this.isCheck,
    this.createAt,
    this.updateAt,
    this.user,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        daysSelect: json["days_select"],
        shiftDate: json["shift_date"] == null
            ? null
            : DateTime.parse(json["shift_date"]),
        shiftCount: json["shift_count"],
        isCheck: json["is_check"],
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
        "days_select": daysSelect,
        "shift_date": shiftDate?.toIso8601String(),
        "shift_count": shiftCount,
        "is_check": isCheck,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "user": user,
      };
}
