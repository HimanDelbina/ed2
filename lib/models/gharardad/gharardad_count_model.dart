import 'dart:convert';

GharardadCountModel gharardadCountModelFromJson(String str) =>
    GharardadCountModel.fromJson(json.decode(str));

String gharardadCountModelToJson(GharardadCountModel data) =>
    json.encode(data.toJson());

class GharardadCountModel {
  int? recordCount;
  List<Datum>? data;

  GharardadCountModel({
    this.recordCount,
    this.data,
  });

  factory GharardadCountModel.fromJson(Map<String, dynamic> json) =>
      GharardadCountModel(
        recordCount: json["record_count"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "record_count": recordCount,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  DateTime? startDate;
  DateTime? endDate;
  String? money;
  bool? isFinish;
  bool? isFinishWork;
  User? user;
  int? daysBetween;
  int? remainingDays;

  Datum({
    this.id,
    this.startDate,
    this.endDate,
    this.money,
    this.isFinish,
    this.isFinishWork,
    this.user,
    this.daysBetween,
    this.remainingDays,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        money: json["money"],
        isFinish: json["is_finish"],
        isFinishWork: json["is_finish_work"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        daysBetween: json["days_between"],
        remainingDays: json["remaining_days"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "money": money,
        "is_finish": isFinish,
        "is_finish_work": isFinishWork,
        "user": user?.toJson(),
        "days_between": daysBetween,
        "remaining_days": remainingDays,
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
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
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
}
