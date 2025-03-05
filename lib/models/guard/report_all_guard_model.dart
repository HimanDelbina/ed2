import 'dart:convert';

ReportAllGuardModel reportAllGuardModelFromJson(String str) =>
    ReportAllGuardModel.fromJson(json.decode(str));

String reportAllGuardModelToJson(ReportAllGuardModel data) =>
    json.encode(data.toJson());

class ReportAllGuardModel {
  PortCommodity? importCommodity;
  PortCommodity? exportCommodity;
  ClientRegister? clientRegister;

  ReportAllGuardModel({
    this.importCommodity,
    this.exportCommodity,
    this.clientRegister,
  });

  factory ReportAllGuardModel.fromJson(Map<String, dynamic> json) =>
      ReportAllGuardModel(
        importCommodity: json["import_commodity"] == null
            ? null
            : PortCommodity.fromJson(json["import_commodity"]),
        exportCommodity: json["export_commodity"] == null
            ? null
            : PortCommodity.fromJson(json["export_commodity"]),
        clientRegister: json["client_register"] == null
            ? null
            : ClientRegister.fromJson(json["client_register"]),
      );

  Map<String, dynamic> toJson() => {
        "import_commodity": importCommodity?.toJson(),
        "export_commodity": exportCommodity?.toJson(),
        "client_register": clientRegister?.toJson(),
      };
}

class ClientRegister {
  int? totalRequests;
  List<ClientRegisterTypeCount>? typeCounts;
  int? approvedCount;
  int? unapprovedCount;

  ClientRegister({
    this.totalRequests,
    this.typeCounts,
    this.approvedCount,
    this.unapprovedCount,
  });

  factory ClientRegister.fromJson(Map<String, dynamic> json) => ClientRegister(
        totalRequests: json["total_requests"],
        typeCounts: json["type_counts"] == null
            ? []
            : List<ClientRegisterTypeCount>.from(json["type_counts"]!
                .map((x) => ClientRegisterTypeCount.fromJson(x))),
        approvedCount: json["approved_count"],
        unapprovedCount: json["unapproved_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_requests": totalRequests,
        "type_counts": typeCounts == null
            ? []
            : List<dynamic>.from(typeCounts!.map((x) => x.toJson())),
        "approved_count": approvedCount,
        "unapproved_count": unapprovedCount,
      };
}

class ClientRegisterTypeCount {
  String? typeWork;
  int? count;

  ClientRegisterTypeCount({
    this.typeWork,
    this.count,
  });

  factory ClientRegisterTypeCount.fromJson(Map<String, dynamic> json) =>
      ClientRegisterTypeCount(
        typeWork: utf8.decode(json["type_work"].codeUnits),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "type_work": typeWork,
        "count": count,
      };
}

class PortCommodity {
  int? totalRequests;
  List<ExportCommodityTypeCount>? typeCounts;
  int? approvedCount;
  int? unapprovedCount;

  PortCommodity({
    this.totalRequests,
    this.typeCounts,
    this.approvedCount,
    this.unapprovedCount,
  });

  factory PortCommodity.fromJson(Map<String, dynamic> json) => PortCommodity(
        totalRequests: json["total_requests"],
        typeCounts: json["type_counts"] == null
            ? []
            : List<ExportCommodityTypeCount>.from(json["type_counts"]!
                .map((x) => ExportCommodityTypeCount.fromJson(x))),
        approvedCount: json["approved_count"],
        unapprovedCount: json["unapproved_count"],
      );

  Map<String, dynamic> toJson() => {
        "total_requests": totalRequests,
        "type_counts": typeCounts == null
            ? []
            : List<dynamic>.from(typeCounts!.map((x) => x.toJson())),
        "approved_count": approvedCount,
        "unapproved_count": unapprovedCount,
      };
}

class ExportCommodityTypeCount {
  String? select;
  int? count;

  ExportCommodityTypeCount({
    this.select,
    this.count,
  });

  factory ExportCommodityTypeCount.fromJson(Map<String, dynamic> json) =>
      ExportCommodityTypeCount(
        select: utf8.decode(json["select"].codeUnits),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "select": select,
        "count": count,
      };
}
