import 'package:flutter/material.dart';
import 'package:ed/pages/home/kargozini/gharardad/gharardad_page.dart';
import 'package:ed/pages/home/kargozini/gharardad/gharardad_report.dart';
import 'package:ed/pages/home/kargozini/gharardad/gharardad_report_table.dart';

class GharadadFirstPage extends StatefulWidget {
  const GharadadFirstPage({super.key});

  @override
  State<GharadadFirstPage> createState() => _GharadadFirstPageState();
}

class _GharadadFirstPageState extends State<GharadadFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "آخرین قرارداد ها"),
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
            GharardadPage(),
            GharardadReport(),
            GharardadReportTable(),
          ],
        ),
      ),
    );
  }
}
