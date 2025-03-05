import 'package:flutter/material.dart';
import 'package:ed/pages/home/kargozini/overtime/all/k_overtime_all_data.dart';
import 'package:ed/pages/home/kargozini/overtime/unit/k_overtime_unit.dart';

import 'users/kargozini_check_overtime_page.dart';

class KargoziniOvertimeFirstPage extends StatefulWidget {
  const KargoziniOvertimeFirstPage({super.key});

  @override
  State<KargoziniOvertimeFirstPage> createState() =>
      _KargoziniOvertimeFirstPageState();
}

class _KargoziniOvertimeFirstPageState extends State<KargoziniOvertimeFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "کاربر"),
    const Tab(text: "واحد"),
    const Tab(text: "همه"),
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
            KargoziniCheckOvertimePage(),
            kargoziniOvertimeUnitPage(),
            KargoziniOvertimeGetAllUserPage(),
          ],
        ),
      ),
    );
  }
}
