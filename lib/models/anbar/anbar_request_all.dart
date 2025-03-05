// To parse this JSON data, do
//
//     final anbarRequestAllModel = anbarRequestAllModelFromJson(jsonString);

import 'dart:convert';

AnbarRequestAllModel anbarRequestAllModelFromJson(String str) =>
    AnbarRequestAllModel.fromJson(json.decode(str));

String anbarRequestAllModelToJson(AnbarRequestAllModel data) =>
    json.encode(data.toJson());

class AnbarRequestAllModel {
  List<AnbarDatum>? anbarData;
  List<ShoppingDatum>? shoppingData;

  AnbarRequestAllModel({
    this.anbarData,
    this.shoppingData,
  });

  factory AnbarRequestAllModel.fromJson(Map<String, dynamic> json) =>
      AnbarRequestAllModel(
        anbarData: json["anbar_data"] == null
            ? []
            : List<AnbarDatum>.from(
                json["anbar_data"]!.map((x) => AnbarDatum.fromJson(x))),
        shoppingData: json["shopping_data"] == null
            ? []
            : List<ShoppingDatum>.from(
                json["shopping_data"]!.map((x) => ShoppingDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "anbar_data": anbarData == null
            ? []
            : List<dynamic>.from(anbarData!.map((x) => x.toJson())),
        "shopping_data": shoppingData == null
            ? []
            : List<dynamic>.from(shoppingData!.map((x) => x.toJson())),
      };
}

class AnbarDatum {
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
  AnbarDatumUser? user;

  AnbarDatum({
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

  factory AnbarDatum.fromJson(Map<String, dynamic> json) => AnbarDatum(
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
        user:
            json["user"] == null ? null : AnbarDatumUser.fromJson(json["user"]),
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

class AnbarDatumUser {
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
  int? company;
  int? unit;
  int? group;
  List<int>? access;
  List<int>? adminAccess;

  AnbarDatumUser({
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

  factory AnbarDatumUser.fromJson(Map<String, dynamic> json) => AnbarDatumUser(
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
        company: json["company"],
        unit: json["unit"],
        group: json["group"],
        access: json["access"] == null
            ? []
            : List<int>.from(json["access"]!.map((x) => x)),
        adminAccess: json["admin_access"] == null
            ? []
            : List<int>.from(json["admin_access"]!.map((x) => x)),
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
        "company": company,
        "unit": unit,
        "group": group,
        "access":
            access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
        "admin_access": adminAccess == null
            ? []
            : List<dynamic>.from(adminAccess!.map((x) => x)),
      };
}

class ShoppingDatum {
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
  ShoppingDatumUser? user;

  ShoppingDatum({
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

  factory ShoppingDatum.fromJson(Map<String, dynamic> json) => ShoppingDatum(
        id: json["id"],
        managerDate: json["manager_date"] == null
            ? null
            : DateTime.parse(json["manager_date"]),
        anbarDate: json["anbar_date"] == null
            ? null
            : DateTime.parse(json["anbar_date"]),
        shopDate:json["shop_date"] == null
            ? null
            : DateTime.parse(json["shop_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        shopData: json["shop_data"] == null
            ? []
            : List<ShopDatum>.from(
                json["shop_data"]!.map((x) => ShopDatum.fromJson(x))),
        description: json["description"],
        type: json["type"],
        managerAccept: json["manager_accept"],
        anbarAccept: json["anbar_accept"],
        bazarganiAccept: json["bazargani_accept"],
        isShop: json["is_shop"],
        // bazarganiDate: json["bazargani_date"],
        bazarganiDate:json["bazargani_date"] == null
            ? null
            : DateTime.parse(json["bazargani_date"]),
        user: json["user"] == null
            ? null
            : ShoppingDatumUser.fromJson(json["user"]),
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
        "bazargani_date": bazarganiDate,
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
        name: json["name"],
        count: json["count"],
        accept: json["accept"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "count": count,
        "accept": accept,
      };
}

class ShoppingDatumUser {
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

  ShoppingDatumUser({
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

  factory ShoppingDatumUser.fromJson(Map<String, dynamic> json) =>
      ShoppingDatumUser(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
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
        name: json["name"],
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
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
