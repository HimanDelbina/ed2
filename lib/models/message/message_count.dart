import 'dart:convert';

CountMessageModel countFundModelFromJson(String str) =>
    CountMessageModel.fromJson(json.decode(str));

String countFundModelToJson(CountMessageModel data) =>
    json.encode(data.toJson());

class CountMessageModel {
  int? count;

  CountMessageModel({this.count});

  factory CountMessageModel.fromJson(Map<String, dynamic> json) =>
      CountMessageModel(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {"count": count};
}
