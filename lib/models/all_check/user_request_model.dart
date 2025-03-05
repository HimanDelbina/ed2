import 'dart:convert';

List<User> userrequestModelFromJson(String str) => 
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userrequestModelToJson(List<User> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class UserrequestModel {
  List<User>? user;

  UserrequestModel({
    this.user,
  });

  factory UserrequestModel.fromJson(Map<String, dynamic> json) =>
      UserrequestModel(
        user: json["user"] == null
            ? []
            : List<User>.from(json["user"]!.map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user": user == null
            ? []
            : List<dynamic>.from(user!.map((x) => x.toJson())),
      };
}

class User {
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

  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
  bool? isKargozini;
  bool? isSalonManager;
  bool? isUnitManager;
  DateTime? createAt;
  DateTime? updateAt;
  int? company;
  int? unit;
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
    this.isKargozini,
    this.isSalonManager,
    this.isUnitManager,
    this.createAt,
    this.updateAt,
    this.company,
    this.unit,
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
        isKargozini: json["is_kargozini"],
        isSalonManager: json["is_salon_manager"],
        isUnitManager: json["is_unit_manager"],
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
        "is_kargozini": isKargozini,
        "is_salon_manager": isSalonManager,
        "is_unit_manager": isUnitManager,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "company": company,
        "unit": unit,
        "access":
            access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
      };
}
