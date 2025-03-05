// To parse this JSON data, do
//
//     final leaveCountModel = leaveCountModelFromJson(jsonString);

import 'dart:convert';

List<LeaveCountModel> leaveCountModelFromJson(String str) => List<LeaveCountModel>.from(json.decode(str).map((x) => LeaveCountModel.fromJson(x)));

String leaveCountModelToJson(List<LeaveCountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveCountModel {
    int? id;
    int? days;
    User? user;

    LeaveCountModel({
        this.id,
        this.days,
        this.user,
    });

    factory LeaveCountModel.fromJson(Map<String, dynamic> json) => LeaveCountModel(
        id: json["id"],
        days: json["days"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "days": days,
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
    int? company;
    int? unit;
    int? group;
    List<int>? access;
    List<int>? adminAccess;

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
        createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null ? null : DateTime.parse(json["update_at"]),
        company: json["company"],
        unit: json["unit"],
        group: json["group"],
        access: json["access"] == null ? [] : List<int>.from(json["access"]!.map((x) => x)),
        adminAccess: json["admin_access"] == null ? [] : List<int>.from(json["admin_access"]!.map((x) => x)),
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
        "access": access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
        "admin_access": adminAccess == null ? [] : List<dynamic>.from(adminAccess!.map((x) => x)),
    };
}
