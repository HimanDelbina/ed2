import 'package:flutter/material.dart';
import 'package:ed/pages/home/manage_anbar/import_com/ma_import_report.dart';
import 'package:ed/pages/home/manage_anbar/import_com/ma_import_report_table.dart';

import 'ma_import_com_firstpage.dart';

class ManagerAnbarImportFirstpage extends StatefulWidget {
  const ManagerAnbarImportFirstpage({super.key});

  @override
  State<ManagerAnbarImportFirstpage> createState() =>
      _ManagerAnbarImportFirstpageState();
}

class _ManagerAnbarImportFirstpageState
    extends State<ManagerAnbarImportFirstpage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست ها"),
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
              ManagerAnbarImportComRequest(),
              ManagerAnbarImportReportData(),
              ManagerAnbarImportReportTable(),
            ],
          ),
        ));
  }
}
