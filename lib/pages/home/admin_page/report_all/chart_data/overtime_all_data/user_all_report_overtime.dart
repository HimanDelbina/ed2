import 'package:ed/models/report/all_report_overtime.dart';
import 'package:ed/pages/home/admin_page/report_all/chart_data/overtime_all_data/overtime_all_data_firstpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../../static/helper_page.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:lottie/lottie.dart';
import 'package:iconly/iconly.dart';
import 'package:fl_chart/fl_chart.dart';

class UserAllReportOvertime extends StatefulWidget {
  const UserAllReportOvertime({super.key});

  @override
  State<UserAllReportOvertime> createState() => _UserAllReportState();
}

class _UserAllReportState extends State<UserAllReportOvertime>
    with SingleTickerProviderStateMixin {
  TabController? tabController; // تعریف TabController

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(vsync: this, length: 4); // تنظیمات TabController
  }

  @override
  void dispose() {
    tabController!.dispose(); // آزادسازی منابع
    super.dispose();
  }

  final List<Tab> topTabs = <Tab>[
    const Tab(text: "اضافه کاری"),
    const Tab(text: "تعطیل کاری"),
    const Tab(text: "جمعه کاری"),
    const Tab(text: "ماموریت"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 10,
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.blueGrey,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "Vazir"),
            tabs: topTabs,
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            OvertimeAllDataFirstPage(select: "EZ"),
            OvertimeAllDataFirstPage(select: "TA"),
            OvertimeAllDataFirstPage(select: "GO"),
            OvertimeAllDataFirstPage(select: "MA"),
          ],
        ),
      ),
    );
  }
}
