import 'package:ed/pages/home/guard/users/guard_check_page.dart';
import 'package:flutter/material.dart';

import 'guard_report_firstpage.dart';

class GuardCheckFirstpage extends StatefulWidget {
  const GuardCheckFirstpage({super.key});

  @override
  State<GuardCheckFirstpage> createState() => _GuardCheckFirstpageState();
}

class _GuardCheckFirstpageState extends State<GuardCheckFirstpage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "گزارش"),
    const Tab(text: "دسترسی ها"),
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
              GuardReportFirstPage(),
              GuardCheckPage(),
            ],
          ),
        ));
  }
}
