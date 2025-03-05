import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/models/shift/shift_report_user_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;
import 'user_change_shift.dart';

class UserShiftFirstPage extends StatefulWidget {
  const UserShiftFirstPage({super.key});

  @override
  State<UserShiftFirstPage> createState() => _UserShiftFirstPageState();
}

class _UserShiftFirstPageState extends State<UserShiftFirstPage> {
  int? userID;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      userID = prefsUser.getInt("id") ?? 0;
    });
    get_shift_all_report();
  }

  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  List<String> persianMonths = [
    "فروردین",
    "اردیبهشت",
    "خرداد",
    "تیر",
    "مرداد",
    "شهریور",
    "مهر",
    "آبان",
    "آذر",
    "دی",
    "بهمن",
    "اسفند"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            is_get_all_report!
                ? Text(
                    "شیفت امروز شما : ${shiftReportData!.todayShifts![0].shiftTypeName!} ",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                : const SizedBox(),
            const Divider(),
            Row(
              children: [
                myWidget("تعویض شیفت", const UserChangeShiftPage()),
                // myWidget("جزییات", UserChangeShiftPage()),
              ],
            ),
            const Divider(),
            Expanded(
              child: is_get_all_report!
                  ? ListView.builder(
                      itemCount: shiftReportData!.monthlyShifts!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "ماه : ${shiftReportData!.monthlyShifts![index].month.toString().toPersianDigit()} ( ${persianMonths[shiftReportData!.monthlyShifts![index].month! - 1]} )"),
                                  Text(
                                      "تعداد کل : ${shiftReportData!.monthlyShifts![index].totalShiftsInMonth.toString().toPersianDigit()} روز")
                                ],
                              ),
                              const Divider(),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: shiftReportData!
                                    .monthlyShifts![index].shiftTypes!.length,
                                itemBuilder: (context, shiftTypeIndex) {
                                  return Container(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 15.0, vertical: 5.0),
                                    margin:
                                        const EdgeInsetsDirectional.symmetric(
                                            vertical: 5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(
                                            color: shiftReportData!
                                                        .monthlyShifts![index]
                                                        .shiftTypes![
                                                            shiftTypeIndex]
                                                        .totalShifts ==
                                                    0
                                                ? Colors.red.withOpacity(0.5)
                                                : Colors.green
                                                    .withOpacity(0.5))),
                                    child: Text(
                                        "شیفت ${shiftReportData!.monthlyShifts![index].shiftTypes![shiftTypeIndex].shiftTypeName.toString()} : ${shiftReportData!.monthlyShifts![index].shiftTypes![shiftTypeIndex].totalShifts.toString().toPersianDigit()} روز"),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Lottie.asset("assets/lottie/loading.json",
                          height: 40.0)),
            )
          ],
        ),
      )),
    );
  }

  Widget myWidget(String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => page,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        margin: const EdgeInsets.only(left: 15.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            border: Border.all(color: Colors.grey.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(title),
      ),
    );
  }

  bool? is_get_all_report = false;
  ShiftReportUserModel? shiftReportData; // تعریف یک مدل برای ذخیره اطلاعات

  Future<void> get_shift_all_report() async {
    String infourl =
        Helper.url.toString() + 'shift/get_shift_by_user_id_new/${userID}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // مقداردهی مدل جدید با داده‌های دریافتی
      ShiftReportUserModel report = ShiftReportUserModel.fromJson(data);

      if (mounted) {
        setState(() {
          shiftReportData = report;
          is_get_all_report = true;
        });
      }
    } else {
      // Handle error
      if (mounted) {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    }
  }
}
