import 'package:flutter/material.dart';
import 'package:ed/pages/home/manage_anbar/export_com/ma_export_report_data.dart';

import 'ma_export_report_table.dart';
import 'ma_export_request.dart';

class ManagerAcceptExportFirstPage extends StatefulWidget {
  const ManagerAcceptExportFirstPage({super.key});

  @override
  State<ManagerAcceptExportFirstPage> createState() =>
      _ManagerAcceptExportFirstPageState();
}

class _ManagerAcceptExportFirstPageState
    extends State<ManagerAcceptExportFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست"),
    const Tab(text: "گزارش داده ای"),
    const Tab(text: "گزارش جدولی"),
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
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
              ManagerAnbarExportRequest(),
              ManagerAnbarExportReportData(),
              ManagerAnbarExportReportTable(),
            ],
          ),
        ));
  }
}
