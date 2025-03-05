import 'dart:convert';

OvertimeNewModel overtimeNewModelFromJson(String str) =>
    OvertimeNewModel.fromJson(json.decode(str));

String overtimeNewModelToJson(OvertimeNewModel data) =>
    json.encode(data.toJson());

class OvertimeNewModel {
  LeaveEntriesBySelect? leaveEntriesBySelect;
  SumDataBySelect? sumDataBySelect;

  OvertimeNewModel({
    this.leaveEntriesBySelect,
    this.sumDataBySelect,
  });

  factory OvertimeNewModel.fromJson(Map<String, dynamic> json) =>
      OvertimeNewModel(
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
  List<Ez>? go;
  List<Ez>? ez;
  List<Ez>? ta;
  List<Ez>? ma;

  LeaveEntriesBySelect({
    this.go,
    this.ez,
    this.ta,
    this.ma,
  });

  factory LeaveEntriesBySelect.fromJson(Map<String, dynamic> json) =>
      LeaveEntriesBySelect(
        go: json["GO"] == null
            ? []
            : List<Ez>.from(json["GO"]!.map((x) => Ez.fromJson(x))),
        ez: json["EZ"] == null
            ? []
            : List<Ez>.from(json["EZ"]!.map((x) => Ez.fromJson(x))),
        ta: json["TA"] == null
            ? []
            : List<Ez>.from(json["TA"]!.map((x) => Ez.fromJson(x))),
        ma: json["MA"] == null
            ? []
            : List<Ez>.from(json["MA"]!.map((x) => Ez.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "GO": go == null ? [] : List<dynamic>.from(go!.map((x) => x.toJson())),
        "EZ": ez == null ? [] : List<dynamic>.from(ez!.map((x) => x.toJson())),
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
        description: utf8.decode(json["description"].codeUnits),
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
  String? password;
  dynamic image;
  bool? isAdmin;
  bool? isShift;
  bool? isUser;
  bool? isActive;
  bool? isManager;
  bool? isKargozini;
  bool? isSalonManager;
  bool? isUnitManager;
  DateTime? createAt;
  DateTime? updateAt;
  int? unit;
  List<int>? access;
  String? melliCode;
  String? insuranceCode;
  int? company;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.companyCode,
    this.password,
    this.image,
    this.isAdmin,
    this.isShift,
    this.isUser,
    this.isActive,
    this.isManager,
    this.isKargozini,
    this.isSalonManager,
    this.isUnitManager,
    this.createAt,
    this.updateAt,
    this.unit,
    this.access,
    this.melliCode,
    this.insuranceCode,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
        phoneNumber: json["phone_number"],
        companyCode: json["company_code"],
        password: json["password"],
        image: json["image"],
        isAdmin: json["is_admin"],
        isShift: json["is_shift"],
        isUser: json["is_user"],
        isActive: json["is_active"],
        isManager: json["is_manager"],
        isKargozini: json["is_kargozini"],
        isSalonManager: json["is_salon_manager"],
        isUnitManager: json["is_unit_manager"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        unit: json["unit"],
        company: json["company"],
        melliCode: json["melli_code"],
        insuranceCode: json["insurance_code"],
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
        "password": password,
        "image": image,
        "is_admin": isAdmin,
        "is_shift": isShift,
        "is_user": isUser,
        "is_active": isActive,
        "is_manager": isManager,
        "is_kargozini": isKargozini,
        "is_salon_manager": isSalonManager,
        "is_unit_manager": isUnitManager,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "unit": unit,
        "company": company,
        "melli_code": melliCode,
        "insurance_code": insuranceCode,
        "access":
            access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
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
