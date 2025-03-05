import 'dart:convert';

List<AnbarReportAllModel> anbarReportAllModelFromJson(String str) =>
    List<AnbarReportAllModel>.from(
        json.decode(str).map((x) => AnbarReportAllModel.fromJson(x)));

String anbarReportAllModelToJson(List<AnbarReportAllModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AnbarReportAllModel {
  String? userUnitName;
  int? totalRequests;
  int? acceptedRequests;
  int? rejectedRequests;

  AnbarReportAllModel({
    this.userUnitName,
    this.totalRequests,
    this.acceptedRequests,
    this.rejectedRequests,
  });

  factory AnbarReportAllModel.fromJson(Map<String, dynamic> json) =>
      AnbarReportAllModel(
        userUnitName: utf8.decode(json["user__unit__name"].codeUnits),
        totalRequests: json["total_requests"],
        acceptedRequests: json["accepted_requests"],
        rejectedRequests: json["rejected_requests"],
      );

  Map<String, dynamic> toJson() => {
        "user__unit__name": userUnitName,
        "total_requests": totalRequests,
        "accepted_requests": acceptedRequests,
        "rejected_requests": rejectedRequests,
      };
}
