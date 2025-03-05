import 'package:ed/models/report/all_report_overtime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../static/helper_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:lottie/lottie.dart';
import 'package:iconly/iconly.dart';
import 'package:fl_chart/fl_chart.dart';

class UnitAllReportOvertime extends StatefulWidget {
  const UnitAllReportOvertime({super.key});

  @override
  State<UnitAllReportOvertime> createState() => _UnitAllReportOvertimeState();
}

class _UnitAllReportOvertimeState extends State<UnitAllReportOvertime> {
  @override
  void initState() {
    getOvertimeSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return isGetData
        ? Padding(
            padding: PagePadding.page_padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تعداد درخواست های مرخصی کل ماه ها : ${data!.grandTotalOvertime.toString().toPersianDigit()} عدد",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "جمع مرخصی های کل ماه ها : ${data!.grandTotalHours.toString().toPersianDigit()} ساعت",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const Text("جمع کل مرخصی ها بر اساس ماه :"),
              ],
            ),
          )
        : Center(
            child: Lottie.asset("assets/lottie/loading.json", height: 40.0),
          );
  }

  OvertimeSummary? data; // کل مدل رو نگه می‌داریم
  bool isGetData = false;
  Future<void> getOvertimeSummary() async {
    String infoUrl =
        '${Helper.url}report/overtime_summary_by_date/overtime_summary/';
    print('در حال دریافت داده از: $infoUrl');

    try {
      var response = await http.get(
        Uri.parse(infoUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var receivedData = allReportModelFromJson(response.body);
        setState(() {
          data = receivedData; // کل مدل رو ذخیره می‌کنیم
          isGetData = true;
        });
      } else if (response.statusCode == 204) {
        MyMessage.mySnackbarMessage(context, "داده‌ای یافت نشد", 1);
      } else {
        MyMessage.mySnackbarMessage(
            context, "خطا در دریافت داده: ${response.statusCode}", 1);
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطا: $e", 1);
      setState(() {
        isGetData = false;
      });
    }
  }
}
