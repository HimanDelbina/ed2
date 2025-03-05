// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) =>
    UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) =>
    json.encode(data.toJson());

class UserDetailsModel {
  Contracts? contracts;
  List<Fund>? funds;
  List<ShiftElement>? shift;
  LatestChangeshift? latestChangeshift;
  Overtime? overtime;
  List<TodayOvertime>? todayOvertime;
  Leave? leave;
  List<TodayLeave>? todayLeave;
  Loan? loan;
  Salary? salary;
  List<TodayFood>? todayFood;

  UserDetailsModel({
    this.contracts,
    this.funds,
    this.shift,
    this.latestChangeshift,
    this.overtime,
    this.todayOvertime,
    this.leave,
    this.todayLeave,
    this.loan,
    this.salary,
    this.todayFood,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        contracts: json["contracts"] == null
            ? null
            : Contracts.fromJson(json["contracts"]),
        funds: json["funds"] == null
            ? []
            : List<Fund>.from(json["funds"]!.map((x) => Fund.fromJson(x))),
        shift: json["shift"] == null
            ? []
            : List<ShiftElement>.from(
                json["shift"]!.map((x) => ShiftElement.fromJson(x))),
        latestChangeshift: json["latest_changeshift"] == null
            ? null
            : LatestChangeshift.fromJson(json["latest_changeshift"]),
        overtime: json["overtime"] == null
            ? null
            : Overtime.fromJson(json["overtime"]),
        todayOvertime: json["today_overtime"] == null
            ? []
            : List<TodayOvertime>.from(
                json["today_overtime"]!.map((x) => TodayOvertime.fromJson(x))),
        leave: json["leave"] == null ? null : Leave.fromJson(json["leave"]),
        todayLeave: json["today_leave"] == null
            ? []
            : List<TodayLeave>.from(
                json["today_leave"]!.map((x) => TodayLeave.fromJson(x))),
        loan: json["loan"] == null ? null : Loan.fromJson(json["loan"]),
        salary: json["salary"] == null ? null : Salary.fromJson(json["salary"]),
        todayFood: json["today_food"] == null
            ? []
            : List<TodayFood>.from(
                json["today_food"]!.map((x) => TodayFood.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contracts": contracts?.toJson(),
        "funds": funds == null
            ? []
            : List<dynamic>.from(funds!.map((x) => x.toJson())),
        "shift": shift == null
            ? []
            : List<dynamic>.from(shift!.map((x) => x.toJson())),
        "latest_changeshift": latestChangeshift?.toJson(),
        "overtime": overtime?.toJson(),
        "today_overtime": todayOvertime == null
            ? []
            : List<dynamic>.from(todayOvertime!.map((x) => x.toJson())),
        "leave": leave?.toJson(),
        "today_leave": todayLeave == null
            ? []
            : List<dynamic>.from(todayLeave!.map((x) => x.toJson())),
        "loan": loan?.toJson(),
        "salary": salary?.toJson(),
        "today_food": todayFood == null
            ? []
            : List<dynamic>.from(todayFood!.map((x) => x.toJson())),
      };
}

class Contracts {
  int? id;
  DateTime? startDate;
  DateTime? endDate;
  String? money;
  bool? isFinish;
  bool? isFinishWork;
  int? user;

  Contracts({
    this.id,
    this.startDate,
    this.endDate,
    this.money,
    this.isFinish,
    this.isFinishWork,
    this.user,
  });

  factory Contracts.fromJson(Map<String, dynamic> json) => Contracts(
        id: json["id"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        money: json["money"],
        isFinish: json["is_finish"],
        isFinishWork: json["is_finish_work"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "money": money,
        "is_finish": isFinish,
        "is_finish_work": isFinishWork,
        "user": user,
      };
}

class Fund {
  String? allMoney;
  String? money;

  Fund({
    this.allMoney,
    this.money,
  });

  factory Fund.fromJson(Map<String, dynamic> json) => Fund(
        allMoney: json["all_money"],
        money: json["money"],
      );

  Map<String, dynamic> toJson() => {
        "all_money": allMoney,
        "money": money,
      };
}

class LatestChangeshift {
  int? id;
  String? swappedAt;
  Sender? user;
  Shift? previousShift;
  Shift? newShift;
  Sender? sender;
  String? swapSummary;
  Tag? tag;

  LatestChangeshift({
    this.id,
    this.swappedAt,
    this.user,
    this.previousShift,
    this.newShift,
    this.sender,
    this.swapSummary,
    this.tag,
  });

  factory LatestChangeshift.fromJson(Map<String, dynamic> json) =>
      LatestChangeshift(
        id: json["id"],
        swappedAt: json["swapped_at"],
        user: json["user"] == null ? null : Sender.fromJson(json["user"]),
        previousShift: json["previous_shift"] == null
            ? null
            : Shift.fromJson(json["previous_shift"]),
        newShift: json["new_shift"] == null
            ? null
            : Shift.fromJson(json["new_shift"]),
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
        swapSummary: json["swap_summary"],
        tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "swapped_at": swappedAt,
        "user": user?.toJson(),
        "previous_shift": previousShift?.toJson(),
        "new_shift": newShift?.toJson(),
        "sender": sender?.toJson(),
        "swap_summary": swapSummary,
        "tag": tag?.toJson(),
      };
}

class Shift {
  int? id;
  String? daysSelect;
  String? shiftDate;

  Shift({
    this.id,
    this.daysSelect,
    this.shiftDate,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        daysSelect: json["days_select"],
        shiftDate: json["shift_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "days_select": daysSelect,
        "shift_date": shiftDate,
      };
}

class Sender {
  int? id;
  String? firstName;
  String? lastName;

  Sender({
    this.id,
    this.firstName,
    this.lastName,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"],
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
      };
}

class Tag {
  String? tag;

  Tag({
    this.tag,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
      };
}

class Leave {
  double? leaveClock;
  double? leaveDays;

  Leave({
    this.leaveClock,
    this.leaveDays,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        leaveClock: json["leave_clock"]?.toDouble(),
        leaveDays: json["leave_days"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "leave_clock": leaveClock,
        "leave_days": leaveDays,
      };
}

class Loan {
  String? loanSelect;
  String? moneyRequest;

  Loan({
    this.loanSelect,
    this.moneyRequest,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        loanSelect: json["loan_select"],
        moneyRequest: json["money_request"],
      );

  Map<String, dynamic> toJson() => {
        "loan_select": loanSelect,
        "money_request": moneyRequest,
      };
}

class Overtime {
  List<OvertimeDatum>? overtimeData;
  SumData? sumData;

  Overtime({
    this.overtimeData,
    this.sumData,
  });

  factory Overtime.fromJson(Map<String, dynamic> json) => Overtime(
        overtimeData: json["overtime_data"] == null
            ? []
            : List<OvertimeDatum>.from(
                json["overtime_data"]!.map((x) => OvertimeDatum.fromJson(x))),
        sumData: json["sum_data"] == null
            ? null
            : SumData.fromJson(json["sum_data"]),
      );

  Map<String, dynamic> toJson() => {
        "overtime_data": overtimeData == null
            ? []
            : List<dynamic>.from(overtimeData!.map((x) => x.toJson())),
        "sum_data": sumData?.toJson(),
      };
}

class OvertimeDatum {
  String? select;
  String? startTime;
  String? endTime;
  double? finalTime;

  OvertimeDatum({
    this.select,
    this.startTime,
    this.endTime,
    this.finalTime,
  });

  factory OvertimeDatum.fromJson(Map<String, dynamic> json) => OvertimeDatum(
        select: json["select"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        finalTime: json["final_time"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "select": select,
        "start_time": startTime,
        "end_time": endTime,
        "final_time": finalTime,
      };
}

class SumData {
  double? ez;
  double? go;
  double? ta;
  double? ma;
  double? total;

  SumData({
    this.ez,
    this.go,
    this.ta,
    this.ma,
    this.total,
  });

  factory SumData.fromJson(Map<String, dynamic> json) => SumData(
        ez: json["EZ"]?.toDouble(),
        go: json["GO"]?.toDouble(),
        ta: json["TA"]?.toDouble(),
        ma: json["MA"]?.toDouble(),
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "EZ": ez,
        "GO": go,
        "TA": ta,
        "MA": ma,
        "total": total,
      };
}

class Salary {
  String? month;
  String? year;
  String? khalesPardakhti;

  Salary({
    this.month,
    this.year,
    this.khalesPardakhti,
  });

  factory Salary.fromJson(Map<String, dynamic> json) => Salary(
        month: json["month"],
        year: json["year"],
        khalesPardakhti: json["khales_pardakhti"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "year": year,
        "khales_pardakhti": khalesPardakhti,
      };
}

class ShiftElement {
  String? daysSelect;
  int? shiftCount;
  bool? isCheck;

  ShiftElement({
    this.daysSelect,
    this.shiftCount,
    this.isCheck,
  });

  factory ShiftElement.fromJson(Map<String, dynamic> json) => ShiftElement(
        daysSelect: json["days_select"],
        shiftCount: json["shift_count"],
        isCheck: json["is_check"],
      );

  Map<String, dynamic> toJson() => {
        "days_select": daysSelect,
        "shift_count": shiftCount,
        "is_check": isCheck,
      };
}

class TodayFood {
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
  int? user;

  TodayFood({
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

  factory TodayFood.fromJson(Map<String, dynamic> json) => TodayFood(
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
        user: json["user"],
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
        "user": user,
      };
}

class TodayLeave {
  int? id;
  dynamic clockLeaveDate;
  dynamic daysStartDate;
  dynamic daysEndDate;
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
  int? user;

  TodayLeave({
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

  factory TodayLeave.fromJson(Map<String, dynamic> json) => TodayLeave(
        id: json["id"],
        clockLeaveDate: json["clock_leave_date"],
        daysStartDate: json["days_start_date"],
        daysEndDate: json["days_end_date"],
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
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clock_leave_date": clockLeaveDate,
        "days_start_date": daysStartDate,
        "days_end_date": daysEndDate,
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
        "user": user,
      };
}

class TodayOvertime {
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
  int? user;

  TodayOvertime({
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

  factory TodayOvertime.fromJson(Map<String, dynamic> json) => TodayOvertime(
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
        user: json["user"],
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
        "user": user,
      };
}
