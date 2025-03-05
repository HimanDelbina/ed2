import 'dart:convert';

List<ExportCommodityModel> exportCommodityModelFromJson(String str) =>
    List<ExportCommodityModel>.from(
        json.decode(str).map((x) => ExportCommodityModel.fromJson(x)));

String exportCommodityModelToJson(List<ExportCommodityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExportCommodityModel {
  int? id;
  DateTime? guardDate;
  DateTime? adminDate;
  DateTime? backDate;
  DateTime? guardBackDate;
  DateTime? createAt;
  DateTime? updateAt;
  String? select;
  String? name;
  String? count;
  String? weight;
  String? buyer;
  String? repairMan;
  String? recipient;
  String? carPlate;
  bool? isAnbar;
  bool? isGuard;
  bool? isAdmin;
  bool? isBackGuard;
  bool? isPrint;
  bool? isBack;
  User? user;
  Company? company;

  ExportCommodityModel({
    this.id,
    this.guardDate,
    this.adminDate,
    this.backDate,
    this.guardBackDate,
    this.createAt,
    this.updateAt,
    this.select,
    this.name,
    this.count,
    this.weight,
    this.buyer,
    this.repairMan,
    this.recipient,
    this.carPlate,
    this.isAnbar,
    this.isGuard,
    this.isAdmin,
    this.isBackGuard,
    this.isPrint,
    this.isBack,
    this.user,
    this.company,
  });

  factory ExportCommodityModel.fromJson(Map<String, dynamic> json) =>
      ExportCommodityModel(
        id: json["id"],
        guardDate: json["guard_date"] == null
            ? null
            : DateTime.parse(json["guard_date"]),
        adminDate: json["admin_date"] == null
            ? null
            : DateTime.parse(json["admin_date"]),
        backDate: json["back_date"] == null
            ? null
            : DateTime.parse(json["back_date"]),
        guardBackDate: json["guard_back_date"] == null
            ? null
            : DateTime.parse(json["guard_back_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        select: json["select"],
        name: json["name"] != null ? utf8.decode(json["name"].codeUnits) : null,
        count: json["count"],
        weight: json["weight"],
        buyer:
            json["buyer"] != null ? utf8.decode(json["buyer"].codeUnits) : null,
        repairMan: json["repair_man"] != null
            ? utf8.decode(json["repair_man"].codeUnits)
            : null,
        recipient: json["recipient"] != null
            ? utf8.decode(json["recipient"].codeUnits)
            : null,
        carPlate: json["car_plate"] != null
            ? utf8.decode(json["car_plate"].codeUnits)
            : null,
        isAnbar: json["is_anbar"],
        isGuard: json["is_guard"],
        isAdmin: json["is_admin"],
        isBackGuard: json["is_back_guard"],
        isPrint: json["is_print"],
        isBack: json["is_back"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "guard_date": guardDate?.toIso8601String(),
        "admin_date": adminDate?.toIso8601String(),
        "back_date": backDate?.toIso8601String(),
        "guard_back_date": guardBackDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "select": select,
        "name": name,
        "count": count,
        "weight": weight,
        "buyer": buyer,
        "repair_man": repairMan,
        "recipient": recipient,
        "car_plate": carPlate,
        "is_anbar": isAnbar,
        "is_guard": isGuard,
        "is_admin": isAdmin,
        "is_back_guard": isBackGuard,
        "is_print": isPrint,
        "is_back": isBack,
        "user": user?.toJson(),
        "company": company?.toJson(),
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
