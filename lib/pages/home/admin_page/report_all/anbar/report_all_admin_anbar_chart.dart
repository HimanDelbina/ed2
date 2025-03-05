import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../../models/report/all_report_anbar_model.dart';

class ReportAllAdminAnbarChart extends StatefulWidget {
  var data;
  ReportAllAdminAnbarChart({super.key, this.data});

  @override
  State<ReportAllAdminAnbarChart> createState() =>
      _ReportAllAdminAnbarChartState();
}

class _ReportAllAdminAnbarChartState extends State<ReportAllAdminAnbarChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedUnitData,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(countRequest!, style: const TextStyle(fontSize: 16)),
            Text(percentageRequest!, style: const TextStyle(fontSize: 16)),
            const Divider(),
            Expanded(child: Center(child: buildChart(widget.data))),
          ],
        ),
      )),
    );
  }

  double calculatePercentage(int totalRequests, int sumOfAllRequests) {
    if (sumOfAllRequests == 0) return 0; // جلوگیری از تقسیم بر صفر
    return (totalRequests / sumOfAllRequests) * 100;
  }

  Widget buildChart(List<AnbarReportAllModel> data) {
    int sumOfAllRequests =
        data.fold(0, (sum, item) => sum + item.totalRequests!);

    return Container(
      child: PieChart(
        PieChartData(
          sections: data.map((item) {
            final percentage =
                calculatePercentage(item.totalRequests!, sumOfAllRequests);
            final isTouched = data.indexOf(item) == touchedIndex;

            return PieChartSectionData(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
              value: percentage,
              title: item.userUnitName!,
              color: getRandomColor(item.userUnitName!),
              radius: isTouched ? 120 : 100,
              titleStyle: TextStyle(
                fontSize: isTouched ? 16 : 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          sectionsSpace: 3, // فاصله بین بخش‌ها
          centerSpaceRadius: 60, // شعاع فضای مرکزی
          titleSunbeamLayout: true, // تنظیم طرح عنوان
          pieTouchData: PieTouchData(
            enabled: true,
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              if (event is FlTapUpEvent &&
                  pieTouchResponse?.touchedSection != null) {
                setState(() {
                  touchedIndex =
                      pieTouchResponse!.touchedSection!.touchedSectionIndex;
                  countRequest =
                      "تعداد درخواست ها : ${data[touchedIndex!].totalRequests.toString().toPersianDigit()}";
                  percentageRequest =
                      "درصد درخواست ها : ${calculatePercentage(data[touchedIndex!].totalRequests!, sumOfAllRequests).toStringAsFixed(2).toPersianDigit()} %";
                  selectedUnitData =
                      "واحد : ${data[touchedIndex!].userUnitName}";
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
      ),
    );
  }

  int? touchedIndex = 0;
  String? countRequest = "تعداد درخواست ها: 0";
  String? percentageRequest = "درصد درخواست ها: 0%";
  String selectedUnitData = "لطفاً روی یک بخش کلیک کنید";
  Color getRandomColor(String unitName) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.brown,
      Colors.amber,
      Colors.cyan,
      Colors.pink,
    ];
    if (unitName.isEmpty) return Colors.grey; // جلوگیری از خطای null
    return colors[unitName.hashCode % colors.length];
  }
}
