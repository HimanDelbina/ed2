import 'package:ed/pages/home/Leave_page/leave_clock_page.dart';
import 'package:ed/pages/home/Leave_page/leave_day_page.dart';
import 'package:flutter/material.dart';

import 'leave_report_filter_page.dart';
import 'leave_report_page.dart';

class LeavePage extends StatefulWidget {
  int? user_id;
  int? Unit_id;
  LeavePage({super.key, this.Unit_id, this.user_id});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "مرخصی ساعتی"),
    const Tab(text: "مرخصی روزانه"),
    const Tab(text: "گزارش"),
    // const Tab(text: "فیلتر گزارش"),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
          children: const [
            LeaveClockPage(),
            LeaveDayPage(),
            UserReportPage(),
            // UserReportFilterPage(),
          ],
        ),
      ),
    );
  }
}
