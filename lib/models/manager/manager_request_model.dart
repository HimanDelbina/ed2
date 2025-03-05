// To parse this JSON data, do
//
//     final managerRequestModel = managerRequestModelFromJson(jsonString);

import 'dart:convert';

class ManagerRequestModel {
  final List<dynamic>? user;
  final List<dynamic>? loan;
  final List<dynamic>? shop;
  final List<dynamic>? food;
  final List<dynamic>? overtime;
  final List<dynamic>? leave;
  final List<dynamic>? guard;
  final List<dynamic>? anbar;
  final List<dynamic>? work;
  final List<dynamic>? export;

  ManagerRequestModel({
    this.user,
    this.loan,
    this.shop,
    this.food,
    this.overtime,
    this.leave,
    this.guard,
    this.anbar,
    this.work,
    this.export,
  });

  factory ManagerRequestModel.fromJson(Map<String, dynamic> json) {
    return ManagerRequestModel(
      user: (json['user'] as List?)
              ?.map((e) => UserElement.fromJson(e))
              .toList() ??
          [],
      loan:
          (json['loan'] as List?)?.map((e) => Loan.fromJson(e)).toList() ?? [],
      shop:
          (json['shop'] as List?)?.map((e) => Shop.fromJson(e)).toList() ?? [],
      food:
          (json['food'] as List?)?.map((e) => Food.fromJson(e)).toList() ?? [],
      overtime: (json['overtime'] as List?)
              ?.map((e) => Overtime.fromJson(e))
              .toList() ??
          [],
      leave: (json['leave'] as List?)?.map((e) => Leave.fromJson(e)).toList() ??
          [],
      guard: (json['guard'] as List?)?.map((e) => Guard.fromJson(e)).toList() ??
          [],
      anbar: (json['anbar'] as List?)?.map((e) => Anbar.fromJson(e)).toList() ??
          [],
      work:
          (json['work'] as List?)?.map((e) => Work.fromJson(e)).toList() ?? [],
      export:
          (json['export'] as List?)?.map((e) => Export.fromJson(e)).toList() ??
              [],
    );
  }
}

class Export {
  int? id;
  DateTime? guardDate;
  DateTime? adminDate;
  DateTime? backDate;
  DateTime? guardBackDate;
  DateTime? createAt;
  DateTime? updateAt;
  String? select;
  String? name;
  String? count;
  String? weight;
  String? buyer;
  String? repairMan;
  String? recipient;
  String? carPlate;
  bool? isAnbar;
  bool? isGuard;
  bool? isAdmin;
  bool? isBackGuard;
  bool? isPrint;
  bool? isBack;
  User? user;
  Company? company;

  Export({
    this.id,
    this.guardDate,
    this.adminDate,
    this.backDate,
    this.guardBackDate,
    this.createAt,
    this.updateAt,
    this.select,
    this.name,
    this.count,
    this.weight,
    this.buyer,
    this.repairMan,
    this.recipient,
    this.carPlate,
    this.isAnbar,
    this.isGuard,
    this.isAdmin,
    this.isBackGuard,
    this.isPrint,
    this.isBack,
    this.user,
    this.company,
  });

  factory Export.fromJson(Map<String, dynamic> json) => Export(
        id: json["id"],
        guardDate: json["guard_date"] == null
            ? null
            : DateTime.parse(json["guard_date"]),
        adminDate: json["admin_date"] == null
            ? null
            : DateTime.parse(json["admin_date"]),
        backDate: json["back_date"] == null
            ? null
            : DateTime.parse(json["back_date"]),
        guardBackDate: json["guard_back_date"] == null
            ? null
            : DateTime.parse(json["guard_back_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        select: json["select"],
        name: json["name"] != null ? utf8.decode(json["name"].codeUnits) : null,
        count: json["count"],
        weight: json["weight"],
        buyer:
            json["buyer"] != null ? utf8.decode(json["buyer"].codeUnits) : null,
        repairMan: json["repair_man"] != null
            ? utf8.decode(json["repair_man"].codeUnits)
            : null,
        recipient: json["recipient"] != null
            ? utf8.decode(json["recipient"].codeUnits)
            : null,
        carPlate: json["car_plate"] != null
            ? utf8.decode(json["car_plate"].codeUnits)
            : null,
        isAnbar: json["is_anbar"],
        isGuard: json["is_guard"],
        isAdmin: json["is_admin"],
        isBackGuard: json["is_back_guard"],
        isPrint: json["is_print"],
        isBack: json["is_back"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        company:
            json["company"] == null ? null : Company.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "guard_date": guardDate?.toIso8601String(),
        "admin_date": adminDate?.toIso8601String(),
        "back_date": backDate?.toIso8601String(),
        "guard_back_date": guardBackDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "select": select,
        "name": name,
        "count": count,
        "weight": weight,
        "buyer": buyer,
        "repair_man": repairMan,
        "recipient": recipient,
        "car_plate": carPlate,
        "is_anbar": isAnbar,
        "is_guard": isGuard,
        "is_admin": isAdmin,
        "is_back_guard": isBackGuard,
        "is_print": isPrint,
        "is_back": isBack,
        "user": user?.toJson(),
        "company": company?.toJson(),
      };
}

class Anbar {
  int? id;
  DateTime? acceptDate;
  DateTime? anbarDate;
  DateTime? createAt;
  DateTime? updateAt;
  List<Commodity>? commodities;
  String? managerSelect;
  String? description;
  bool? isAccept;
  bool? managerAccept;
  bool? salonAccept;
  bool? anbarAccept;
  SernderClass? user;

  Anbar({
    this.id,
    this.acceptDate,
    this.anbarDate,
    this.createAt,
    this.updateAt,
    this.commodities,
    this.managerSelect,
    this.description,
    this.isAccept,
    this.managerAccept,
    this.salonAccept,
    this.anbarAccept,
    this.user,
  });

  factory Anbar.fromJson(Map<String, dynamic> json) => Anbar(
        id: json["id"],
        acceptDate: json["accept_date"] == null
            ? null
            : DateTime.parse(json["accept_date"]),
        anbarDate: json["anbar_date"] == null
            ? null
            : DateTime.parse(json["anbar_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        commodities: json["commodities"] == null
            ? []
            : List<Commodity>.from(
                json["commodities"]!.map((x) => Commodity.fromJson(x))),
        managerSelect: json["manager_select"],
        description: json["description"],
        isAccept: json["is_accept"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        anbarAccept: json["anbar_accept"],
        user: json["user"] == null ? null : SernderClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accept_date": acceptDate?.toIso8601String(),
        "anbar_date": anbarDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "commodities": commodities == null
            ? []
            : List<dynamic>.from(commodities!.map((x) => x.toJson())),
        "manager_select": managerSelect,
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

class SernderClass {
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

  SernderClass({
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

  factory SernderClass.fromJson(Map<String, dynamic> json) => SernderClass(
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
        adminAccess: json["admin_access"] == null
            ? []
            : List<int>.from(json["admin_access"]!.map((x) => x)),
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
        "admin_access": adminAccess == null
            ? []
            : List<dynamic>.from(adminAccess!.map((x) => x)),
      };
}

class Food {
  int? id;
  DateTime? foodDate;
  DateTime? createAt;
  DateTime? updateAt;
  String? lunchSelect;
  String? managerSelect;
  bool? isAccept;
  String? description;
  bool? managerAccept;
  bool? salonAccept;
  SernderClass? user;

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
        foodDate: json["food_date"] == null
            ? null
            : DateTime.parse(json["food_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        lunchSelect: json["lunch_select"],
        managerSelect: json["manager_select"],
        isAccept: json["is_accept"],
        description: json["description"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        user: json["user"] == null ? null : SernderClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "food_date": foodDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "lunch_select": lunchSelect,
        "manager_select": managerSelect,
        "is_accept": isAccept,
        "description": description,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "user": user?.toJson(),
      };
}

class Guard {
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
  SernderClass? user;

  Guard({
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

  factory Guard.fromJson(Map<String, dynamic> json) => Guard(
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
        user: json["user"] == null ? null : SernderClass.fromJson(json["user"]),
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
  bool? isReject;
  String? clockStartTime;
  String? clockEndTime;
  String? description;
  String? allDate;
  bool? managerAccept;
  bool? salonAccept;
  bool? finalAccept;
  SernderClass? user;

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
    this.isReject,
    this.clockStartTime,
    this.clockEndTime,
    this.description,
    this.allDate,
    this.managerAccept,
    this.salonAccept,
    this.finalAccept,
    this.user,
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
        isReject: json["is_reject"],
        clockStartTime: json["clock_start_time"],
        clockEndTime: json["clock_end_time"],
        description: json["description"],
        allDate: json["all_date"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        finalAccept: json["final_accept"],
        user: json["user"] == null ? null : SernderClass.fromJson(json["user"]),
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
        "is_reject": isReject,
        "clock_start_time": clockStartTime,
        "clock_end_time": clockEndTime,
        "description": description,
        "all_date": allDate,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "final_accept": finalAccept,
        "user": user?.toJson(),
      };
}

class Loan {
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
  LoanUser? user;

  Loan({
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

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
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
        description: json["description"],
        user: json["user"] == null ? null : LoanUser.fromJson(json["user"]),
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

class LoanUser {
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
  List<Access>? adminAccess;

  LoanUser({
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

  factory LoanUser.fromJson(Map<String, dynamic> json) => LoanUser(
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
        adminAccess: json["admin_access"] == null
            ? []
            : List<Access>.from(
                json["admin_access"]!.map((x) => Access.fromJson(x))),
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
        "admin_access": adminAccess == null
            ? []
            : List<dynamic>.from(adminAccess!.map((x) => x.toJson())),
      };
}

class Access {
  int? id;
  String? name;
  String? tag;
  String? icon;

  Access({
    this.id,
    this.name,
    this.tag,
    this.icon,
  });

  factory Access.fromJson(Map<String, dynamic> json) => Access(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
        tag: json["tag"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
        "icon": icon,
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

class Overtime {
  int? id;
  DateTime? overtimeDate;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isAccept;
  String? select;
  String? startTime;
  String? endTime;
  String? description;
  bool? managerAccept;
  bool? salonAccept;
  SernderClass? user;

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
        overtimeDate: json["overtime_date"] == null
            ? null
            : DateTime.parse(json["overtime_date"]),
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        isAccept: json["is_accept"],
        select: json["select"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        description: json["description"],
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        user: json["user"] == null ? null : SernderClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "overtime_date": overtimeDate?.toIso8601String(),
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
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

class Shop {
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
  LoanUser? user;

  Shop({
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

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
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
        description: json["description"],
        type: json["type"],
        managerAccept: json["manager_accept"],
        anbarAccept: json["anbar_accept"],
        bazarganiAccept: json["bazargani_accept"],
        isShop: json["is_shop"],
        bazarganiDate: json["bazargani_date"] == null
            ? null
            : DateTime.parse(json["bazargani_date"]),
        user: json["user"] == null ? null : LoanUser.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "manager_date": managerDate?.toIso8601String(),
        "anbar_date": anbarDate?.toIso8601String(),
        "shop_date": shopDate?.toIso8601String(),
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
        "bazargani_date": bazarganiDate?.toIso8601String(),
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

class UserElement {
  int? id;
  DateTime? senderDate;
  DateTime? acceptDate;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isCheck;
  bool? isAccept;
  bool? isRead;
  SernderClass? user;
  SernderClass? sernder;

  UserElement({
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

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
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
        user: json["user"] == null ? null : SernderClass.fromJson(json["user"]),
        sernder: json["sernder"] == null
            ? null
            : SernderClass.fromJson(json["sernder"]),
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

class Work {
  int? id;
  DateTime? createAt;
  DateTime? updateAt;
  bool? isAccept;
  SernderClass? managerUser;
  SernderClass? user;

  Work({
    this.id,
    this.createAt,
    this.updateAt,
    this.isAccept,
    this.managerUser,
    this.user,
  });

  factory Work.fromJson(Map<String, dynamic> json) => Work(
        id: json["id"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        isAccept: json["is_accept"],
        managerUser: json["manager_user"] == null
            ? null
            : SernderClass.fromJson(json["manager_user"]),
        user: json["user"] == null ? null : SernderClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "is_accept": isAccept,
        "manager_user": managerUser?.toJson(),
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
