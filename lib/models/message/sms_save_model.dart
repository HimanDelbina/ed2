import 'dart:convert';

List<SmsDefaultModel> smsDefaultModelFromJson(String str) =>
    List<SmsDefaultModel>.from(
        json.decode(str).map((x) => SmsDefaultModel.fromJson(x)));

String smsDefaultModelToJson(List<SmsDefaultModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SmsDefaultModel {
  int? id;
  String? content;

  SmsDefaultModel({
    this.id,
    this.content,
  });

  factory SmsDefaultModel.fromJson(Map<String, dynamic> json) =>
      SmsDefaultModel(
        id: json["id"],
        content: utf8.decode(json["content"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
      };
}
