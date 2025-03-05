import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../models/shop/shop_report_model.dart';
import '../../../static/helper_page.dart';

class ShopReport extends StatefulWidget {
  const ShopReport({super.key});

  @override
  State<ShopReport> createState() => _ShopReportState();
}

class _ShopReportState extends State<ShopReport> {
  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    get_shop_by_user_id();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data! == false
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
          : data!.isEmpty
              ? const Center(child: Text("داده ای وجود ندارد"))
              : ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "تاریخ درخواست : ${FormateDateCreateChange.formatDate(data![index].createAt.toString())}"),
                          data![index].shopData.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data![index].shopData.length,
                                  itemBuilder: (context, commodityIndex) {
                                    var data_show =
                                        data![index].shopData[commodityIndex];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${(commodityIndex + 1).toString().toPersianDigit()} : ${data_show.name}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "تعداد : ${data_show.count.toString().toPersianDigit()}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const Row(children: [
                                  Text('هیچ کالایی برای نمایش وجود ندارد'),
                                ]),
                          Text(data![index].managerAccept
                              ? "درخواست شما توسط مدیر تایید شده و به انبار ارسال شده"
                              : data![index].managerAccept &&
                                      data![index].anbarAccept
                                  ? "درخواست شما توسط مدیر انبار تایید شده و به بازرگانی ارسال شده"
                                  : data![index].managerAccept &&
                                          data![index].anbarAccept &&
                                          data![index].isShop
                                      ? "کالای شما خریداری شده میتوانید به انبار مراجعه کنید"
                                      : "درخواست خرید شما در حال بررسی است لطفا تا پایان مراحل تایید منتظر بمانید."),
                          const Divider(color: Colors.blue),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                                "درخواست شما دارای ${4.toString().toPersianDigit()} مرحله تاییدیه میباشد ."),
                          ),
                          check_accept(
                              data![index].anbarAccept,
                              "${2.toString().toPersianDigit()} - تاییدیه مدیر انبار ",
                              FormateDateCreate.formatDate(
                                  data![index].anbarDate.toString())),
                          check_accept(
                              data![index].managerAccept,
                              "${4.toString().toPersianDigit()} - تاییدیه مدیر اصلی ",
                              FormateDateCreate.formatDate(
                                  data![index].managerDate.toString())),
                          check_accept(
                              data![index].bazarganiAccept,
                              "${3.toString().toPersianDigit()} - تاییدیه مدیر بازرگانی ",
                              FormateDateCreate.formatDate(
                                  data![index].bazarganiDate.toString())),
                          check_accept(
                              data![index].isShop,
                              "${5.toString().toPersianDigit()} - خرید ",
                              FormateDateCreate.formatDate(
                                  data![index].shopDate.toString())),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget check_accept(bool check, String title, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: check ? Colors.green : Colors.red),
        ),
        Row(
          children: [
            check ? Text(date) : const SizedBox(),
            Icon(check ? Icons.check : Icons.clear,
                size: 15.0, color: check ? Colors.green : Colors.red),
          ],
        )
      ],
    );
  }

  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_shop_by_user_id() async {
    String infourl = Helper.url.toString() +
        'anbar/get_shop_by_user_id/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = shopReportMpdelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
      print(data);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
