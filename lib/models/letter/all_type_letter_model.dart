import 'dart:convert';

List<AllTypeLetterModel> allTypeLetterModelFromJson(String str) =>
    List<AllTypeLetterModel>.from(
        json.decode(str).map((x) => AllTypeLetterModel.fromJson(x)));

String allTypeLetterModelToJson(List<AllTypeLetterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllTypeLetterModel {
  int? id;
  String? title;

  AllTypeLetterModel({
    this.id,
    this.title,
  });

  factory AllTypeLetterModel.fromJson(Map<String, dynamic> json) =>
      AllTypeLetterModel(
        id: json["id"],
        title: utf8.decode(json["title"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
