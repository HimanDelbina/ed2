import 'dart:convert';

List<AnbarRequestDataModel> anbarRequestDataModelFromJson(String str) =>
    List<AnbarRequestDataModel>.from(
        json.decode(str).map((x) => AnbarRequestDataModel.fromJson(x)));

String anbarRequestDataModelToJson(List<AnbarRequestDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnbarRequestDataModel {
  int? id;
  DateTime? acceptDate;
  DateTime? anbarDate;
  DateTime? createAt;
  DateTime? updateAt;
  List<Commodity>? commodities;
  String? managerSelect;
  String? description;
  bool? isAccept;
  bool? managerAccept;
  bool? salonAccept;
  bool? anbarAccept;
  User? user;

  AnbarRequestDataModel({
    this.id,
    this.acceptDate,
    this.anbarDate,
    this.createAt,
    this.updateAt,
    this.commodities,
    this.managerSelect,
    this.description,
    this.isAccept,
    this.managerAccept,
    this.salonAccept,
    this.anbarAccept,
    this.user,
  });

  factory AnbarRequestDataModel.fromJson(Map<String, dynamic> json) =>
      AnbarRequestDataModel(
        id: json["id"],
        acceptDate: json["accept_date"] == null
            ? null
            : DateTime.parse(json["accept_date"]),
        anbarDate: json["anbar_date"] == null
            ? null
            : DateTime.parse(json["anbar_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        commodities: json["commodities"] == null
            ? []
            : List<Commodity>.from(
                json["commodities"]!.map((x) => Commodity.fromJson(x))),
        managerSelect: json["manager_select"],
        description: utf8.decode(json["description"].codeUnits),
        isAccept: json["is_accept"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        anbarAccept: json["anbar_accept"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accept_date": acceptDate?.toIso8601String(),
        "anbar_date": anbarDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "commodities": commodities == null
            ? []
            : List<dynamic>.from(commodities!.map((x) => x.toJson())),
        "manager_select": managerSelect,
        "description": description,
        "is_accept": isAccept,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "anbar_accept": anbarAccept,
        "user": user?.toJson(),
      };
}

class Commodity {
  int? id;
  String? code;
  String? name;
  String? unit;
  String? count;
  bool? accept;

  Commodity({
    this.id,
    this.code,
    this.name,
    this.unit,
    this.count,
    this.accept,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) => Commodity(
        id: json["id"],
        code: json["code"],
        name: utf8.decode(json["name"].codeUnits),
        unit: utf8.decode(json["unit"].codeUnits),
        count: json["count"],
        accept: json["accept"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "unit": unit,
        "count": count,
        "accept": accept,
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
