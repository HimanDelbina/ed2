import 'dart:convert';

List<ShopReportMpdel> shopReportMpdelFromJson(String str) =>
    List<ShopReportMpdel>.from(
        json.decode(str).map((x) => ShopReportMpdel.fromJson(x)));

String shopReportMpdelToJson(List<ShopReportMpdel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShopReportMpdel {
  int? id;
  dynamic managerDate;
  dynamic anbarDate;
  dynamic shopDate;
  DateTime? createAt;
  List<ShopData>? shopData;
  String? description;
  String? type;
  bool? managerAccept;
  bool? unitAccept;
  bool? anbarAccept;
  bool? bazarganiAccept;
  bool? isShop;
  dynamic bazarganiDate;
  dynamic unitDate;
  User? user;

  ShopReportMpdel({
    this.id,
    this.managerDate,
    this.anbarDate,
    this.shopDate,
    this.createAt,
    this.shopData,
    this.description,
    this.type,
    this.managerAccept,
    this.unitAccept,
    this.anbarAccept,
    this.bazarganiAccept,
    this.isShop,
    this.bazarganiDate,
    this.unitDate,
    this.user,
  });

  factory ShopReportMpdel.fromJson(Map<String, dynamic> json) =>
      ShopReportMpdel(
        id: json["id"],
        managerDate: json["manager_date"],
        anbarDate: json["anbar_date"],
        shopDate: json["shop_date"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        shopData: json["shop_data"] == null
            ? []
            : List<ShopData>.from(
                json["shop_data"]!.map((x) => ShopData.fromJson(x))),
        description: json["description"],
        type: json["type"],
        managerAccept: json["manager_accept"],
        unitAccept: json["unit_accept"],
        anbarAccept: json["anbar_accept"],
        bazarganiAccept: json["bazargani_accept"],
        isShop: json["is_shop"],
        bazarganiDate: json["bazargani_date"],
        unitDate: json["unit_date"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "manager_date": managerDate,
        "anbar_date": anbarDate,
        "shop_date": shopDate,
        "create_at": createAt?.toIso8601String(),
        "shop_data": shopData == null
            ? []
            : List<dynamic>.from(shopData!.map((x) => x.toJson())),
        "description": description,
        "type": type,
        "manager_accept": managerAccept,
        "unit_accept": unitAccept,
        "anbar_accept": anbarAccept,
        "bazargani_accept": bazarganiAccept,
        "is_shop": isShop,
        "bazargani_date": bazarganiDate,
        "unit_date": unitDate,
        "user": user?.toJson(),
      };
}

class ShopData {
  String? name;
  String? count;
  bool? accept;

  ShopData({
    this.name,
    this.count,
    this.accept,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) => ShopData(
        name: utf8.decode(json["name"].codeUnits),
        count: json["count"],
        accept: json["accept"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
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
  Company? company;
  Company? unit;
  Company? group;
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
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
        unit: json["unit"] == null ? null : Company.fromJson(json["unit"]),
        group: json["group"] == null ? null : Company.fromJson(json["group"]),
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
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
