import 'dart:convert';

List<GharardadSmallModel> gharardadSmallModelFromJson(String str) =>
    List<GharardadSmallModel>.from(
        json.decode(str).map((x) => GharardadSmallModel.fromJson(x)));

String gharardadSmallModelToJson(List<GharardadSmallModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GharardadSmallModel {
  String? userName;
  String? money;
  int? id;
  int? remainingDays;
  bool? isFinish;
  bool? isFinishWork;
  DateTime? endDate;
  DateTime? startDate;

  GharardadSmallModel({
    this.userName,
    this.money,
    this.id,
    this.remainingDays,
    this.isFinish,
    this.isFinishWork,
    this.endDate,
    this.startDate,
  });

  factory GharardadSmallModel.fromJson(Map<String, dynamic> json) =>
      GharardadSmallModel(
        id: json["id"],
        userName: utf8.decode(json["user_name"].codeUnits),
        remainingDays: json["remaining_days"],
        money: json["money"],
        isFinish: json["is_finish"],
        isFinishWork: json["is_finish_work"],
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "remaining_days": remainingDays,
        "money": money,
        "is_finish": isFinish,
        "is_finish_work": isFinishWork,
        "end_date": endDate?.toIso8601String(),
        "start_date": startDate?.toIso8601String(),
      };
}
