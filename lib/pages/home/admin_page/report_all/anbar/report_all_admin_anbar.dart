import 'package:ed/pages/home/admin_page/report_all/anbar/report_all_admin_anbar_chart.dart';
import 'package:iconly/iconly.dart';
import 'package:ed/models/report/all_report_anbar_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportAllAdminAnbar extends StatefulWidget {
  const ReportAllAdminAnbar({super.key});

  @override
  State<ReportAllAdminAnbar> createState() => _ReportAllAdminAnbarState();
}

class _ReportAllAdminAnbarState extends State<ReportAllAdminAnbar> {
  @override
  void initState() {
    requests_count_by_unit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: data.isEmpty
            ? Center(
                child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5)),
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("واحد : ${data[index].userUnitName}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      "تعداد کل درخواست ها : ${data[index].totalRequests.toString().toPersianDigit()}"),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "درخواست های تایید شده : ${data[index].acceptedRequests.toString().toPersianDigit()}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    "درخواست های رد شده : ${data[index].rejectedRequests.toString().toPersianDigit()}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReportAllAdminAnbarChart(data: data),
                          ));
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
      )),
    );
  }

  List<AnbarReportAllModel> data = [];
  bool? is_get_data = false;
  Future<void> requests_count_by_unit() async {
    String infourl = Helper.url.toString() + 'anbar/requests_count_by_unit/';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = anbarReportAllModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

}
