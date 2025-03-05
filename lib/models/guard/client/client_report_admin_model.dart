import 'dart:convert';

List<ClientReportAdminMidel> clientReportAdminMidelFromJson(String str) =>
    List<ClientReportAdminMidel>.from(
        json.decode(str).map((x) => ClientReportAdminMidel.fromJson(x)));

String clientReportAdminMidelToJson(List<ClientReportAdminMidel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClientReportAdminMidel {
  String? typeWork;
  String? unit;
  String? carPlate;
  String? name;
  String? phoneNumber;
  DateTime? clientLogin;
  dynamic clientExit;
  bool? adminAccept;
  bool? adminReject;
  DateTime? createAt;
  DateTime? updateAt;
  String? timeDifference;

  ClientReportAdminMidel({
    this.typeWork,
    this.unit,
    this.carPlate,
    this.name,
    this.phoneNumber,
    this.clientLogin,
    this.clientExit,
    this.adminAccept,
    this.adminReject,
    this.createAt,
    this.updateAt,
    this.timeDifference,
  });

  factory ClientReportAdminMidel.fromJson(Map<String, dynamic> json) =>
      ClientReportAdminMidel(
        typeWork: json["type_work"],
        unit: json["unit"],
        carPlate: utf8.decode(json["car_plate"].codeUnits),
        name: utf8.decode(json["name"].codeUnits),
        phoneNumber: json["phone_number"],
        clientLogin: json["client_login"] == null
            ? null
            : DateTime.parse(json["client_login"]),
        clientExit: json["client_exit"],
        adminAccept: json["admin_accept"],
        adminReject: json["admin_reject"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        updateAt: json["update_at"] == null
            ? null
            : DateTime.parse(json["update_at"]),
        timeDifference: utf8.decode(json["time_difference"].codeUnits),
      );

  Map<String, dynamic> toJson() => {
        "type_work": typeWork,
        "unit": unit,
        "car_plate": carPlate,
        "name": name,
        "phone_number": phoneNumber,
        "client_login": clientLogin?.toIso8601String(),
        "client_exit": clientExit,
        "admin_accept": adminAccept,
        "admin_reject": adminReject,
        "create_at": createAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "time_difference": timeDifference,
      };
}
