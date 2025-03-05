import 'dart:convert';

List<AllFundModel> allFundModelFromJson(String str) => List<AllFundModel>.from(
    json.decode(str).map((x) => AllFundModel.fromJson(x)));

String allFundModelToJson(List<AllFundModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllFundModel {
  int? id;
  DateTime? createAt;
  DateTime? updateAt;
  String? money;
  String? description;
  bool? isRead;
  bool? isAccept;
  bool? isReject;
  User? user;

  AllFundModel({
    this.id,
    this.createAt,
    this.updateAt,
    this.money,
    this.description,
    this.isRead,
    this.isAccept,
    this.isReject,
    this.user,
  });

  factory AllFundModel.fromJson(Map<String, dynamic> json) => AllFundModel(
        id: json["id"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        money: json["money"],
        description: json["description"] != null
            ? utf8.decode(json["description"].codeUnits)
            : "",
        isRead: json["is_read"],
        isAccept: json["is_accept"],
        isReject: json["is_reject"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "money": money,
        "description": description,
        "is_read": isRead,
        "is_accept": isAccept,
        "is_reject": isReject,
        "user": user?.toJson(),
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
  bool? isKargozini;
  bool? isSalonManager;
  bool? isUnitManager;
  DateTime? createAt;
  DateTime? updateAt;
  Company? company;
  Company? unit;
  List<Access>? access;

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
    this.isKargozini,
    this.isSalonManager,
    this.isUnitManager,
    this.createAt,
    this.updateAt,
    this.company,
    this.unit,
    this.access,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"] != null
            ? utf8.decode(json["first_name"].codeUnits)
            : "",
        lastName: json["last_name"] != null
            ? utf8.decode(json["last_name"].codeUnits)
            : "",
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
        isKargozini: json["is_kargozini"],
        isSalonManager: json["is_salon_manager"],
        isUnitManager: json["is_unit_manager"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        unit: json["unit"] == null ? null : Company.fromJson(json["unit"]),
        access: json["access"] == null
            ? []
            : List<Access>.from(json["access"]!.map((x) => Access.fromJson(x))),
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
        "is_kargozini": isKargozini,
        "is_salon_manager": isSalonManager,
        "is_unit_manager": isUnitManager,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "company": company?.toJson(),
        "unit": unit?.toJson(),
        "access": access == null
            ? []
            : List<dynamic>.from(access!.map((x) => x.toJson())),
      };
}

class Access {
  int? id;
  String? name;
  String? tag;

  Access({
    this.id,
    this.name,
    this.tag,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        id: json["id"],
        name: json["name"] != null ? utf8.decode(json["name"].codeUnits) : "",
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
      };
}

class Company {
  int? id;
  String? name;

  Company({
    this.id,
    this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: json["name"] != null ? utf8.decode(json["name"].codeUnits) : "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
