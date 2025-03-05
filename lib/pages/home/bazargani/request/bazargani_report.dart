import 'dart:convert';

import 'package:ed/models/bazargani/bazargani_shop_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../../../../static/helper_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class BazarganiReportPage extends StatefulWidget {
  const BazarganiReportPage({super.key});

  @override
  State<BazarganiReportPage> createState() => _BazarganiReportPageState();
}

class _BazarganiReportPageState extends State<BazarganiReportPage> {
  @override
  void initState() {
    bazarganiGetShop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: isGetData == false
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
          : data.isEmpty
              ? const Center(child: Text("داده ای وجود ندارد"))
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5))),
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "تاریخ درخواست : ${FormateDateCreateChange.formatDate(data[index].createAt.toString())}"),
                          data[index].shopData.isNotEmpty
                              ? Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data[index].shopData.length,
                                    itemBuilder: (context, commodityIndex) {
                                      var data_show =
                                          data[index].shopData[commodityIndex];
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
                                  ),
                                )
                              : const Row(children: [
                                  Text('هیچ کالایی برای نمایش وجود ندارد'),
                                ]),
                          const Divider(color: Colors.blue),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                                "درخواست شما دارای ${4.toString().toPersianDigit()} مرحله تاییدیه میباشد ."),
                          ),
                          check_accept(
                              data[index].anbarAccept,
                              "${1.toString().toPersianDigit()} - تاییدیه مدیر انبار ",
                              FormateDateCreate.formatDate(
                                  data[index].anbarDate.toString())),
                          check_accept(
                              data[index].managerAccept,
                              "${2.toString().toPersianDigit()} - تاییدیه مدیر اصلی ",
                              FormateDateCreate.formatDate(
                                  data[index].managerDate.toString())),
                          check_accept(
                              data[index].bazarganiAccept,
                              "${3.toString().toPersianDigit()} - تاییدیه مدیر بازرگانی ",
                              FormateDateCreate.formatDate(
                                  data[index].bazarganiDate.toString())),
                          check_accept(
                              data[index].isShop,
                              "${4.toString().toPersianDigit()} - خرید ",
                              FormateDateCreate.formatDate(
                                  data[index].shopDate.toString())),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                shopID = data[index].id;
                              });
                              finalShop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              child: const Center(
                                child: Text(
                                  "تایید خرید",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
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

  List data = [];
  bool? isGetData = false;
  Future<void> bazarganiGetShop() async {
    String infourl =
        Helper.url.toString() + 'anbar/get_shop_by_bazargani_report';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = bazarganiShopModelFromJson(x);
      setState(() {
        data = recive_data;
        isGetData = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  int? shopID;
  Future finalShop() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";

    var body = jsonEncode({"is_shop": true, "shop_date": dateTimeString});
    String infourl = Helper.url.toString() + 'anbar/edit_shop_admin/${shopID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      bazarganiGetShop();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
