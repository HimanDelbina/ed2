import 'package:flutter/material.dart';
import 'package:ed/pages/home/manage_anbar/report/ma_report_all.dart';
import 'package:ed/pages/home/manage_anbar/report/ma_report_all_table.dart';
import 'package:ed/pages/home/manage_anbar/report/ma_report_unit_id.dart';
import 'package:ed/pages/home/manage_anbar/report/ma_report_unit_id_table.dart';

class ManageraAnbarReportFirstpage extends StatefulWidget {
  const ManageraAnbarReportFirstpage({super.key});

  @override
  State<ManageraAnbarReportFirstpage> createState() =>
      _ManageraAnbarReportFirstpageState();
}

class _ManageraAnbarReportFirstpageState
    extends State<ManageraAnbarReportFirstpage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "گزارش داده ای"),
    const Tab(text: "گزارش جدولی"),
    const Tab(text: "گزارش واحد"),
    const Tab(text: "گزارش واحد جدولی"),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
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
          children: const [
            ManagerAnbarReportAll(),
            ManagerAnbarReportAllTable(),
            ManagerAnbarReportUnitID(),
            ManagerAnbarReportUnitIDTable(),
          ],
        ),
      ),
    );
  }
}
