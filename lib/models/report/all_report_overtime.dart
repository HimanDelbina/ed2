// models/overtime_summary.dart
import 'dart:convert';

OvertimeSummary allReportModelFromJson(String str) =>
    OvertimeSummary.fromJson(json.decode(str));

class OvertimeSummary {
  final int grandTotalOvertime;
  final double grandTotalHours;
  final List<MonthData> months;

  OvertimeSummary({
    required this.grandTotalOvertime,
    required this.grandTotalHours,
    required this.months,
  });

  factory OvertimeSummary.fromJson(Map<String, dynamic> json) {
    return OvertimeSummary(
      grandTotalOvertime: json['grand_total_overtime'],
      grandTotalHours: (json['grand_total_hours'] as num).toDouble(),
      months: (json['months'] as List)
          .map((month) => MonthData.fromJson(month))
          .toList(),
    );
  }
}

class MonthData {
  final String month;
  final int totalOvertime;
  final double totalHours;
  final List<UserData> byUser;
  final List<UnitData> byUnit;

  MonthData({
    required this.month,
    required this.totalOvertime,
    required this.totalHours,
    required this.byUser,
    required this.byUnit,
  });

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      month: json['month'],
      totalOvertime: json['total_overtime'],
      totalHours: (json['total_hours'] as num).toDouble(),
      byUser: (json['by_user'] as List)
          .map((user) => UserData.fromJson(user))
          .toList(),
      byUnit: (json['by_unit'] as List)
          .map((unit) => UnitData.fromJson(unit))
          .toList(),
    );
  }
}

class UserData {
  final String name;
  final int overtimeCount;
  final double totalHours;

  UserData({
    required this.name,
    required this.overtimeCount,
    required this.totalHours,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: utf8.decode(json['name'].codeUnits),
      overtimeCount: json['overtime_count'],
      totalHours: (json['total_hours'] as num).toDouble(),
    );
  }
}

class UnitData {
  final String unit;
  final int overtimeCount;
  final double totalHours;

  UnitData({
    required this.unit,
    required this.overtimeCount,
    required this.totalHours,
  });

  factory UnitData.fromJson(Map<String, dynamic> json) {
    return UnitData(
      unit: utf8.decode(json['unit'].codeUnits),
      overtimeCount: json['overtime_count'],
      totalHours: (json['total_hours'] as num).toDouble(),
    );
  }
}
