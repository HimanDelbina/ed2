// To parse this JSON data, do
//
//     final historyReportSwapMpdel = historyReportSwapMpdelFromJson(jsonString);

import 'dart:convert';

List<HistoryReportSwapMpdel> historyReportSwapMpdelFromJson(String str) => List<HistoryReportSwapMpdel>.from(json.decode(str).map((x) => HistoryReportSwapMpdel.fromJson(x)));

String historyReportSwapMpdelToJson(List<HistoryReportSwapMpdel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HistoryReportSwapMpdel {
    int? id;
    String? swappedAt;
    Sender? user;
    Shift? previousShift;
    Shift? newShift;
    Sender? sender;
    String? swapSummary;
    Tag? tag;

    HistoryReportSwapMpdel({
        this.id,
        this.swappedAt,
        this.user,
        this.previousShift,
        this.newShift,
        this.sender,
        this.swapSummary,
        this.tag,
    });

    factory HistoryReportSwapMpdel.fromJson(Map<String, dynamic> json) => HistoryReportSwapMpdel(
        id: json["id"],
        swappedAt: json["swapped_at"],
        user: json["user"] == null ? null : Sender.fromJson(json["user"]),
        previousShift: json["previous_shift"] == null ? null : Shift.fromJson(json["previous_shift"]),
        newShift: json["new_shift"] == null ? null : Shift.fromJson(json["new_shift"]),
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
        lastName:utf8.decode( json["last_name"].codeUnits),
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
