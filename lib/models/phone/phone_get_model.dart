import 'dart:convert';

List<PhoneModel> phoneModelFromJson(String str) => List<PhoneModel>.from(json.decode(str).map((x) => PhoneModel.fromJson(x)));

String phoneModelToJson(List<PhoneModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhoneModel {
    int? id;
    DateTime? createAt;
    DateTime? updateAt;
    String? name;
    String? phone;
    Company? company;

    PhoneModel({
        this.id,
        this.createAt,
        this.updateAt,
        this.name,
        this.phone,
        this.company,
    });

    factory PhoneModel.fromJson(Map<String, dynamic> json) => PhoneModel(
        id: json["id"],
        createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null ? null : DateTime.parse(json["update_at"]),
        name: utf8.decode(json["name"].codeUnits),
        phone: json["phone"],
        company: json["company"] == null ? null : Company.fromJson(json["company"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "name": name,
        "phone": phone,
        "company": company?.toJson(),
    };
}

class Company {
    int? id;
    String? name;

    Company({
        this.id,
        this.name,
    });

    factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json["id"],
        name: utf8.decode(json["name"].codeUnits),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
