import 'dart:convert';

ClothModel clothModelFromJson(String str) =>
    ClothModel.fromJson(json.decode(str));

String clothModelToJson(ClothModel data) => json.encode(data.toJson());

class ClothModel {
  List<LastIsCloth>? data;
  LastIsCloth? lastIsCloth;
  LastIsCloth? lastIsShoes;
  int? totalIsCloth;
  int? totalIsShoes;

  ClothModel({
    this.data,
    this.lastIsCloth,
    this.lastIsShoes,
    this.totalIsCloth,
    this.totalIsShoes,
  });

  factory ClothModel.fromJson(Map<String, dynamic> json) => ClothModel(
        data: json["data"] == null
            ? []
            : List<LastIsCloth>.from(
                json["data"]!.map((x) => LastIsCloth.fromJson(x))),
        lastIsCloth: json["last_is_cloth"] == null
            ? null
            : LastIsCloth.fromJson(json["last_is_cloth"]),
        lastIsShoes: json["last_is_shoes"] == null
            ? null
            : LastIsCloth.fromJson(json["last_is_shoes"]),
        totalIsCloth: json["total_is_cloth"],
        totalIsShoes: json["total_is_shoes"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_is_cloth": lastIsCloth?.toJson(),
        "last_is_shoes": lastIsShoes?.toJson(),
        "total_is_cloth": totalIsCloth,
        "total_is_shoes": totalIsShoes,
      };
}

class LastIsCloth {
  int? id;
  DateTime? shoesDate;
  DateTime? clothDate;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isCloth;
  bool? isShoes;
  User? user;
  int? daysLeftCloth;
  int? daysLeftShoes;

  LastIsCloth({
    this.id,
    this.shoesDate,
    this.clothDate,
    this.createAt,
    this.updateAt,
    this.isCloth,
    this.isShoes,
    this.user,
    this.daysLeftCloth,
    this.daysLeftShoes,
  });

  factory LastIsCloth.fromJson(Map<String, dynamic> json) => LastIsCloth(
        id: json["id"],
        shoesDate: json["shoes_date"] == null
            ? null
            : DateTime.parse(json["shoes_date"]),
        clothDate: json["cloth_date"] == null
            ? null
            : DateTime.parse(json["cloth_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        isCloth: json["is_cloth"],
        isShoes: json["is_shoes"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        daysLeftCloth: json["days_left_cloth"],
        daysLeftShoes: json["days_left_shoes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shoes_date": shoesDate?.toIso8601String(),
        "cloth_date": clothDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "is_cloth": isCloth,
        "is_shoes": isShoes,
        "user": user?.toJson(),
        "days_left_cloth": daysLeftCloth,
        "days_left_shoes": daysLeftShoes,
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
