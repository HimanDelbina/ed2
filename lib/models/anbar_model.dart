import 'dart:convert';

List<AnbarModel> anbarModelFromJson(String str) =>
    List<AnbarModel>.from(json.decode(str).map((x) => AnbarModel.fromJson(x)));

String anbarModelToJson(List<AnbarModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnbarModel {
  int? id;
  String? acceptDate;
  String? anbarDate;
  String? createAt;
  String? updateAt;
  List<Commodity>? commodities;
  String? managerSelect;
  String? clockCreate;
  String? clockAccept;
  String? clockDateAnbar;
  String? description;
  bool? isAccept;
  bool? managerAccept;
  bool? salonManagerAccept;
  bool? anbarAccept;
  User? user;

  AnbarModel({
    this.id,
    this.acceptDate,
    this.anbarDate,
    this.createAt,
    this.updateAt,
    this.commodities,
    this.managerSelect,
    this.clockCreate,
    this.clockAccept,
    this.clockDateAnbar,
    this.description,
    this.isAccept,
    this.managerAccept,
    this.salonManagerAccept,
    this.anbarAccept,
    this.user,
  });

  factory AnbarModel.fromJson(Map<String, dynamic> json) => AnbarModel(
        id: json["id"],
        acceptDate: json["accept_date"],
        anbarDate: json["anbar_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        commodities: json["commodities"] == null
            ? []
            : List<Commodity>.from(
                json["commodities"]!.map((x) => Commodity.fromJson(x))),
        managerSelect: json["manager_select"],
        clockCreate: json["clock_create"],
        clockAccept: json["clock_accept"],
        clockDateAnbar: json["clock_date_anbar"],
        description: utf8.decode(json["description"].codeUnits),
        isAccept: json["is_accept"],
        managerAccept: json["manager_accept"],
        salonManagerAccept: json["salon_manager_accept"],
        anbarAccept: json["anbar_accept"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accept_date": acceptDate,
        "anbar_date": anbarDate,
        "create_at": createAt,
        "update_at": updateAt,
        "commodities": commodities == null
            ? []
            : List<dynamic>.from(commodities!.map((x) => x.toJson())),
        "manager_select": managerSelect,
        "clock_create": clockCreate,
        "clock_accept": clockAccept,
        "clock_date_anbar": clockDateAnbar,
        "description": description,
        "is_accept": isAccept,
        "manager_accept": managerAccept,
        "salon_manager_accept": salonManagerAccept,
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
  String? password;
  String? image;
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
