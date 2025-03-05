import 'dart:convert';

TwoLeaveAllModel twoLeaveAllModelFromJson(String str) =>
    TwoLeaveAllModel.fromJson(json.decode(str));

String twoLeaveAllModelToJson(TwoLeaveAllModel data) =>
    json.encode(data.toJson());

class TwoLeaveAllModel {
  List<Leave>? leaveEntries;
  List<Leave>? leaveDataClock;

  TwoLeaveAllModel({
    this.leaveEntries,
    this.leaveDataClock,
  });

  factory TwoLeaveAllModel.fromJson(Map<String, dynamic> json) =>
      TwoLeaveAllModel(
        leaveEntries: json["leave_entries"] == null
            ? []
            : List<Leave>.from(
                json["leave_entries"]!.map((x) => Leave.fromJson(x))),
        leaveDataClock: json["leave_data_clock"] == null
            ? []
            : List<Leave>.from(
                json["leave_data_clock"]!.map((x) => Leave.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "leave_entries": leaveEntries == null
            ? []
            : List<dynamic>.from(leaveEntries!.map((x) => x.toJson())),
        "leave_data_clock": leaveDataClock == null
            ? []
            : List<dynamic>.from(leaveDataClock!.map((x) => x.toJson())),
      };
}

class Leave {
  int? id;
  DateTime? clockLeaveDate;
  DateTime? daysStartDate;
  DateTime? daysEndDate;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isDays;
  bool? isClock;
  String? daysSelect;
  String? managerSelect;
  bool? isAccept;
  String? clockStartTime;
  String? clockEndTime;
  String? description;
  String? allDate;
  bool? managerAccept;
  bool? salonAccept;
  User? user;
  bool? finalAccept;
  bool? isReject;

  Leave({
    this.id,
    this.clockLeaveDate,
    this.daysStartDate,
    this.daysEndDate,
    this.createAt,
    this.updateAt,
    this.isDays,
    this.isClock,
    this.daysSelect,
    this.managerSelect,
    this.isAccept,
    this.clockStartTime,
    this.clockEndTime,
    this.description,
    this.allDate,
    this.managerAccept,
    this.salonAccept,
    this.user,
    this.finalAccept,
    this.isReject,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        id: json["id"],
        clockLeaveDate: json["clock_leave_date"] == null
            ? null
            : DateTime.parse(json["clock_leave_date"]),
        daysStartDate: json["days_start_date"] == null
            ? null
            : DateTime.parse(json["days_start_date"]),
        daysEndDate: json["days_end_date"] == null
            ? null
            : DateTime.parse(json["days_end_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        isDays: json["is_days"],
        isClock: json["is_clock"],
        daysSelect: json["days_select"],
        managerSelect: json["manager_select"],
        isAccept: json["is_accept"],
        clockStartTime: json["clock_start_time"],
        clockEndTime: json["clock_end_time"],
        description: utf8.decode(json["description"].codeUnits),
        allDate: json["all_date"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        isReject: json["is_reject"],
        finalAccept: json["final_accept"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clock_leave_date": clockLeaveDate?.toIso8601String(),
        "days_start_date": daysStartDate?.toIso8601String(),
        "days_end_date": daysEndDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "is_days": isDays,
        "is_clock": isClock,
        "days_select": daysSelect,
        "manager_select": managerSelect,
        "is_accept": isAccept,
        "clock_start_time": clockStartTime,
        "clock_end_time": clockEndTime,
        "description": description,
        "all_date": allDate,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "user": user?.toJson(),
        "is_reject": isReject,
        "final_accept": finalAccept,
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
