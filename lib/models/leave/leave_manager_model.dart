import 'dart:convert';

LeaveManagerModel leaveManagerModelFromJson(String str) =>
    LeaveManagerModel.fromJson(json.decode(str));

String leaveManagerModelToJson(LeaveManagerModel data) =>
    json.encode(data.toJson());

class LeaveManagerModel {
  List<Leave>? leaveEntries;
  List<Leave>? leaveDataClock;
  int? totalDaysSum;
  double? sumData;
  double? dayToClock;
  double? clockToDay;
  double? sumAllClock;
  double? sumAllDay;
  double? sumMonthDay;
  double? sumMonthClock;

  LeaveManagerModel({
    this.leaveEntries,
    this.leaveDataClock,
    this.totalDaysSum,
    this.sumData,
    this.dayToClock,
    this.clockToDay,
    this.sumAllClock,
    this.sumAllDay,
    this.sumMonthDay,
    this.sumMonthClock,
  });

  factory LeaveManagerModel.fromJson(Map<String, dynamic> json) =>
      LeaveManagerModel(
        leaveEntries: json["leave_entries"] == null
            ? []
            : List<Leave>.from(
                json["leave_entries"]!.map((x) => Leave.fromJson(x))),
        leaveDataClock: json["leave_data_clock"] == null
            ? []
            : List<Leave>.from(
                json["leave_data_clock"]!.map((x) => Leave.fromJson(x))),
        totalDaysSum: json["total_days_sum"],
        sumData: json["sum_data"]?.toDouble(),
        dayToClock: json["day_to_clock"]?.toDouble(),
        clockToDay: json["clock_to_day"]?.toDouble(),
        sumAllClock: json["sum_all_clock"]?.toDouble(),
        sumAllDay: json["sum_all_day"]?.toDouble(),
        sumMonthDay: json["sum_month_day"]?.toDouble(),
        sumMonthClock: json["sum_month_clock"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "leave_entries": leaveEntries == null
            ? []
            : List<dynamic>.from(leaveEntries!.map((x) => x.toJson())),
        "leave_data_clock": leaveDataClock == null
            ? []
            : List<dynamic>.from(leaveDataClock!.map((x) => x.toJson())),
        "total_days_sum": totalDaysSum,
        "sum_data": sumData,
        "day_to_clock": dayToClock,
        "clock_to_day": clockToDay,
        "sum_all_clock": sumAllClock,
        "sum_all_day": sumAllDay,
        "sum_month_day": sumMonthDay,
        "sum_month_clock": sumMonthClock,
      };
}

class Leave {
  int? id;
  String? clockLeaveDate;
  String? daysStartDate;
  String? daysEndDate;
  String? createAt;
  String? updateAt;
  bool? isDays;
  bool? isClock;
  String? daysSelect;
  bool? isAccept;
  String? clockStartTime;
  String? clockEndTime;
  String? description;
  String? allDate;
  bool? managerAccept;
  bool? salonAccept;
  bool? finalAccept;
  bool? isReject;
  User? user;
  double? finalTime;
  int? totalDays;
  int? minusDate;

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
    this.isAccept,
    this.clockStartTime,
    this.clockEndTime,
    this.description,
    this.allDate,
    this.managerAccept,
    this.salonAccept,
    this.finalAccept,
    this.isReject,
    this.user,
    this.finalTime,
    this.totalDays,
    this.minusDate,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        id: json["id"],
        clockLeaveDate: json["clock_leave_date"],
        daysStartDate: json["days_start_date"],
        daysEndDate: json["days_end_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        isDays: json["is_days"],
        isClock: json["is_clock"],
        daysSelect: json["days_select"],
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
        finalTime: json["final_time"]?.toDouble(),
        totalDays: json["total_days"],
        minusDate: json["minus_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clock_leave_date": clockLeaveDate,
        "days_start_date": daysStartDate,
        "days_end_date": daysEndDate,
        "create_at": createAt,
        "update_at": updateAt,
        "is_days": isDays,
        "is_clock": isClock,
        "days_select": daysSelect,
        "is_accept": isAccept,
        "clock_start_time": clockStartTime,
        "clock_end_time": clockEndTime,
        "description": description,
        "all_date": allDate,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "is_reject": isReject,
        "final_accept": finalAccept,
        "user": user?.toJson(),
        "final_time": finalTime,
        "total_days": totalDays,
        "minus_date": minusDate,
      };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? companyCode;
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
  int? unit;
  List<int>? access;
  List<dynamic>? adminAccess;
  String? melliCode;
  String? insuranceCode;
  int? company;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.companyCode,
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
    this.unit,
    this.access,
    this.adminAccess,
    this.melliCode,
    this.insuranceCode,
    this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
        phoneNumber: json["phone_number"],
        companyCode: json["company_code"],
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
        unit: json["unit"],
        access: json["access"] == null
            ? []
            : List<int>.from(json["access"]!.map((x) => x)),
        adminAccess: json["admin_access"] == null
            ? []
            : List<dynamic>.from(json["admin_access"]!.map((x) => x)),
        company: json["company"],
        melliCode: json["melli_code"],
        insuranceCode: json["insurance_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "company_code": companyCode,
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
        "unit": unit,
        "company": company,
        "melli_code": melliCode,
        "insurance_code": insuranceCode,
        "access":
            access == null ? [] : List<dynamic>.from(access!.map((x) => x)),
        "admin_access": adminAccess == null
            ? []
            : List<dynamic>.from(adminAccess!.map((x) => x)),
      };
}
