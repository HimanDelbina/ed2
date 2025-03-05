import 'dart:convert';

List<UserGharardadModel> userGharardadModelFromJson(String str) => List<UserGharardadModel>.from(json.decode(str).map((x) => UserGharardadModel.fromJson(x)));

String userGharardadModelToJson(List<UserGharardadModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserGharardadModel {
    User? user;
    DateTime? contractStartDate;
    DateTime? contractEndDate;

    UserGharardadModel({
        this.user,
        this.contractStartDate,
        this.contractEndDate,
    });

    factory UserGharardadModel.fromJson(Map<String, dynamic> json) => UserGharardadModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        contractStartDate: json["contract_start_date"] == null ? null : DateTime.parse(json["contract_start_date"]),
        contractEndDate: json["contract_end_date"] == null ? null : DateTime.parse(json["contract_end_date"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "contract_start_date": contractStartDate?.toIso8601String(),
        "contract_end_date": contractEndDate?.toIso8601String(),
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
        createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null ? null : DateTime.parse(json["update_at"]),
        company: json["company"],
        unit: json["unit"],
        group: json["group"],
        access: json["access"] == null ? [] : List<int>.from(json["access"]!.map((x) => x)),
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
    };
}
