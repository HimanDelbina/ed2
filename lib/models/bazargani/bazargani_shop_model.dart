import 'dart:convert';

List<BazarganiShopModel> bazarganiShopModelFromJson(String str) =>
    List<BazarganiShopModel>.from(
        json.decode(str).map((x) => BazarganiShopModel.fromJson(x)));

String bazarganiShopModelToJson(List<BazarganiShopModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BazarganiShopModel {
  int? id;
  DateTime? managerDate;
  DateTime? anbarDate;
  DateTime? shopDate;
  DateTime? createAt;
  List<ShopDatum>? shopData;
  String? description;
  String? type;
  bool? managerAccept;
  bool? anbarAccept;
  bool? bazarganiAccept;
  bool? isShop;
  DateTime? bazarganiDate;
  User? user;

  BazarganiShopModel({
    this.id,
    this.managerDate,
    this.anbarDate,
    this.shopDate,
    this.createAt,
    this.shopData,
    this.description,
    this.type,
    this.managerAccept,
    this.anbarAccept,
    this.bazarganiAccept,
    this.isShop,
    this.bazarganiDate,
    this.user,
  });

  factory BazarganiShopModel.fromJson(Map<String, dynamic> json) =>
      BazarganiShopModel(
        id: json["id"],
        managerDate: json["manager_date"] == null
            ? null
            : DateTime.parse(json["manager_date"]),
        anbarDate: json["anbar_date"] == null
            ? null
            : DateTime.parse(json["anbar_date"]),
        shopDate: json["shop_date"] == null
            ? null
            : DateTime.parse(json["shop_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        shopData: json["shop_data"] == null
            ? []
            : List<ShopDatum>.from(
                json["shop_data"]!.map((x) => ShopDatum.fromJson(x))),
        description: utf8.decode(json["description"].codeUnits),
        type: json["type"],
        managerAccept: json["manager_accept"],
        anbarAccept: json["anbar_accept"],
        bazarganiAccept: json["bazargani_accept"],
        isShop: json["is_shop"],
        bazarganiDate: json["bazargani_date"] == null
            ? null
            : DateTime.parse(json["bazargani_date"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "manager_date": managerDate?.toIso8601String(),
        "anbar_date": anbarDate?.toIso8601String(),
        "shop_date": shopDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "shop_data": shopData == null
            ? []
            : List<dynamic>.from(shopData!.map((x) => x.toJson())),
        "description": description,
        "type": type,
        "manager_accept": managerAccept,
        "anbar_accept": anbarAccept,
        "bazargani_accept": bazarganiAccept,
        "is_shop": isShop,
        "bazargani_date": bazarganiDate?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class ShopDatum {
  String? name;
  String? count;
  bool? accept;

  ShopDatum({
    this.name,
    this.count,
    this.accept,
  });

  factory ShopDatum.fromJson(Map<String, dynamic> json) => ShopDatum(
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
  bool? isBazargani;
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
  List<Access>? adminAccess;

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
    this.isBazargani,
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
    this.adminAccess,
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
        isBazargani: json["is_bazargani"],
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
        adminAccess: json["admin_access"] == null
            ? []
            : List<Access>.from(
                json["admin_access"]!.map((x) => Access.fromJson(x))),
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
        "is_bazargani": isBazargani,
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
        "admin_access": adminAccess == null
            ? []
            : List<dynamic>.from(adminAccess!.map((x) => x.toJson())),
      };
}

class Access {
  int? id;
  String? name;
  String? tag;
  String? icon;

  Access({
    this.id,
    this.name,
    this.tag,
    this.icon,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
        tag: json["tag"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
        "icon": icon,
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
