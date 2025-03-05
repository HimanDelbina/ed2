import 'dart:convert';

GetAllUserModel getAllUserModelFromJson(String str) =>
    GetAllUserModel.fromJson(json.decode(str));

String getAllUserModelToJson(GetAllUserModel data) =>
    json.encode(data.toJson());

class GetAllUserModel {
  List<User>? users;
  int? activeCount;
  int? inactiveCount;

  GetAllUserModel({
    this.users,
    this.activeCount,
    this.inactiveCount,
  });

  factory GetAllUserModel.fromJson(Map<String, dynamic> json) =>
      GetAllUserModel(
        users: json["users"] == null
            ? []
            : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
        activeCount: json["active_count"],
        inactiveCount: json["inactive_count"],
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "active_count": activeCount,
        "inactive_count": inactiveCount,
      };
}

class User {
  int? id;
  List<AccessModel>? access;
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
  bool? isModirTolid;
  bool? isSalonManager;
  bool? isUnitManager;
  bool? isGuard;
  bool? isAdminGuard;
  DateTime? createAt;
  DateTime? updateAt;
  Company? company;
  Company? unit;
  Company? group;

  User({
    this.id,
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
    this.isModirTolid,
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
    this.group,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        access: json["access"] == null
            ? []
            : List<AccessModel>.from(
                json["access"]!.map((x) => AccessModel.fromJson(x))),
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
        isModirTolid: json["is_modirTolid"],
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
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        unit: json["unit"] == null ? null : Company.fromJson(json["unit"]),
        group: json["group"] == null ? null : Company.fromJson(json["group"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "is_modirTolid": isModirTolid,
        "is_anbar": isAnbar,
        "is_kargozini": isKargozini,
        "is_salon_manager": isSalonManager,
        "is_unit_manager": isUnitManager,
        "is_guard": isGuard,
        "is_admin_guard": isAdminGuard,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "company": company?.toJson(),
        "unit": unit?.toJson(),
        "group": group?.toJson(),
      };
}

class AccessModel {
  int? id;
  String? name;
  String? tag;

  AccessModel({
    this.id,
    this.name,
    this.tag,
  });

  factory AccessModel.fromJson(Map<String, dynamic> json) => AccessModel(
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

class Company {
  int? id;
  String? name;

  Company({
    this.id,
    this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
