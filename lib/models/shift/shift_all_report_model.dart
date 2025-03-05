import 'dart:convert';

class ShiftType {
  final String shiftType;
  final String shiftTypeName;
  final int totalShifts;
  final int approvedShifts;

  ShiftType({
    required this.shiftType,
    required this.shiftTypeName,
    required this.totalShifts,
    required this.approvedShifts,
  });

  factory ShiftType.fromJson(Map<String, dynamic> json) {
    return ShiftType(
      shiftType: json['shift_type'],
      shiftTypeName: utf8.decode(json['shift_type_name'].codeUnits),
      totalShifts: json['total_shifts'],
      approvedShifts: json['approved_shifts'],
    );
  }
}

class ShiftReport {
  final int month;
  final List<ShiftType> shiftTypes;
  final int totalShiftsInMonth;
  final int approvedShiftsInMonth;

  ShiftReport({
    required this.month,
    required this.shiftTypes,
    required this.totalShiftsInMonth,
    required this.approvedShiftsInMonth,
  });

  factory ShiftReport.fromJson(Map<String, dynamic> json) {
    var list = json['shift_types'] as List;
    List<ShiftType> shiftTypesList =
        list.map((i) => ShiftType.fromJson(i)).toList();

    return ShiftReport(
      month: json['month'],
      shiftTypes: shiftTypesList,
      totalShiftsInMonth: json['total_shifts_in_month'],
      approvedShiftsInMonth: json['approved_shifts_in_month'],
    );
  }
}
