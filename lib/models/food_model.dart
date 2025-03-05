// To parse this JSON data, do
//
//     final foodModel = foodModelFromJson(jsonString);

import 'dart:convert';

List<FoodModel> foodModelFromJson(String str) => List<FoodModel>.from(json.decode(str).map((x) => FoodModel.fromJson(x)));

String foodModelToJson(List<FoodModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodModel {
    int? id;
    String? foodDate;
    String? createAt;
    String? updateAt;
    String? lunchSelect;
    String? managerSelect;
    bool? isAccept;
    String? description;
    bool? managerAccept;
    bool? salonAccept;
    int? user;

    FoodModel({
        this.id,
        this.foodDate,
        this.createAt,
        this.updateAt,
        this.lunchSelect,
        this.managerSelect,
        this.isAccept,
        this.description,
        this.managerAccept,
        this.salonAccept,
        this.user,
    });

    factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json["id"],
        foodDate: json["food_date"],
        createAt: json["create_at"],
        updateAt: json["update_at"],
        lunchSelect: json["lunch_select"],
        managerSelect: json["manager_select"],
        isAccept: json["is_accept"],
        description: utf8.decode(json["description"].codeUnits),
        managerAccept: json["manager_accept"],
        salonAccept: json["salon_accept"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "food_date": foodDate,
        "create_at": createAt,
        "update_at": updateAt,
        "lunch_select": lunchSelect,
        "manager_select": managerSelect,
        "is_accept": isAccept,
        "description": description,
        "manager_accept": managerAccept,
        "salon_accept": salonAccept,
        "user": user,
    };
}
