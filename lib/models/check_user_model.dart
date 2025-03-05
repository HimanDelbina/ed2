import 'dart:convert';

CheckUserModel checkUserModelFromJson(String str) =>
    CheckUserModel.fromJson(json.decode(str));

String checkUserModelToJson(CheckUserModel data) => json.encode(data.toJson());

class CheckUserModel {
  bool? isActive;

  CheckUserModel({
    this.isActive,
  });

  factory CheckUserModel.fromJson(Map<String, dynamic> json) => CheckUserModel(
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
      };
}
