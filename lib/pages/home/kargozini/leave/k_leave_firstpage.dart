import 'package:ed/pages/home/kargozini/leave/all/k_leave_all.dart';
import 'package:ed/pages/home/kargozini/leave/unit/k_leave_unit.dart';
import 'package:ed/pages/home/kargozini/leave/k_leave_user/kargozini_check_leave_page.dart';
import 'package:flutter/material.dart';

class KargoziniLeaveFirstPage extends StatefulWidget {
  const KargoziniLeaveFirstPage({super.key});

  @override
  State<KargoziniLeaveFirstPage> createState() =>
      _KargoziniLeaveFirstPageState();
}

class _KargoziniLeaveFirstPageState extends State<KargoziniLeaveFirstPage>
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
            KargoziniCheckLeavePage(),
            kargoziniLeaveUnitPage(),
            KargoziniLeaveAll(),
          ],
        ),
      ),
    );
  }
}
