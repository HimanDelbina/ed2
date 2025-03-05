// To parse this JSON data, do
//
//     final voiceGetAllDataModel = voiceGetAllDataModelFromJson(jsonString);

import 'dart:convert';

VoiceGetAllDataModel voiceGetAllDataModelFromJson(Map<String, dynamic> json) =>
    VoiceGetAllDataModel.fromJson(json);

String voiceGetAllDataModelToJson(VoiceGetAllDataModel data) =>
    json.encode(data.toJson());

class VoiceGetAllDataModel {
  User? userInfo;
  List<Fund>? funds;
  List<Cartex>? cartex;
  List<Clothe>? clothes;
  List<Anbar>? anbar;
  List<Gharardad>? gharardad;
  List<Food>? food;
  List<Mission>? missions;
  List<Leaf>? leaves;
  List<Shift>? shifts;
  List<Overtime>? overtime;
  List<Loan>? loans;

  VoiceGetAllDataModel({
    this.userInfo,
    this.funds,
    this.cartex,
    this.clothes,
    this.anbar,
    this.gharardad,
    this.food,
    this.missions,
    this.leaves,
    this.shifts,
    this.overtime,
    this.loans,
  });

  factory VoiceGetAllDataModel.fromJson(Map<String, dynamic> json) =>
      VoiceGetAllDataModel(
        userInfo:
            json["user_info"] == null ? null : User.fromJson(json["user_info"]),
        funds: json["funds"] == null
            ? []
            : List<Fund>.from(json["funds"]!.map((x) => Fund.fromJson(x))),
        cartex: json["cartex"] == null
            ? []
            : List<Cartex>.from(json["cartex"]!.map((x) => Cartex.fromJson(x))),
        clothes: json["clothes"] == null
            ? []
            : List<Clothe>.from(
                json["clothes"]!.map((x) => Clothe.fromJson(x))),
        anbar: json["anbar"] == null
            ? []
            : List<Anbar>.from(json["anbar"]!.map((x) => Anbar.fromJson(x))),
        gharardad: json["gharardad"] == null
            ? []
            : List<Gharardad>.from(
                json["gharardad"]!.map((x) => Gharardad.fromJson(x))),
        food: json["food"] == null
            ? []
            : List<Food>.from(json["food"]!.map((x) => Food.fromJson(x))),
        missions: json["missions"] == null
            ? []
            : List<Mission>.from(
                json["missions"]!.map((x) => Mission.fromJson(x))),
        leaves: json["leaves"] == null
            ? []
            : List<Leaf>.from(json["leaves"]!.map((x) => Leaf.fromJson(x))),
        shifts: json["shifts"] == null
            ? []
            : List<Shift>.from(json["shifts"]!.map((x) => Shift.fromJson(x))),
        overtime: json["overtime"] == null
            ? []
            : List<Overtime>.from(
                json["overtime"]!.map((x) => Overtime.fromJson(x))),
        loans: json["loans"] == null
            ? []
            : List<Loan>.from(json["loans"]!.map((x) => Loan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_info": userInfo?.toJson(),
        "funds": funds == null
            ? []
            : List<dynamic>.from(funds!.map((x) => x.toJson())),
        "cartex": cartex == null
            ? []
            : List<dynamic>.from(cartex!.map((x) => x.toJson())),
        "clothes": clothes == null
            ? []
            : List<dynamic>.from(clothes!.map((x) => x.toJson())),
        "anbar": anbar == null
            ? []
            : List<dynamic>.from(anbar!.map((x) => x.toJson())),
        "gharardad": gharardad == null
            ? []
            : List<dynamic>.from(gharardad!.map((x) => x.toJson())),
        "food": food == null
            ? []
            : List<dynamic>.from(food!.map((x) => x.toJson())),
        "missions": missions == null
            ? []
            : List<dynamic>.from(missions!.map((x) => x.toJson())),
        "leaves": leaves == null
            ? []
            : List<dynamic>.from(leaves!.map((x) => x.toJson())),
        "shifts": shifts == null
            ? []
            : List<dynamic>.from(shifts!.map((x) => x.toJson())),
        "overtime": overtime == null
            ? []
            : List<dynamic>.from(overtime!.map((x) => x.toJson())),
        "loans": loans == null
            ? []
            : List<dynamic>.from(loans!.map((x) => x.toJson())),
      };
}

class Anbar {
  int? id;
  User? user;
  List<Commodity>? commodities;
  ManagerSelect? managerSelect;
  DateTime? anbarDate;
  String? description;
  DateTime? acceptDate;
  bool? isAccept;
  bool? managerAccept;
  bool? salonAccept;
  bool? anbarAccept;
  DateTime? createAt;
  DateTime? updateAt;

  Anbar({
    this.id,
    this.user,
    this.commodities,
    this.managerSelect,
    this.anbarDate,
    this.description,
    this.acceptDate,
    this.isAccept,
    this.managerAccept,
    this.salonAccept,
    this.anbarAccept,
    this.createAt,
    this.updateAt,
  });

  factory Anbar.fromJson(Map<String, dynamic> json) => Anbar(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        commodities: json["commodities"] == null
            ? []
            : List<Commodity>.from(
                json["commodities"]!.map((x) => Commodity.fromJson(x))),
        managerSelect: managerSelectValues.map[json["manager_select"]]!,
        anbarDate: json["anbar_date"] == null
            ? null
            : DateTime.parse(json["anbar_date"]),
        description: json["description"],
        acceptDate: json["accept_date"] == null
            ? null
            : DateTime.parse(json["accept_date"]),
        isAccept: json["is_accept"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        anbarAccept: json["anbar_accept"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "commodities": commodities == null
            ? []
            : List<dynamic>.from(commodities!.map((x) => x.toJson())),
        "manager_select": managerSelectValues.reverse[managerSelect],
        "anbar_date": anbarDate?.toIso8601String(),
        "description": description,
        "accept_date": acceptDate?.toIso8601String(),
        "is_accept": isAccept,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "anbar_accept": anbarAccept,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
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

enum ManagerSelect { EMPTY, MS, MV }

final managerSelectValues = EnumValues(
    {"": ManagerSelect.EMPTY, "MS": ManagerSelect.MS, "MV": ManagerSelect.MV});

class User {
  String? firstName;
  String? lastName;
  String? phoneNumber;

  User({
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstNameValues.reverse[firstName],
        "last_name": lastNameValues.reverse[lastName],
        "phone_number": phoneNumber,
      };
}

enum FirstName { EMPTY }

final firstNameValues = EnumValues({"هیمن": FirstName.EMPTY});

enum LastName { EMPTY }

final lastNameValues = EnumValues({"دل بینا": LastName.EMPTY});

class Cartex {
  int? id;
  User? user;
  String? name;
  DateTime? createAt;
  DateTime? updateAt;

  Cartex({
    this.id,
    this.user,
    this.name,
    this.createAt,
    this.updateAt,
  });

  factory Cartex.fromJson(Map<String, dynamic> json) => Cartex(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        name: utf8.decode(json["name"].codeUnits),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "name": name,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

class Clothe {
  int? id;
  User? user;
  bool? isCloth;
  bool? isShoes;
  DateTime? shoesDate;
  DateTime? clothDate;
  DateTime? createAt;
  DateTime? updateAt;

  Clothe({
    this.id,
    this.user,
    this.isCloth,
    this.isShoes,
    this.shoesDate,
    this.clothDate,
    this.createAt,
    this.updateAt,
  });

  factory Clothe.fromJson(Map<String, dynamic> json) => Clothe(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        isCloth: json["is_cloth"],
        isShoes: json["is_shoes"],
        shoesDate: json["shoes_date"] == null
            ? null
            : DateTime.parse(json["shoes_date"]),
        clothDate: json["cloth_date"] == null
            ? null
            : DateTime.parse(json["cloth_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "is_cloth": isCloth,
        "is_shoes": isShoes,
        "shoes_date": shoesDate?.toIso8601String(),
        "cloth_date": clothDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

class Food {
  int? id;
  User? user;
  LunchSelect? lunchSelect;
  ManagerSelect? managerSelect;
  bool? isAccept;
  DateTime? foodDate;
  String? description;
  bool? managerAccept;
  bool? salonAccept;
  DateTime? createAt;
  DateTime? updateAt;

  Food({
    this.id,
    this.user,
    this.lunchSelect,
    this.managerSelect,
    this.isAccept,
    this.foodDate,
    this.description,
    this.managerAccept,
    this.salonAccept,
    this.createAt,
    this.updateAt,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        lunchSelect: lunchSelectValues.map[json["lunch_select"]]!,
        managerSelect: managerSelectValues.map[json["manager_select"]]!,
        isAccept: json["is_accept"],
        foodDate: json["food_date"] == null
            ? null
            : DateTime.parse(json["food_date"]),
        description: utf8.decode(json["description"].codeUnits),
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "lunch_select": lunchSelectValues.reverse[lunchSelect],
        "manager_select": managerSelectValues.reverse[managerSelect],
        "is_accept": isAccept,
        "food_date": foodDate?.toIso8601String(),
        "description": description,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

enum LunchSelect { NA }

final lunchSelectValues = EnumValues({"NA": LunchSelect.NA});

class Fund {
  int? id;
  User? user;
  String? allMoney;
  String? money;
  DateTime? createAt;
  DateTime? updateAt;

  Fund({
    this.id,
    this.user,
    this.allMoney,
    this.money,
    this.createAt,
    this.updateAt,
  });

  factory Fund.fromJson(Map<String, dynamic> json) => Fund(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        allMoney: json["all_money"],
        money: json["money"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "all_money": allMoney,
        "money": money,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

class Gharardad {
  int? id;
  User? user;
  DateTime? startDate;
  DateTime? endDate;
  String? money;
  bool? isFinish;
  bool? isFinishWork;

  Gharardad({
    this.id,
    this.user,
    this.startDate,
    this.endDate,
    this.money,
    this.isFinish,
    this.isFinishWork,
  });

  factory Gharardad.fromJson(Map<String, dynamic> json) => Gharardad(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        money: json["money"],
        isFinish: json["is_finish"],
        isFinishWork: json["is_finish_work"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "money": money,
        "is_finish": isFinish,
        "is_finish_work": isFinishWork,
      };
}

class Leaf {
  int? id;
  User? user;
  bool? isDays;
  bool? isClock;
  String? daysSelect;
  ManagerSelect? managerSelect;
  bool? isAccept;
  bool? isReject;
  DateTime? clockLeaveDate;
  DateTime? daysStartDate;
  DateTime? daysEndDate;
  String? clockStartTime;
  String? clockEndTime;
  String? description;
  String? allDate;
  bool? managerAccept;
  bool? salonAccept;
  bool? finalAccept;
  DateTime? createAt;
  DateTime? updateAt;

  Leaf({
    this.id,
    this.user,
    this.isDays,
    this.isClock,
    this.daysSelect,
    this.managerSelect,
    this.isAccept,
    this.isReject,
    this.clockLeaveDate,
    this.daysStartDate,
    this.daysEndDate,
    this.clockStartTime,
    this.clockEndTime,
    this.description,
    this.allDate,
    this.managerAccept,
    this.salonAccept,
    this.finalAccept,
    this.createAt,
    this.updateAt,
  });

  factory Leaf.fromJson(Map<String, dynamic> json) => Leaf(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        isDays: json["is_days"],
        isClock: json["is_clock"],
        daysSelect: json["days_select"],
        managerSelect: managerSelectValues.map[json["manager_select"]]!,
        isAccept: json["is_accept"],
        isReject: json["is_reject"],
        clockLeaveDate: json["clock_leave_date"] == null
            ? null
            : DateTime.parse(json["clock_leave_date"]),
        daysStartDate: json["days_start_date"] == null
            ? null
            : DateTime.parse(json["days_start_date"]),
        daysEndDate: json["days_end_date"] == null
            ? null
            : DateTime.parse(json["days_end_date"]),
        clockStartTime: json["clock_start_time"],
        clockEndTime: json["clock_end_time"],
        description: utf8.decode(json["description"].codeUnits),
        allDate: json["all_date"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        finalAccept: json["final_accept"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "is_days": isDays,
        "is_clock": isClock,
        "days_select": daysSelect,
        "manager_select": managerSelectValues.reverse[managerSelect],
        "is_accept": isAccept,
        "is_reject": isReject,
        "clock_leave_date": clockLeaveDate?.toIso8601String(),
        "days_start_date": daysStartDate?.toIso8601String(),
        "days_end_date": daysEndDate?.toIso8601String(),
        "clock_start_time": clockStartTime,
        "clock_end_time": clockEndTime,
        "description": description,
        "all_date": allDate,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "final_accept": finalAccept,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

class Loan {
  int? id;
  User? user;
  String? loanSelect;
  String? moneyRequest;
  bool? isBox;
  dynamic boxMoney;
  bool? isLoanZa;
  dynamic loanZaMoney;
  bool? isLoanMa;
  dynamic loanMaMoney;
  bool? isKargozini;
  bool? isManager;
  bool? isKargoziniAccept;
  bool? isManagerAccept;
  bool? isRead;
  DateTime? kargoziniDate;
  dynamic managerDate;
  String? description;
  DateTime? createAt;
  DateTime? updateAt;

  Loan({
    this.id,
    this.user,
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
    this.kargoziniDate,
    this.managerDate,
    this.description,
    this.createAt,
    this.updateAt,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
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
        kargoziniDate: json["kargozini_date"] == null
            ? null
            : DateTime.parse(json["kargozini_date"]),
        managerDate: json["manager_date"],
        description: utf8.decode(json["description"].codeUnits),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
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
        "kargozini_date": kargoziniDate?.toIso8601String(),
        "manager_date": managerDate,
        "description": description,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

class Mission {
  int? id;
  User? user;
  bool? isAccept;
  DateTime? missionDate;
  String? missionStartTime;
  String? missionEndTime;
  String? description;
  DateTime? createAt;
  DateTime? updateAt;

  Mission({
    this.id,
    this.user,
    this.isAccept,
    this.missionDate,
    this.missionStartTime,
    this.missionEndTime,
    this.description,
    this.createAt,
    this.updateAt,
  });

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        isAccept: json["is_accept"],
        missionDate: json["mission_date"] == null
            ? null
            : DateTime.parse(json["mission_date"]),
        missionStartTime: json["mission_start_time"],
        missionEndTime: json["mission_end_time"],
        description: utf8.decode(json["description"].codeUnits),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "is_accept": isAccept,
        "mission_date": missionDate?.toIso8601String(),
        "mission_start_time": missionStartTime,
        "mission_end_time": missionEndTime,
        "description": description,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

class Overtime {
  int? id;
  User? user;
  bool? isAccept;
  DateTime? overtimeDate;
  String? select;
  String? startTime;
  String? endTime;
  String? description;
  bool? managerAccept;
  bool? salonAccept;
  DateTime? createAt;
  DateTime? updateAt;

  Overtime({
    this.id,
    this.user,
    this.isAccept,
    this.overtimeDate,
    this.select,
    this.startTime,
    this.endTime,
    this.description,
    this.managerAccept,
    this.salonAccept,
    this.createAt,
    this.updateAt,
  });

  factory Overtime.fromJson(Map<String, dynamic> json) => Overtime(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        isAccept: json["is_accept"],
        overtimeDate: json["overtime_date"] == null
            ? null
            : DateTime.parse(json["overtime_date"]),
        select: json["select"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        description: utf8.decode(json["description"].codeUnits),
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "is_accept": isAccept,
        "overtime_date": overtimeDate?.toIso8601String(),
        "select": select,
        "start_time": startTime,
        "end_time": endTime,
        "description": description,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
      };
}

class Shift {
  int? id;
  User? user;
  String? daysSelect;
  DateTime? shiftDate;
  int? shiftCount;
  bool? isCheck;
  DateTime? createAt;
  DateTime? updateAt;

  Shift({
    this.id,
    this.user,
    this.daysSelect,
    this.shiftDate,
    this.shiftCount,
    this.isCheck,
    this.createAt,
    this.updateAt,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        daysSelect: json["days_select"],
        shiftDate: json["shift_date"] == null
            ? null
            : DateTime.parse(json["shift_date"]),
        shiftCount: json["shift_count"],
        isCheck: json["is_check"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "days_select": daysSelect,
        "shift_date": shiftDate?.toIso8601String(),
        "shift_count": shiftCount,
        "is_check": isCheck,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
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



