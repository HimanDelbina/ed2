import 'dart:convert';

List<ClientRequestAdminMidel> clientRequestAdminMidelFromJson(String str) =>
    List<ClientRequestAdminMidel>.from(
        json.decode(str).map((x) => ClientRequestAdminMidel.fromJson(x)));

String clientRequestAdminMidelToJson(List<ClientRequestAdminMidel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClientRequestAdminMidel {
  int? id;
  DateTime? clientLogin;
  DateTime? clientExit;
  DateTime? createAt;
  DateTime? updateAt;
  String? typeWork;
  String? unit;
  String? carPlate;
  String? phoneNumber;
  String? name;
  bool? adminAccept;
  bool? adminReject;
  User? user;

  ClientRequestAdminMidel({
    this.id,
    this.clientLogin,
    this.clientExit,
    this.createAt,
    this.updateAt,
    this.typeWork,
    this.unit,
    this.carPlate,
    this.phoneNumber,
    this.name,
    this.adminAccept,
    this.adminReject,
    this.user,
  });

  factory ClientRequestAdminMidel.fromJson(Map<String, dynamic> json) =>
      ClientRequestAdminMidel(
        id: json["id"],
        clientLogin: json["client_login"] == null
            ? null
            : DateTime.parse(json["client_login"]),
        clientExit: json["client_exit"] == null
            ? null
            : DateTime.parse(json["client_exit"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        typeWork: json["type_work"],
        unit: json["unit"],
        carPlate: utf8.decode(json["car_plate"].codeUnits),
        phoneNumber: json["phone_number"],
        name: utf8.decode(json["name"].codeUnits),
        adminAccept: json["admin_accept"],
        adminReject: json["admin_reject"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_login": clientLogin?.toIso8601String(),
        "client_exit": clientExit?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "type_work": typeWork,
        "unit": unit,
        "car_plate": carPlate,
        "phone_number": phoneNumber,
        "name": name,
        "admin_accept": adminAccept,
        "admin_reject": adminReject,
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
