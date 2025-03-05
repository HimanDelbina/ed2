import 'package:flutter/material.dart';
import 'package:ed/pages/home/kargozini/leave/k_leave_user/kargozini_leave_select_user.dart';

import 'kargozini_leave_select_user_table.dart';

class KargoziniLeaveUserFirstpage extends StatefulWidget {
  int? user_id;
  KargoziniLeaveUserFirstpage({super.key, this.user_id});

  @override
  State<KargoziniLeaveUserFirstpage> createState() =>
      _KargoziniOvertimeSelectUserFirstpageState();
}

class _KargoziniOvertimeSelectUserFirstpageState
    extends State<KargoziniLeaveUserFirstpage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "نمایش داده ای"),
    const Tab(text: "نمایش جدولی"),
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
            KargoziniLeaveSelectUser(user_id: widget.user_id),
            KargoziniLeaveSelectUserTable(user_id: widget.user_id),
          ],
        ),
      ),
    );
  }
}
