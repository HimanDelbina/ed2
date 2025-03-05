import 'dart:convert';

AllDataModel allDataModelFromJson(String str) =>
    AllDataModel.fromJson(json.decode(str));

String allDataModelToJson(AllDataModel data) => json.encode(data.toJson());

class AllDataModel {
  List<Overtime>? overtime;
  List<Leave>? leave;
  List<Food>? food;
  List<Anbar>? anbar;

  AllDataModel({
    this.overtime,
    this.leave,
    this.food,
    this.anbar,
  });

  factory AllDataModel.fromJson(Map<String, dynamic> json) => AllDataModel(
        overtime: json["overtime"] == null
            ? []
            : List<Overtime>.from(
                json["overtime"]!.map((x) => Overtime.fromJson(x))),
        leave: json["leave"] == null
            ? []
            : List<Leave>.from(json["leave"]!.map((x) => Leave.fromJson(x))),
        food: json["food"] == null
            ? []
            : List<Food>.from(json["food"]!.map((x) => Food.fromJson(x))),
        anbar: json["anbar"] == null
            ? []
            : List<Anbar>.from(json["anbar"]!.map((x) => Anbar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "overtime": overtime == null
            ? []
            : List<dynamic>.from(overtime!.map((x) => x.toJson())),
        "leave": leave == null
            ? []
            : List<dynamic>.from(leave!.map((x) => x.toJson())),
        "food": food == null
            ? []
            : List<dynamic>.from(food!.map((x) => x.toJson())),
        "anbar": anbar == null
            ? []
            : List<dynamic>.from(anbar!.map((x) => x.toJson())),
      };
}

class Anbar {
  int? id;
  String? acceptDate;
  String? anbarDate;
  String? createAt;
  String? updateAt;
  List<Commodity>? commodities;
  String? managerSelect;
  String? clockCreate;
  String? clockAccept;
  String? clockDateAnbar;
  String? description;
  bool? isAccept;
  bool? managerAccept;
  bool? salonAccept;
  bool? anbarAccept;
  User? user;

  Anbar({
    this.id,
    this.acceptDate,
    this.anbarDate,
    this.createAt,
    this.updateAt,
    this.commodities,
    this.managerSelect,
    this.clockCreate,
    this.clockAccept,
    this.clockDateAnbar,
    this.description,
    this.isAccept,
    this.managerAccept,
    this.salonAccept,
    this.anbarAccept,
    this.user,
  });

  factory Anbar.fromJson(Map<String, dynamic> json) => Anbar(
        id: json["id"],
        acceptDate: json["accept_date"],
        anbarDate: json["anbar_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        commodities: json["commodities"] == null
            ? []
            : List<Commodity>.from(
                json["commodities"]!.map((x) => Commodity.fromJson(x))),
        managerSelect: json["manager_select"],
        clockCreate: json["clock_create"],
        clockAccept: json["clock_accept"],
        clockDateAnbar: json["clock_date_anbar"],
        description: utf8.decode(json["description"].codeUnits),
        isAccept: json["is_accept"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        anbarAccept: json["anbar_accept"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accept_date": acceptDate,
        "anbar_date": anbarDate,
        "create_at": createAt,
        "update_at": updateAt,
        "commodities": commodities == null
            ? []
            : List<dynamic>.from(commodities!.map((x) => x.toJson())),
        "manager_select": managerSelect,
        "clock_create": clockCreate,
        "clock_accept": clockAccept,
        "clock_date_anbar": clockDateAnbar,
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

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? companyCode;
  String? password;
  String? image;
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
      };
}

enum FirstName { EMPTY }

final firstNameValues = EnumValues({"هیمن": FirstName.EMPTY});

enum LastName { EMPTY }

final lastNameValues = EnumValues({"دل بینا": LastName.EMPTY});

class Food {
  int? id;
  String? foodDate;
  String? createAt;
  String? updateAt;
  String? lunchSelect;
  String? managerSelect;
  bool? isAccept;
  String? description;
  bool? managerAccept;
  bool? salonAccept;
  User? user;

  Food({
    this.id,
    this.foodDate,
    this.createAt,
    this.updateAt,
    this.lunchSelect,
    this.managerSelect,
    this.isAccept,
    this.description,
    this.managerAccept,
    this.salonAccept,
    this.user,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"],
        foodDate: json["food_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        lunchSelect: json["lunch_select"],
        managerSelect: json["manager_select"],
        isAccept: json["is_accept"],
        description: utf8.decode(json["description"].codeUnits),
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "food_date": foodDate,
        "create_at": createAt,
        "update_at": updateAt,
        "lunch_select": lunchSelect,
        "manager_select": managerSelect,
        "is_accept": isAccept,
        "description": description,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "user": user?.toJson(),
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
        clockLeaveDate: json["clock_leave_date"],
        daysStartDate: json["days_start_date"],
        daysEndDate: json["days_end_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
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
        "clock_leave_date": clockLeaveDate,
        "days_start_date": daysStartDate,
        "days_end_date": daysEndDate,
        "create_at": createAt,
        "update_at": updateAt,
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
        "is_reject": isReject,
        "final_accept": finalAccept,
        "user": user?.toJson(),
      };
}

class Overtime {
  int? id;
  String? overtimeDate;
  String? createAt;
  String? updateAt;
  bool? isAccept;
  String? select;
  String? startTime;
  String? endTime;
  String? description;
  bool? managerAccept;
  bool? salonAccept;
  User? user;

  Overtime({
    this.id,
    this.overtimeDate,
    this.createAt,
    this.updateAt,
    this.isAccept,
    this.select,
    this.startTime,
    this.endTime,
    this.description,
    this.managerAccept,
    this.salonAccept,
    this.user,
  });

  factory Overtime.fromJson(Map<String, dynamic> json) => Overtime(
        id: json["id"],
        overtimeDate: json["overtime_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        isAccept: json["is_accept"],
        select: json["select"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        description: utf8.decode(json["description"].codeUnits),
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "overtime_date": overtimeDate,
        "create_at": createAt,
        "update_at": updateAt,
        "is_accept": isAccept,
        "select": select,
        "start_time": startTime,
        "end_time": endTime,
        "description": description,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "user": user?.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
