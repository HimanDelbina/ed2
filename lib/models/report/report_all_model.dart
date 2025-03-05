// To parse this JSON data, do
//
//     final reportAllModel = reportAllModelFromJson(jsonString);

import 'dart:convert';

ReportAllModel reportAllModelFromJson(String str) =>
    ReportAllModel.fromJson(json.decode(str));

String reportAllModelToJson(ReportAllModel data) => json.encode(data.toJson());

class ReportAllModel {
  int? sumCount;
  int? loanCount;
  int? shopCount;
  int? userCount;
  List<LoanDetail>? loanDetails;
  List<ShopDetail>? shopDetails;
  List<UserDetail>? userDetails;

  ReportAllModel({
    this.sumCount,
    this.loanCount,
    this.shopCount,
    this.userCount,
    this.loanDetails,
    this.shopDetails,
    this.userDetails,
  });

  factory ReportAllModel.fromJson(Map<String, dynamic> json) => ReportAllModel(
        sumCount: json["sum_count"],
        loanCount: json["loan_count"],
        shopCount: json["shop_count"],
        userCount: json["user_count"],
        loanDetails: json["loan_details"] == null
            ? []
            : List<LoanDetail>.from(
                json["loan_details"]!.map((x) => LoanDetail.fromJson(x))),
        shopDetails: json["shop_details"] == null
            ? []
            : List<ShopDetail>.from(
                json["shop_details"]!.map((x) => ShopDetail.fromJson(x))),
        userDetails: json["user_details"] == null
            ? []
            : List<UserDetail>.from(
                json["user_details"]!.map((x) => UserDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sum_count": sumCount,
        "loan_count": loanCount,
        "shop_count": shopCount,
        "user_count": userCount,
        "loan_details": loanDetails == null
            ? []
            : List<dynamic>.from(loanDetails!.map((x) => x.toJson())),
        "shop_details": shopDetails == null
            ? []
            : List<dynamic>.from(shopDetails!.map((x) => x.toJson())),
        "user_details": userDetails == null
            ? []
            : List<dynamic>.from(userDetails!.map((x) => x.toJson())),
      };
}

class LoanDetail {
  int? id;
  DateTime? kargoziniDate;
  DateTime? managerDate;
  DateTime? createAt;
  DateTime? updateAt;
  String? loanSelect;
  String? moneyRequest;
  bool? isBox;
  String? boxMoney;
  bool? isLoanZa;
  String? loanZaMoney;
  bool? isLoanMa;
  String? loanMaMoney;
  bool? isKargozini;
  bool? isManager;
  bool? isKargoziniAccept;
  bool? isManagerAccept;
  bool? isRead;
  String? description;
  User? user;

  LoanDetail({
    this.id,
    this.kargoziniDate,
    this.managerDate,
    this.createAt,
    this.updateAt,
    this.loanSelect,
    this.moneyRequest,
    this.isBox,
    this.boxMoney,
    this.isLoanZa,
    this.loanZaMoney,
    this.isLoanMa,
    this.loanMaMoney,
    this.isKargozini,
    this.isManager,
    this.isKargoziniAccept,
    this.isManagerAccept,
    this.isRead,
    this.description,
    this.user,
  });

  factory LoanDetail.fromJson(Map<String, dynamic> json) => LoanDetail(
        id: json["id"],
        kargoziniDate: json["kargozini_date"] == null
            ? null
            : DateTime.parse(json["kargozini_date"]),
        managerDate: json["manager_date"] == null
            ? null
            : DateTime.parse(json["manager_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        loanSelect: json["loan_select"],
        moneyRequest: json["money_request"],
        isBox: json["is_box"],
        boxMoney: json["box_money"],
        isLoanZa: json["is_loan_za"],
        loanZaMoney: json["loan_za_money"],
        isLoanMa: json["is_loan_ma"],
        loanMaMoney: json["loan_ma_money"],
        isKargozini: json["is_kargozini"],
        isManager: json["is_manager"],
        isKargoziniAccept: json["is_kargozini_accept"],
        isManagerAccept: json["is_manager_accept"],
        isRead: json["is_read"],
        description: utf8.decode(json["description"].codeUnits),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kargozini_date": kargoziniDate?.toIso8601String(),
        "manager_date": managerDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "loan_select": loanSelect,
        "money_request": moneyRequest,
        "is_box": isBox,
        "box_money": boxMoney,
        "is_loan_za": isLoanZa,
        "loan_za_money": loanZaMoney,
        "is_loan_ma": isLoanMa,
        "loan_ma_money": loanMaMoney,
        "is_kargozini": isKargozini,
        "is_manager": isManager,
        "is_kargozini_accept": isKargoziniAccept,
        "is_manager_accept": isManagerAccept,
        "is_read": isRead,
        "description": description,
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
        name: utf8.decode(json["name"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ShopDetail {
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

  ShopDetail({
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

  factory ShopDetail.fromJson(Map<String, dynamic> json) => ShopDetail(
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
        type: utf8.decode(json["type"].codeUnits),
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
        "shop_date": shopDate,
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

class UserDetail {
  int? id;
  DateTime? senderDate;
  DateTime? acceptDate;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isCheck;
  bool? isAccept;
  bool? isRead;
  Sernder? user;
  Sernder? sernder;

  UserDetail({
    this.id,
    this.senderDate,
    this.acceptDate,
    this.createAt,
    this.updateAt,
    this.isCheck,
    this.isAccept,
    this.isRead,
    this.user,
    this.sernder,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        senderDate: json["sender_date"] == null
            ? null
            : DateTime.parse(json["sender_date"]),
        acceptDate: json["accept_date"] == null
            ? null
            : DateTime.parse(json["accept_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        isCheck: json["is_check"],
        isAccept: json["is_accept"],
        isRead: json["is_read"],
        user: json["user"] == null ? null : Sernder.fromJson(json["user"]),
        sernder:
            json["sernder"] == null ? null : Sernder.fromJson(json["sernder"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_date": senderDate?.toIso8601String(),
        "accept_date": acceptDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "is_check": isCheck,
        "is_accept": isAccept,
        "is_read": isRead,
        "user": user?.toJson(),
        "sernder": sernder?.toJson(),
      };
}

class Sernder {
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

  Sernder({
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
  });

  factory Sernder.fromJson(Map<String, dynamic> json) => Sernder(
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
      };
}
