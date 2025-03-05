import 'package:flutter/material.dart';

import 'kargozini_overtime_select.dart';
import 'kargozini_overtime_select_data.dart';

class KargoziniOvertimeSelectUserFirstpage extends StatefulWidget {
  int? user_id;
  KargoziniOvertimeSelectUserFirstpage({super.key, this.user_id});

  @override
  State<KargoziniOvertimeSelectUserFirstpage> createState() =>
      _KargoziniOvertimeSelectUserFirstpageState();
}

class _KargoziniOvertimeSelectUserFirstpageState
    extends State<KargoziniOvertimeSelectUserFirstpage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "نمایش جدولی"),
    const Tab(text: "نمایش داده ای"),
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
          children: [
            KargoziniOvertimeSelectExcelPage(user_id: widget.user_id),
            KargoziniOvertimeSelectDataPage(user_id: widget.user_id),
          ],
        ),
      ),
    );
  }
}
