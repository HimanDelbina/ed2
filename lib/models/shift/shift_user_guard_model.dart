import 'dart:convert';

List<ShiftUserGuardMpdel> shiftUserGuardMpdelFromJson(String str) => List<ShiftUserGuardMpdel>.from(json.decode(str).map((x) => ShiftUserGuardMpdel.fromJson(x)));

String shiftUserGuardMpdelToJson(List<ShiftUserGuardMpdel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShiftUserGuardMpdel {
    DateTime? shiftDate;
    String? daysSelect;
    bool? isCheck;
    int? shiftCount;
    User? user;

    ShiftUserGuardMpdel({
        this.shiftDate,
        this.daysSelect,
        this.isCheck,
        this.shiftCount,
        this.user,
    });

    factory ShiftUserGuardMpdel.fromJson(Map<String, dynamic> json) => ShiftUserGuardMpdel(
        shiftDate: json["shift_date"] == null ? null : DateTime.parse(json["shift_date"]),
        daysSelect: json["days_select"],
        isCheck: json["is_check"],
        shiftCount: json["shift_count"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "shift_date": shiftDate?.toIso8601String(),
        "days_select": daysSelect,
        "is_check": isCheck,
        "shift_count": shiftCount,
        "user": user?.toJson(),
    };
}

class User {
    String? firstName;
    String? lastName;
    String? phoneNumber;
    String? companyCode;

    User({
        this.firstName,
        this.lastName,
        this.phoneNumber,
        this.companyCode,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: utf8.decode(json["first_name"].codeUnits),
        lastName: utf8.decode(json["last_name"].codeUnits),
        phoneNumber: json["phone_number"],
        companyCode: json["company_code"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "company_code": companyCode,
    };
}
