import 'dart:convert';

CountAnbarAllModel countAnbarAllModelFromJson(String str) =>
    CountAnbarAllModel.fromJson(json.decode(str));

String countAnbarAllModelToJson(CountAnbarAllModel data) =>
    json.encode(data.toJson());

class CountAnbarAllModel {
  int? anbarCount;

  CountAnbarAllModel({
    this.anbarCount,
  });

  factory CountAnbarAllModel.fromJson(Map<String, dynamic> json) =>
      CountAnbarAllModel(
        anbarCount: json["anbar_count"],
      );

  Map<String, dynamic> toJson() => {
        "anbar_count": anbarCount,
      };
}
