import 'dart:convert';

List<ImportCommodityModel> importCommodityModelFromJson(String str) =>
    List<ImportCommodityModel>.from(
        json.decode(str).map((x) => ImportCommodityModel.fromJson(x)));

String importCommodityModelToJson(List<ImportCommodityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImportCommodityModel {
  int? id;
  DateTime? anbarDate;
  DateTime? adminDate;
  DateTime? createAt;
  DateTime? updateAt;
  String? select;
  String? name;
  String? carPlate;
  String? weightCommodity;
  String? countCommodity;
  String? commodityDescription;
  String? sellerName;
  String? deliveryPerson;
  String? carPhone;
  String? editDescription;
  bool? isEdit;
  bool? isGuard;
  bool? isAnbar;
  bool? isAdmin;
  bool? isPrint;
  User? user;
  Car? company;
  Car? car;

  ImportCommodityModel({
    this.id,
    this.anbarDate,
    this.adminDate,
    this.createAt,
    this.updateAt,
    this.select,
    this.name,
    this.carPlate,
    this.weightCommodity,
    this.countCommodity,
    this.commodityDescription,
    this.sellerName,
    this.deliveryPerson,
    this.carPhone,
    this.editDescription,
    this.isEdit,
    this.isGuard,
    this.isAnbar,
    this.isAdmin,
    this.isPrint,
    this.user,
    this.company,
    this.car,
  });

  factory ImportCommodityModel.fromJson(Map<String, dynamic> json) =>
      ImportCommodityModel(
        id: json["id"],
        anbarDate: json["anbar_date"] == null
            ? null
            : DateTime.parse(json["anbar_date"]),
        adminDate: json["admin_date"] == null
            ? null
            : DateTime.parse(json["admin_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        select: json["select"],
        name: utf8.decode(json["name"].codeUnits),
        carPlate: utf8.decode(json["car_plate"].codeUnits),
        weightCommodity: json["weight_commodity"],
        countCommodity: json["count_commodity"],
        commodityDescription:
            utf8.decode(json["commodity_description"].codeUnits),
        sellerName: utf8.decode(json["seller_name"].codeUnits),
        deliveryPerson: utf8.decode(json["delivery_person"].codeUnits),
        carPhone: json["car_phone"],
        editDescription: utf8.decode(json["edit_description"].codeUnits),
        isEdit: json["is_edit"],
        isGuard: json["is_guard"],
        isAnbar: json["is_anbar"],
        isAdmin: json["is_admin"],
        isPrint: json["is_print"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        company: json["company"] == null ? null : Car.fromJson(json["company"]),
        car: json["car"] == null ? null : Car.fromJson(json["car"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "anbar_date": anbarDate?.toIso8601String(),
        "admin_date": adminDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "select": select,
        "name": name,
        "car_plate": carPlate,
        "weight_commodity": weightCommodity,
        "count_commodity": countCommodity,
        "commodity_description": commodityDescription,
        "seller_name": sellerName,
        "delivery_person": deliveryPerson,
        "car_phone": carPhone,
        "edit_description": editDescription,
        "is_edit": isEdit,
        "is_guard": isGuard,
        "is_anbar": isAnbar,
        "is_admin": isAdmin,
        "is_print": isPrint,
        "user": user?.toJson(),
        "company": company?.toJson(),
        "car": car?.toJson(),
      };
}

class Car {
  int? id;
  String? name;

  Car({
    this.id,
    this.name,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
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
