import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../models/guard/report_all_guard_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class GuardReportAll extends StatefulWidget {
  const GuardReportAll({super.key});

  @override
  State<GuardReportAll> createState() => _GuardReportAllState();
}

class _GuardReportAllState extends State<GuardReportAll> {
  late ReportAllGuardModel reportData;

  String countRequest = "تعداد درخواست ها: 0";
  String percentageRequest = "درصد درخواست ها: 0%";
  String selectedUnitData = "لطفاً روی یک بخش کلیک کنید";
  @override
  void initState() {
    report_view();
    reportData = ReportAllGuardModel(
      importCommodity: PortCommodity(totalRequests: 1),
      exportCommodity: PortCommodity(totalRequests: 1),
      clientRegister: ClientRegister(totalRequests: 2),
    );

    super.initState();
  }

  List<ChartData> preprocessData(ReportAllGuardModel data) {
    List<ChartData> chartDataList = [];

    if (data.importCommodity != null) {
      chartDataList.add(
        ChartData(
          title: "ورود کالا",
          totalRequests: data.importCommodity!.totalRequests!,
        ),
      );
    }

    if (data.exportCommodity != null) {
      chartDataList.add(
        ChartData(
          title: "خروج کالا",
          totalRequests: data.exportCommodity!.totalRequests!,
        ),
      );
    }

    if (data.clientRegister != null) {
      chartDataList.add(
        ChartData(
          title: "ورود افراد",
          totalRequests: data.clientRegister!.totalRequests!,
        ),
      );
    }

    return chartDataList;
  }

  @override
  Widget build(BuildContext context) {
    final processedData = preprocessData(reportData);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Container(
          width: double.infinity,
          child: isGetData == false
              ? Center(
                  child:
                      Lottie.asset("assets/lottie/loading.json", height: 40.0))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildItems(
                        "درخواست های ورود کالا به شرکت",
                        "تعداد کل درخواست های ورودی به شرکت ",
                        "تعداد درخواست های ورودی تایید شده ",
                        "تعداد درخواست های ورودی تایید نشده ",
                        Colors.green,
                        import_commodity),
                    buildItems(
                        "درخواست های خروج کالا به شرکت",
                        "تعداد کل درخواست های خروجی به شرکت ",
                        "تعداد درخواست های خروجی تایید شده ",
                        "تعداد درخواست های خروجی تایید نشده ",
                        Colors.red,
                        export_commodity),
                    buildItems(
                        "درخواست های ورود افراد به شرکت",
                        "تعداد کل درخواست های ورود افراد به شرکت ",
                        "تعداد درخواست های ورود افراد تایید شده ",
                        "تعداد درخواست های ورود افراد تایید نشده ",
                        Colors.blue,
                        client_register),
                    const Divider(),
                    Expanded(
                        child: CombinedChartAndInfoWidget(data: processedData)),
                  ],
                ),
        ),
      )),
    );
  }

  Widget buildItems(String title, String titleAll, String titleAccept,
      String titleReject, Color color, var data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          const Divider(),
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(Icons.circle, color: Colors.blue, size: 5.0)),
              Text(
                  "${titleAll} : ${data.totalRequests.toString().toPersianDigit()}"),
            ],
          ),
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(Icons.check, color: Colors.green, size: 15.0)),
              Text(
                  "${titleAccept} : ${data.approvedCount.toString().toPersianDigit()}"),
            ],
          ),
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(Icons.clear, color: Colors.red, size: 15.0)),
              Text(
                  "${titleReject} : ${data.unapprovedCount.toString().toPersianDigit()}"),
            ],
          ),
        ],
      ),
    );
  }

  var import_commodity;
  var export_commodity;
  var client_register;

  bool? isGetData = false;
  Future<void> report_view() async {
    String infourl = Helper.url.toString() + 'report/report_view';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      ReportAllGuardModel recive_data =
          ReportAllGuardModel.fromJson(json.decode(x));
      setState(() {
        import_commodity = recive_data.importCommodity;
        export_commodity = recive_data.exportCommodity;
        client_register = recive_data.clientRegister;
        isGetData = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}

class ChartData {
  final String title;
  final int totalRequests;

  ChartData({required this.title, required this.totalRequests});
}

class CombinedChartAndInfoWidget extends StatefulWidget {
  final List<ChartData> data;

  const CombinedChartAndInfoWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _CombinedChartAndInfoWidgetState createState() =>
      _CombinedChartAndInfoWidgetState();
}

class _CombinedChartAndInfoWidgetState
    extends State<CombinedChartAndInfoWidget> {
  int? touchedIndex;
  String countRequest = "تعداد درخواست ها: 0";
  String percentageRequest = "درصد درخواست ها: 0%";
  String selectedUnitData = "لطفاً روی یک بخش کلیک کنید";

  // دیکشنری رنگ‌ها برای هر عنوان
  final Map<String, Color> colorMap = {
    "ورود کالا": Colors.green,
    "ورود افراد": Colors.blue,
    "خروج کالا": Colors.red,
  };

  double calculatePercentage(int totalRequests, int sumOfAllRequests) {
    if (sumOfAllRequests == 0) return 0; // جلوگیری از تقسیم بر صفر
    return (totalRequests / sumOfAllRequests) * 100;
  }

  Widget buildChart() {
    int sumOfAllRequests =
        widget.data.fold(0, (sum, item) => sum + item.totalRequests);

    return PieChart(
      PieChartData(
        sections: widget.data.map((item) {
          final percentage =
              calculatePercentage(item.totalRequests, sumOfAllRequests);
          final isTouched = widget.data.indexOf(item) == touchedIndex;

          // استفاده از دیکشنری رنگ‌ها
          final sectionColor = colorMap[item.title] ?? Colors.grey;

          return PieChartSectionData(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.3)),
            value: percentage,
            // title: "${percentage.toStringAsFixed(1)}%",
            title: "${percentage.toStringAsFixed(1).toPersianDigit()} %",
            color: sectionColor, // رنگ از دیکشنری
            radius: isTouched ? 120 : 100, // اندازه بزرگ‌تر برای بخش انتخاب‌شده
            titleStyle: TextStyle(
              fontSize: isTouched ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 3, // فاصله بین بخش‌ها
        centerSpaceRadius: 60, // شعاع فضای مرکزی
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            if (event is FlTapUpEvent &&
                pieTouchResponse?.touchedSection != null) {
              setState(() {
                touchedIndex =
                    pieTouchResponse!.touchedSection!.touchedSectionIndex;

                // به‌روزرسانی اطلاعات متنی
                final selectedData = widget.data[touchedIndex!];
                countRequest =
                    "تعداد درخواست ها: ${selectedData.totalRequests.toString().toPersianDigit()}";
                percentageRequest =
                    "درصد درخواست ها: ${calculatePercentage(selectedData.totalRequests, sumOfAllRequests).toStringAsFixed(1).toPersianDigit()} %";
                selectedUnitData = "واحد: ${selectedData.title}";
              });
            } else {
              setState(() {
                touchedIndex = null;
                selectedUnitData = "لطفاً روی یک بخش کلیک کنید";
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(countRequest),
                Text(percentageRequest),
                Text(selectedUnitData),
              ],
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("ورود کالا")),
                    Icon(Icons.circle, size: 10.0, color: Colors.green),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("خروج کالا")),
                    Icon(Icons.circle, size: 10.0, color: Colors.red),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("ورود افراد")),
                    Icon(Icons.circle, size: 10.0, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ],
        ),
        Expanded(child: buildChart()),
      ],
    );
  }
}
