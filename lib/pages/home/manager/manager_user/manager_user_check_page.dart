import 'package:ed/pages/home/manager/manager_user/manager_report_user_page.dart';
import 'package:ed/pages/home/manager/manager_user/manager_users_page.dart';
import 'package:flutter/material.dart';

import 'manager_request_user_page.dart';

class ManagerUserCheckPage extends StatefulWidget {
  const ManagerUserCheckPage({super.key});

  @override
  State<ManagerUserCheckPage> createState() => _ManagerUserCheckPageState();
}

class _ManagerUserCheckPageState extends State<ManagerUserCheckPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست ها"),
    const Tab(text: "گزارش ها"),
    const Tab(text: "کارمندان"),
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
            ManagerRequestUserPage(),
            ManagerReportUserPage(),
            ManagerUsersPage(),
          ],
        ),
      ),
    );
  }
}
