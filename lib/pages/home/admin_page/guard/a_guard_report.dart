import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/guard/client/client_report_admin_model.dart';
import '../../../../static/helper_page.dart';

class AdminGuardReportPage extends StatefulWidget {
  const AdminGuardReportPage({super.key});

  @override
  State<AdminGuardReportPage> createState() => _AdminGuardReportPageState();
}

class _AdminGuardReportPageState extends State<AdminGuardReportPage> {
  @override
  void initState() {
    super.initState();
    accepted_clients_report();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Container(
            width: my_width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    show_filter(
                      "همه",
                      is_all,
                      () {
                        setState(() {
                          is_all = true;
                          is_month = false;
                          is_day = false;
                          is_sh_month = false;
                          current_year = date_now!.year.toString();
                        });
                        accepted_clients_report();
                      },
                    ),
                    show_filter(
                      "امروز",
                      is_day,
                      () {
                        setState(() {
                          is_day = true;
                          is_all = false;
                          is_month = false;
                          is_sh_month = false;
                          current_year = date_now!.year.toString();
                        });
                        accepted_clients_report();
                      },
                    ),
                    show_filter(
                      "این ماه",
                      is_month,
                      () {
                        setState(() {
                          is_all = false;
                          is_day = false;
                          is_month = true;
                          is_sh_month = false;
                          current_month = date_now!.month.toString();
                          current_year = date_now!.year.toString();
                        });
                        accepted_clients_report();
                      },
                    ),
                  ],
                ),
                month_select()
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: is_get_data! == false
                ? Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0))
                : data!.isEmpty
                    ? const Center(child: Text("داده ای وجود ندارد"))
                    : ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: my_width,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.0)),
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data![index].name),
                                    Text(
                                        "واحد مراجعه : ${data![index].unit == "E" ? "اداری" : data![index].unit == "T" ? "تولید" : data![index].unit == "F" ? "فنی" : ""}"),
                                    Text(
                                        "نوع کار : ${data![index].typeWork == "P" ? "پیمان کار" : data![index].typeWork == "N" ? "نصاب" : data![index].typeWork == "K" ? "خدماتی" : data![index].typeWork == "G" ? "غیره" : ""}"),
                                  ],
                                ),
                                const Divider(color: Colors.blue),
                                Text(
                                    "تاریخ درخواست : ${FormateDateCreateLeft.formatDate(data![index].createAt.toString())} ساعت درخواست : ${FormatTimeCreate.formatTime(data![index].createAt.toString().toPersianDigit())}"),
                                Text(
                                    "زمان حضور مراجعه کننده در شرکت : ${data![index].timeDifference.toString().toPersianDigit()}"),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "ساعت ورود : ${FormatTimeCreate.formatTime(data![index].clientLogin.toString().toPersianDigit())}"),
                                    Text(
                                        "ساعت خروج : ${data![index].clientExit == null ? "هنوز خارج نشده" : FormatTimeCreate.formatTime(data![index].clientExit.toString().toPersianDigit())}"),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  String? infourl;
  Future accepted_clients_report() async {
    print(current_year);
    print(current_month);
    if (is_all!) {
      infourl = Helper.url.toString() +
          'guard/accepted_clients_report_filter/?year=${current_year}';
    } else if (is_month!) {
      infourl = Helper.url.toString() +
          'guard/accepted_clients_report_filter/?year=${current_year}&month=${current_month}';
    } else if (is_sh_month!) {
      infourl = Helper.url.toString() +
          'guard/accepted_clients_report_filter/?year=${current_year}&month=${select_month_data}';
    } else if (is_day!) {
      infourl = Helper.url.toString() +
          'guard/accepted_clients_report_filter/?today=true';
    }

    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(infourl);
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = clientReportAdminMidelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali now = Jalali.now();
  Jalali? date_now = Jalali.now();
  String? current_month;
  String? current_year;
  bool? is_month = false;
  bool? is_day = true;
  bool? is_all = false;

  Widget show_filter(String? title, bool? is_select, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 7.0),
        decoration: BoxDecoration(
          color: is_select! ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
                color: is_select ? Colors.white : Colors.black,
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  int? select_month_data;
  int? shamsi_month_select = 0;
  bool? is_sh_month = false;
  Widget month_select() {
    return Row(
      children: [
        Text(
          shamsi_month_select == 0
              ? "انتخاب ماه"
              : shamsi_month_select == 1
                  ? "فروردین"
                  : shamsi_month_select == 2
                      ? "اردیبهشت"
                      : shamsi_month_select == 3
                          ? "خرداد"
                          : shamsi_month_select == 4
                              ? "تیر"
                              : shamsi_month_select == 5
                                  ? "مرداد"
                                  : shamsi_month_select == 6
                                      ? "شهریور"
                                      : shamsi_month_select == 7
                                          ? "مهر"
                                          : shamsi_month_select == 8
                                              ? "آبان"
                                              : shamsi_month_select == 9
                                                  ? "آذر"
                                                  : shamsi_month_select == 10
                                                      ? "دی"
                                                      : shamsi_month_select ==
                                                              11
                                                          ? "بهمن"
                                                          : shamsi_month_select ==
                                                                  12
                                                              ? "اسفند"
                                                              : "انتخاب ماه",
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        PopupMenuButton(
          itemBuilder: (context) => const [
            PopupMenuItem(
              child: Text("فروردین"),
              value: 1,
            ),
            PopupMenuItem(
              child: Text("اردیبهشت"),
              value: 2,
            ),
            PopupMenuItem(
              child: Text("خرداد"),
              value: 3,
            ),
            PopupMenuItem(
              child: Text("تیر"),
              value: 4,
            ),
            PopupMenuItem(
              child: Text("مرداد"),
              value: 5,
            ),
            PopupMenuItem(
              child: Text("شهریور"),
              value: 6,
            ),
            PopupMenuItem(
              child: Text("مهر"),
              value: 7,
            ),
            PopupMenuItem(
              child: Text("آبان"),
              value: 8,
            ),
            PopupMenuItem(
              child: Text("آذر"),
              value: 9,
            ),
            PopupMenuItem(
              child: Text("دی"),
              value: 10,
            ),
            PopupMenuItem(
              child: Text("بهمن"),
              value: 11,
            ),
            PopupMenuItem(
              child: Text("اسفند"),
              value: 12,
            ),
          ],
          onSelected: (value) {
            setState(() {
              shamsi_month_select = value;
              select_month_data = shamsi_month_select!;
              is_all = false;
              is_month = false;
              is_sh_month = true;
              is_day = false;
            });
            accepted_clients_report();
          },
        ),
      ],
    );
  }
}
