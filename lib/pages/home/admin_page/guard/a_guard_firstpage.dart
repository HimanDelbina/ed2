import 'package:flutter/material.dart';
import 'package:ed/pages/home/admin_page/guard/a_guard_report.dart';
import 'package:ed/pages/home/admin_page/guard/a_guard_request.dart';

class AdminGuardFirstPage extends StatefulWidget {
  const AdminGuardFirstPage({super.key});

  @override
  State<AdminGuardFirstPage> createState() => _AdminGuardFirstPageState();
}

class _AdminGuardFirstPageState extends State<AdminGuardFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست ها"),
    const Tab(text: "گزارش ها"),
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
            children: const [
              AdminGuardRequestPage(),
              AdminGuardReportPage(),
            ],
          ),
        ));
  }
}
