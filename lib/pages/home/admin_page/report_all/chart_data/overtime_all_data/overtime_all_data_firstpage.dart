import 'package:ed/models/report/all_report_overtime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../static/helper_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:lottie/lottie.dart';
import 'package:iconly/iconly.dart';
import 'package:fl_chart/fl_chart.dart';

class OvertimeAllDataFirstPage extends StatefulWidget {
  String? select;
  OvertimeAllDataFirstPage({super.key, this.select});

  @override
  State<OvertimeAllDataFirstPage> createState() =>
      _OvertimeAllDataFirstPageState();
}

class _OvertimeAllDataFirstPageState extends State<OvertimeAllDataFirstPage> {
  @override
  void initState() {
    getOvertimeSummary();
    super.initState();
  }

  String getWorkType(String code) {
    switch (code) {
      case "EZ":
        return "اضافه کاری";
      case "TA":
        return "تعطیل کاری";
      case "GO":
        return "جمعه کاری";
      case "MA":
        return "ماموریت";
      default:
        return "نامشخص";
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: isGetData
          ? Padding(
              padding: PagePadding.page_padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تعداد درخواست های ${getWorkType(widget.select.toString())} کل ماه ها : ${data!.grandTotalOvertime.toString().toPersianDigit()} عدد",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "جمع ${getWorkType(widget.select.toString())} های کل ماه ها : ${data!.grandTotalHours.toString().toPersianDigit()} ساعت",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                      "جمع کل ${getWorkType(widget.select.toString())} ها بر اساس ماه :"),
                  Expanded(
                      child: ListView.builder(
                    itemCount: data!.months.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "تاریخ : ${data!.months[index].month.toString().toPersianDigit()}",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Text(
                              "تعداد درخواست های ${getWorkType(widget.select.toString())} کل ماه ها : ${data!.months[index].totalOvertime.toString().toPersianDigit()} عدد",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "جمع ${getWorkType(widget.select.toString())} های کل ماه ها : ${data!.months[index].totalHours.toString().toPersianDigit()} ساعت",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        margin: const EdgeInsets.all(10),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(hours: 1),
                                        // duration: const Duration(
                                        //     days: 365),
                                        content: Container(
                                            height: myHeight * 0.6,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemCount: data!
                                                        .months[index]
                                                        .byUser
                                                        .length,
                                                    itemBuilder:
                                                        (context, index_user) {
                                                      return Container(
                                                        width: myWidth,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5.0),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                                // color: Colors.grey
                                                                //     .withOpacity(0.1),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(data!
                                                                .months[index]
                                                                .byUser[
                                                                    index_user]
                                                                .name),
                                                            const Divider(),
                                                            Text(
                                                              "تعداد درخواست های ${getWorkType(widget.select.toString())} کل ماه ها : ${data!.months[index].byUser[index_user].overtimeCount.toString().toPersianDigit()} عدد",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "جمع ${getWorkType(widget.select.toString())} های کل ماه ها : ${data!.months[index].byUser[index_user].totalHours.toString().toPersianDigit()} ساعت",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const Divider(),
                                                GestureDetector(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                  },
                                                  child: Container(
                                                      width: myWidth,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15.0,
                                                          vertical: 10.0),
                                                      decoration: BoxDecoration(
                                                          // color: Colors.grey
                                                          //     .withOpacity(0.1),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0)),
                                                      child: const Center(
                                                          child: Text("بستن"))),
                                                )
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "جزییات کاربران",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        margin: const EdgeInsets.all(10),
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(hours: 1),
                                        // duration: const Duration(
                                        //     days: 365),
                                        content: Container(
                                            height: myHeight * 0.6,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemCount: data!
                                                        .months[index]
                                                        .byUnit
                                                        .length,
                                                    itemBuilder:
                                                        (context, index_unit) {
                                                      return Container(
                                                        width: myWidth,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    15.0,
                                                                vertical: 5.0),
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5.0),
                                                        decoration:
                                                            BoxDecoration(
                                                                // color: Colors.grey
                                                                //     .withOpacity(0.1),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(data!
                                                                .months[index]
                                                                .byUnit[
                                                                    index_unit]
                                                                .unit),
                                                            const Divider(),
                                                            Text(
                                                              "تعداد درخواست های ${getWorkType(widget.select.toString())} کل ماه ها : ${data!.months[index].byUnit[index_unit].overtimeCount.toString().toPersianDigit()} عدد",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "جمع ${getWorkType(widget.select.toString())} های کل ماه ها : ${data!.months[index].byUnit[index_unit].totalHours.toString().toPersianDigit()} ساعت",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const Divider(),
                                                GestureDetector(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                  },
                                                  child: Container(
                                                      width: myWidth,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 15.0,
                                                          vertical: 10.0),
                                                      decoration: BoxDecoration(
                                                          // color: Colors.grey
                                                          //     .withOpacity(0.1),
                                                          border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0)),
                                                      child: const Center(
                                                          child: Text("بستن"))),
                                                )
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "جزییات واحد ها",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          margin: const EdgeInsets.all(10),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(hours: 1),
                          // duration: const Duration(
                          //     days: 365),
                          content: Container(
                              height: myHeight * 0.6,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: BarChart(
                                      BarChartData(
                                        gridData: const FlGridData(
                                          show:
                                              false, // گرید رو کامل غیرفعال می‌کنیم
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          leftTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles:
                                                  false, // اعداد محور Y (سمت چپ) حذف شده
                                            ),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles:
                                                  false, // اعداد محور سمت راست حذف شده
                                            ),
                                          ),
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles:
                                                  true, // فعال کردن عناوین بالای چارت
                                              reservedSize:
                                                  30, // فضای کافی برای نمایش ساعت‌ها
                                              getTitlesWidget: (value, meta) {
                                                int index = value.toInt();
                                                if (index >= 0 &&
                                                    index <
                                                        data!.months.length) {
                                                  return Column(
                                                    children: [
                                                      Text(
                                                        data!.months[index]
                                                            .totalHours
                                                            .toStringAsFixed(1)
                                                            .toString()
                                                            .toPersianDigit(), // نمایش ساعت‌ها
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      const Text(
                                                        "ساعت",
                                                        style: TextStyle(
                                                            fontSize: 10.0),
                                                      )
                                                    ],
                                                  );
                                                }
                                                return const Text('');
                                              },
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 30,
                                              getTitlesWidget: (value, meta) {
                                                int index = value.toInt();
                                                if (index >= 0 &&
                                                    index <
                                                        data!.months.length) {
                                                  String monthNumber = data!
                                                      .months[index].month
                                                      .split('/')[1];
                                                  return Column(
                                                    children: [
                                                      const Text(
                                                        "ماه ",
                                                        style: TextStyle(
                                                            fontSize: 10.0),
                                                      ),
                                                      Text(
                                                        monthNumber
                                                            .toString()
                                                            .toPersianDigit(),
                                                      ),
                                                    ],
                                                  ); // شماره ماه + کلمه "ماه"
                                                }
                                                return const Text('');
                                              },
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                            show: true), // حاشیه دور چارت
                                        barGroups: data!.months
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return BarChartGroupData(
                                            x: entry.key,
                                            barRods: [
                                              BarChartRodData(
                                                toY: entry.value.totalHours,
                                                color: Colors.blueAccent,
                                                width: 7, // عرض میله‌ها
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                        alignment: BarChartAlignment
                                            .spaceBetween, // فاصله بین میله‌ها
                                        barTouchData: BarTouchData(
                                          enabled: true,
                                          touchTooltipData: BarTouchTooltipData(
                                            getTooltipItem: (group, groupIndex,
                                                rod, rodIndex) {
                                              return BarTooltipItem(
                                                '${data!.months[groupIndex].month}\n${data!.months[groupIndex].totalHours.toStringAsFixed(1)}',
                                                const TextStyle(
                                                    color: Colors.white),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      swapAnimationDuration: const Duration(
                                          milliseconds: 600), // بدون انیمیشن
                                      swapAnimationCurve:
                                          Curves.linear, // جهت ساده
                                    ),
                                  )),
                                  const Divider(),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    },
                                    child: Container(
                                        width: myWidth,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                            // color: Colors.grey
                                            //     .withOpacity(0.1),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child:
                                            const Center(child: Text("بستن"))),
                                  )
                                ],
                              )),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: const Icon(IconlyBold.chart, size: 30.0),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0),
            ),
    ));
  }

  OvertimeSummary? data; // کل مدل رو نگه می‌داریم
  bool isGetData = false;
  Future<void> getOvertimeSummary() async {
    String infoUrl =
        '${Helper.url}report/overtime_summary_by_date/overtime_summary/?overtime_type=${widget.select}';
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
