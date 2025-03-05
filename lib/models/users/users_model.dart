import 'dart:convert';

List<UsersModel> usersModelFromJson(String str) =>
    List<UsersModel>.from(json.decode(str).map((x) => UsersModel.fromJson(x)));

String usersModelToJson(List<UsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));



class UsersModel {
  int? id;
  int? activeCount;
  int? inactiveCount;
  List<Access>? access;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? companyCode;
  String? melliCode;
  String? insuranceCode;
  String? password;
  String? image;
  bool? isAdmin;
  bool? isShift;
  bool? isUser;
  bool? isActive;
  bool? isManager;
  bool? isKargozini;
  bool? isAnbar;
  bool? isSalonManager;
  bool? isUnitManager;
  DateTime? createAt;
  DateTime? updateAt;
  Unit? unit;
  Unit? company;
  Unit? group;

  UsersModel({
    this.id,
    this.activeCount,
    this.inactiveCount,
    this.access,
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
    this.createAt,
    this.updateAt,
    this.unit,
    this.company,
    this.group,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json["id"],
        activeCount: json["active_count"],
        inactiveCount: json["inactive_count"],
        access: json["access"] == null
            ? []
            : List<Access>.from(json["access"]!.map((x) => Access.fromJson(x))),
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
        isKargozini: json["is_kargozini"],
        isAnbar: json["is_anbar"],
        isSalonManager: json["is_salon_manager"],
        isUnitManager: json["is_unit_manager"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
        group: json["group"] == null ? null : Unit.fromJson(json["group"]),
        company:
            json["company"] == null ? null : Unit.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "active_count": activeCount,
        "inactive_count": inactiveCount,
        "access": access == null
            ? []
            : List<dynamic>.from(access!.map((x) => x.toJson())),
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
        "is_anbar": isAnbar,
        "is_salon_manager": isSalonManager,
        "is_unit_manager": isUnitManager,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "unit": unit?.toJson(),
        "group": group?.toJson(),
        "company": company?.toJson(),
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
        name: utf8.decode(json["name"].codeUnits),
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
      };
}

class Unit {
  int? id;
  String? name;

  Unit({
    this.id,
    this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
