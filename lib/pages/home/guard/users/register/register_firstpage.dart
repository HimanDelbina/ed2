import 'package:ed/pages/home/guard/users/guard_check_page.dart';
import 'package:flutter/material.dart';
import 'package:ed/pages/home/guard/users/register/register_report.dart';

import 'register_add.dart';

class GuardRegisterFirstPage extends StatefulWidget {
  const GuardRegisterFirstPage({super.key});

  @override
  State<GuardRegisterFirstPage> createState() => _GuardCheckFirstpageState();
}

class _GuardCheckFirstpageState extends State<GuardRegisterFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "ثبت مراجعین"),
    const Tab(text: "گزارش"),
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
              RegisterAddPage(),
              GuardRegisterReportPage(),
            ],
          ),
        ));
  }
}
