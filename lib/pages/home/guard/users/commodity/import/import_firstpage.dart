import 'package:ed/pages/home/guard/users/commodity/import/import_report_all_page.dart';
import 'package:flutter/material.dart';
import 'package:ed/pages/home/guard/users/commodity/export/export_report.dart';
import 'package:ed/pages/home/guard/users/commodity/import/import_commodity.dart';
import 'package:ed/pages/home/guard/users/commodity/import/import_report.dart';

class ImportCommodityFirstPage extends StatefulWidget {
  const ImportCommodityFirstPage({super.key});

  @override
  State<ImportCommodityFirstPage> createState() =>
      _ImportCommodityFirstPageState();
}

class _ImportCommodityFirstPageState extends State<ImportCommodityFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "ورود کالا"),
    const Tab(text: "گزارش"),
    const Tab(text: "گزارش کامل"),
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
            ImportCommodityPage(),
            ImportReportPage(),
            ImportReportAllPage(),
          ],
        ),
      ),
    );
  }
}
