import 'package:ed/pages/home/bazargani/request/bazargani_report.dart';
import 'package:ed/pages/home/bazargani/request/bazargani_report_all.dart';
import 'package:flutter/material.dart';
import 'package:ed/pages/home/bazargani/request/bazargani_request.dart';

class BazarganiCheckPage extends StatefulWidget {
  const BazarganiCheckPage({super.key});

  @override
  State<BazarganiCheckPage> createState() => _BazarganiCheckPageState();
}

class _BazarganiCheckPageState extends State<BazarganiCheckPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

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

  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست"),
    const Tab(text: "گزارش"),
    const Tab(text: "گزارش کامل"),
  ];

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
            BazarganiRequestPage(),
            BazarganiReportPage(),
            BazarganiReportAll(),
          ],
        ),
      ),
    );
  }
}
