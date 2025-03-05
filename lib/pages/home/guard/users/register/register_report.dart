import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/guard/client/client_model.dart';
import '../../../../../static/helper_page.dart';

class GuardRegisterReportPage extends StatefulWidget {
  const GuardRegisterReportPage({super.key});

  @override
  State<GuardRegisterReportPage> createState() =>
      _GuardRegisterReportPageState();
}

class _GuardRegisterReportPageState extends State<GuardRegisterReportPage> {
  @override
  void initState() {
    super.initState();
    get_all_client();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data == false
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
                          vertical: 10.0, horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("درخواست ورود به شرکت"),
                              Text(
                                FormateDateCreate.formatDate(
                                    data![index].createAt.toString()),
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data![index].name),
                              Text(
                                  "شماره موبایل : ${data![index].phoneNumber.toString().toPersianDigit()}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "نوع کار : ${data![index].typeWork == "P" ? "پیمان کار" : data![index].typeWork == "N" ? "نصاب" : data![index].typeWork == "K" ? "خدماتی" : data![index].typeWork == "G" ? "غیره" : ""}"),
                              Text(
                                  "ساعت مراجعه : ${FormatTimeCreate.formatTime(data![index].createAt.toString().toPersianDigit())}")
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data![index].adminAccept == false &&
                                        data![index].adminReject == false
                                    ? "لطفا منتظر تایید باشید"
                                    : data![index].adminAccept
                                        ? "ورود تایید شد"
                                        : data![index].adminReject
                                            ? "متاسفانه ورود تایید نشد"
                                            : "",
                                style: TextStyle(
                                    color: data![index].adminAccept == false &&
                                            data![index].adminReject == false
                                        ? Colors.blue
                                        : data![index].adminAccept
                                            ? Colors.green
                                            : data![index].adminReject
                                                ? Colors.red
                                                : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              data![index].clientLogin == null
                                  ? const SizedBox()
                                  : Text(
                                      "تاریخ : ${FormateDateCreateLeft.formatDate(data![index].clientLogin)} ساعت : ${FormatTimeCreate.formatTime(data![index].clientLogin.toString().toPersianDigit())}"),
                              data![index].adminAccept
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          select_report = data![index].id;
                                        });
                                        edit_report();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: const Center(
                                            child: Text(
                                          "خروج",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  Future get_all_client() async {
    String infourl = Helper.url.toString() + 'guard/get_guard_report_client';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = clientModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  int? select_report;
  Future edit_report() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "client_exit": dateTimeString,
    });
    print(body);
    String infourl = Helper.url.toString() +
        'guard/edit_client/${select_report.toString()}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "خروج با موفقیت ثبت شد", 1);
      get_all_client();
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
