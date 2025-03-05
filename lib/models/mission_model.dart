import 'dart:convert';

MissionModel missionModelFromJson(String str) =>
    MissionModel.fromJson(json.decode(str));

String missionModelToJson(MissionModel data) => json.encode(data.toJson());

class MissionModel {
  List<MissionEntry>? missionEntries;
  double? sumData;

  MissionModel({
    this.missionEntries,
    this.sumData,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) => MissionModel(
        missionEntries: json["mission_entries"] == null
            ? []
            : List<MissionEntry>.from(
                json["mission_entries"]!.map((x) => MissionEntry.fromJson(x))),
        sumData: json["sum_data"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "mission_entries": missionEntries == null
            ? []
            : List<dynamic>.from(missionEntries!.map((x) => x.toJson())),
        "sum_data": sumData,
      };
}

class MissionEntry {
  int? id;
  bool? isAccept;
  DateTime? missionDate;
  String? missionStartTime;
  String? missionEndTime;
  String? description;
  DateTime? createAt;
  DateTime? updateAt;
  int? user;
  double? finalTime;

  MissionEntry({
    this.id,
    this.isAccept,
    this.missionDate,
    this.missionStartTime,
    this.missionEndTime,
    this.description,
    this.createAt,
    this.updateAt,
    this.user,
    this.finalTime,
  });

  factory MissionEntry.fromJson(Map<String, dynamic> json) => MissionEntry(
        id: json["id"],
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
        user: json["user"],
        finalTime: json["final_time"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_accept": isAccept,
        "mission_date": missionDate?.toIso8601String(),
        "mission_start_time": missionStartTime,
        "mission_end_time": missionEndTime,
        "description": description,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "user": user,
        "final_time": finalTime,
      };
}
