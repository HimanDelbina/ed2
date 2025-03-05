import 'dart:convert';

List<GharadadModel> gharadadModelFromJson(String str) =>
    List<GharadadModel>.from(
        json.decode(str).map((x) => GharadadModel.fromJson(x)));

String gharadadModelToJson(List<GharadadModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GharadadModel {
  int? id;
  String? startDate;
  String? endDate;
  String? money;
  int? remainingDays;
  int? daysBetween;
  bool? isFinish;
  User? user;

  GharadadModel({
    this.id,
    this.startDate,
    this.endDate,
    this.money,
    this.remainingDays,
    this.daysBetween,
    this.isFinish,
    this.user,
  });

  factory GharadadModel.fromJson(Map<String, dynamic> json) => GharadadModel(
        id: json["id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        money: json["money"],
        remainingDays: json["remaining_days"],
        daysBetween: json["days_between"],
        isFinish: json["is_finish"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate,
        "end_date": endDate,
        "remaining_days": remainingDays,
        "days_between": daysBetween,
        "is_finish": isFinish,
        "money": money,
        "user": user?.toJson(),
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
        access: json["access"] == null
            ? []
            : List<int>.from(json["access"]!.map((x) => x)),
        company: json["company"],
        melliCode: json["melli_code"],
        insuranceCode: json["insurance_code"],
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
