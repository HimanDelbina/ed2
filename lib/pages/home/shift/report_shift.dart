import 'package:flutter/material.dart';

import 'shift_report/all_report_shift.dart';
import 'shift_report/shift_report_unit.dart';

class ReportShiftPage extends StatefulWidget {
  const ReportShiftPage({super.key});

  @override
  State<ReportShiftPage> createState() => _ReportShiftPageState();
}

class _ReportShiftPageState extends State<ReportShiftPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "همه"),
    const Tab(text: "واحد"),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            const AllReportShiftPage(),
            ReportShiftUnitPage(),
          ],
        ),
      ),
    );
  }
}
