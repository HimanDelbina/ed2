import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/pages/home/admin_page/check_page/request/Shop/admin_editshop.dart';
import '../../../../../../models/shop/shop_report_model.dart';
import '../../../../../../static/helper_page.dart';

class AdminShopPage extends StatefulWidget {
  const AdminShopPage({super.key});

  @override
  State<AdminShopPage> createState() => _AdminShopPageState();
}

class _AdminShopPageState extends State<AdminShopPage> {
  @override
  void initState() {
    get_shop_admin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data
          ? data != null && data!.isNotEmpty
              ? ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return shop_show(data![index]);
                  },
                )
              : const Center(child: Text("داده ای وجود ندارد"))
          : Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0)),
    );
  }

  Widget shop_show(var data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              "درخواست خرید کالا",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "درخواست کننده : ${data.user.firstName} ${data.user.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${FormateDateCreate.formatDate(data.createAt!.toString())}",
                style: const TextStyle(color: Colors.blue),
              )
            ],
          ),
          const Divider(),
          data.shopData != null && data.shopData.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.shopData.length,
                    itemBuilder: (context, commodityIndex) {
                      var commodity = data.shopData[commodityIndex];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${(commodityIndex + 1).toString().toPersianDigit()} : ${commodity.name}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "تعداد : ${commodity.count.toString().toPersianDigit()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            anbar_id = data.id;
                          });
                          accept_shop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: const Center(
                            child: Text(
                              "تایید",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          anbar_id = data.id;
                        });
                        reject_shop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: const Center(
                          child: Text(
                            "لغو",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminEditShopPage(
                                  data: data.shopData,
                                  anbar_id: data.id,
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "ویرایش",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List? data = [];
  bool is_get_data = false;

  Future get_shop_admin() async {
    String infourl = Helper.url.toString() + 'anbar/get_shop_by_admin';
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

  int? anbar_id;
  Future edit_shop() async {
    var body = jsonEncode({"is_finish_work": true});
    String infourl =
        Helper.url.toString() + 'anbar/edit_shop_admin/${anbar_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_shop_admin();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();

  Future accept_shop() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body =
        jsonEncode({"manager_accept": true, "manager_date": dateTimeString});
    String infourl =
        Helper.url.toString() + 'anbar/edit_shop_admin/${anbar_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_shop_admin();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_shop() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body =
        jsonEncode({"manager_accept": false, "manager_date": dateTimeString});
    String infourl =
        Helper.url.toString() + 'anbar/edit_shop_admin/${anbar_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_shop_admin();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
