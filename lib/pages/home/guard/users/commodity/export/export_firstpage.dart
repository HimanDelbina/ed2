import 'package:ed/pages/home/guard/users/commodity/export/export_report_all.dart';
import 'package:flutter/material.dart';
import 'export_commodity.dart';
import 'export_report.dart';

class ExportCommodityFirstPage extends StatefulWidget {
  const ExportCommodityFirstPage({super.key});

  @override
  State<ExportCommodityFirstPage> createState() =>
      _ImportCommodityFirstPageState();
}

class _ImportCommodityFirstPageState extends State<ExportCommodityFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "خروج کالا"),
    const Tab(text: "گزارش"),
    const Tab(text: "گزارش همه "),
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
            ExportCommodityPage(),
            ExportReportPage(),
            ExportReportAll(),
          ],
        ),
      ),
    );
  }
}
