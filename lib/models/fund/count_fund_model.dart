import 'dart:convert';

CountFundModel countFundModelFromJson(String str) =>
    CountFundModel.fromJson(json.decode(str));

String countFundModelToJson(CountFundModel data) => json.encode(data.toJson());

class CountFundModel {
  int? loanCount;
  int? fundCount;
  int? shopCount;
  int? userCount;
  int? sumCount;

  CountFundModel({
    this.loanCount,
    this.fundCount,
    this.shopCount,
    this.userCount,
    this.sumCount,
  });

  factory CountFundModel.fromJson(Map<String, dynamic> json) => CountFundModel(
        loanCount: json["loan_count"],
        fundCount: json["fund_count"],
        shopCount: json["shop_count"],
        userCount: json["user_count"],
        sumCount: json["sum_count"],
      );

  Map<String, dynamic> toJson() => {
        "loan_count": loanCount,
        "fund_count": fundCount,
        "shop_count": shopCount,
        "user_count": userCount,
        "sum_count": sumCount,
      };
}
