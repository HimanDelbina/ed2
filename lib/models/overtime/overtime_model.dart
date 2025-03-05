// To parse this JSON data, do
//
//     final overtimeModel = overtimeModelFromJson(jsonString);

import 'dart:convert';

OvertimeModel overtimeModelFromJson(String str) =>
    OvertimeModel.fromJson(json.decode(str));

String overtimeModelToJson(OvertimeModel data) => json.encode(data.toJson());

class OvertimeModel {
  LeaveEntriesBySelect? leaveEntriesBySelect;
  SumDataBySelect? sumDataBySelect;

  OvertimeModel({
    this.leaveEntriesBySelect,
    this.sumDataBySelect,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> json) => OvertimeModel(
        leaveEntriesBySelect: json["leave_entries_by_select"] == null
            ? null
            : LeaveEntriesBySelect.fromJson(json["leave_entries_by_select"]),
        sumDataBySelect: json["sum_data_by_select"] == null
            ? null
            : SumDataBySelect.fromJson(json["sum_data_by_select"]),
      );

  Map<String, dynamic> toJson() => {
        "leave_entries_by_select": leaveEntriesBySelect?.toJson(),
        "sum_data_by_select": sumDataBySelect?.toJson(),
      };
}

class LeaveEntriesBySelect {
  List<Ez>? ez;
  List<Ez>? go;
  List<Ez>? ta;
  List<Ez>? ma;

  LeaveEntriesBySelect({
    this.ez,
    this.go,
    this.ta,
    this.ma,
  });

  factory LeaveEntriesBySelect.fromJson(Map<String, dynamic> json) =>
      LeaveEntriesBySelect(
        ez: json["EZ"] == null
            ? []
            : List<Ez>.from(json["EZ"]!.map((x) => Ez.fromJson(x))),
        go: json["GO"] == null
            ? []
            : List<Ez>.from(json["GO"]!.map((x) => Ez.fromJson(x))),
        ta: json["TA"] == null
            ? []
            : List<Ez>.from(json["TA"]!.map((x) => Ez.fromJson(x))),
        ma: json["MA"] == null
            ? []
            : List<Ez>.from(json["MA"]!.map((x) => Ez.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EZ": ez == null ? [] : List<dynamic>.from(ez!.map((x) => x.toJson())),
        "GO": go == null ? [] : List<dynamic>.from(go!.map((x) => x.toJson())),
        "TA": ta == null ? [] : List<dynamic>.from(ta!.map((x) => x.toJson())),
        "MA": ma == null ? [] : List<dynamic>.from(ma!.map((x) => x.toJson())),
      };
}

class Ez {
  int? id;
  DateTime? overtimeDate;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isAccept;
  String? select;
  String? startTime;
  String? endTime;
  String? description;
  bool? managerAccept;
  bool? salonAccept;
  User? user;
  double? finalTime;

  Ez({
    this.id,
    this.overtimeDate,
    this.createAt,
    this.updateAt,
    this.isAccept,
    this.select,
    this.startTime,
    this.endTime,
    this.description,
    this.managerAccept,
    this.salonAccept,
    this.user,
    this.finalTime,
  });

  factory Ez.fromJson(Map<String, dynamic> json) => Ez(
        id: json["id"],
        overtimeDate: json["overtime_date"] == null
            ? null
            : DateTime.parse(json["overtime_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        isAccept: json["is_accept"],
        select: json["select"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        description: json["description"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        finalTime: json["final_time"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "overtime_date": overtimeDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "is_accept": isAccept,
        "select": select,
        "start_time": startTime,
        "end_time": endTime,
        "description": description,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "user": user?.toJson(),
        "final_time": finalTime,
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? companyCode;
  String? melliCode;
  String? insuranceCode;
  String? password;
  dynamic image;
  bool? isAdmin;
  bool? isShift;
  bool? isUser;
  bool? isActive;
  bool? isManager;
  bool? isAnbar;
  bool? isKargozini;
  bool? isSalonManager;
  bool? isUnitManager;
  bool? isGuard;
  bool? isAdminGuard;
  DateTime? createAt;
  DateTime? updateAt;
  int? company;
  int? unit;
  List<int>? access;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.companyCode,
    this.melliCode,
    this.insuranceCode,
    this.password,
    this.image,
    this.isAdmin,
    this.isShift,
    this.isUser,
    this.isActive,
    this.isManager,
    this.isAnbar,
    this.isKargozini,
    this.isSalonManager,
    this.isUnitManager,
    this.isGuard,
    this.isAdminGuard,
    this.createAt,
    this.updateAt,
    this.company,
    this.unit,
    this.access,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        companyCode: json["company_code"],
        melliCode: json["melli_code"],
        insuranceCode: json["insurance_code"],
        password: json["password"],
        image: json["image"],
        isAdmin: json["is_admin"],
        isShift: json["is_shift"],
        isUser: json["is_user"],
        isActive: json["is_active"],
        isManager: json["is_manager"],
        isAnbar: json["is_anbar"],
        isKargozini: json["is_kargozini"],
        isSalonManager: json["is_salon_manager"],
        isUnitManager: json["is_unit_manager"],
        isGuard: json["is_guard"],
        isAdminGuard: json["is_admin_guard"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        company: json["company"],
        unit: json["unit"],
        access: json["access"] == null
            ? []
            : List<int>.from(json["access"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "company_code": companyCode,
        "melli_code": melliCode,
        "insurance_code": insuranceCode,
        "password": password,
        "image": image,
        "is_admin": isAdmin,
        "is_shift": isShift,
        "is_user": isUser,
        "is_active": isActive,
        "is_manager": isManager,
        "is_anbar": isAnbar,
        "is_kargozini": isKargozini,
        "is_salon_manager": isSalonManager,
        "is_unit_manager": isUnitManager,
        "is_guard": isGuard,
        "is_admin_guard": isAdminGuard,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "company": company,
        "unit": unit,
        "access":
            access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
      };
}class SumDataBySelect {
  double? ez;
  double? go;
  double? ta;
  double? ma;

  SumDataBySelect({
    this.ez,
    this.go,
    this.ta,
    this.ma,
  });

  factory SumDataBySelect.fromJson(Map<String, dynamic> json) =>
      SumDataBySelect(
        ez: json["EZ"] != null
            ? (json["EZ"] is double
                ? json["EZ"]
                : (json["EZ"] as num).toDouble())
            : 0.0,  // مقدار پیش‌فرض برای null
        go: json["GO"] != null
            ? (json["GO"] is double
                ? json["GO"]
                : (json["GO"] as num).toDouble())
            : 0.0,  // مقدار پیش‌فرض برای null
        ta: json["TA"] != null
            ? (json["TA"] is double
                ? json["TA"]
                : (json["TA"] as num).toDouble())
            : 0.0,  // مقدار پیش‌فرض برای null
        ma: json["MA"] != null
            ? (json["MA"] is double
                ? json["MA"]
                : (json["MA"] as num).toDouble())
            : 0.0,  // مقدار پیش‌فرض برای null
      );

  Map<String, dynamic> toJson() => {
        "EZ": ez,
        "GO": go,
        "TA": ta,
        "MA": ma,
      };
}
