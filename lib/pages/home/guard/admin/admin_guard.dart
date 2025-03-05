import 'package:flutter/material.dart';
import 'package:ed/pages/home/guard/admin/a_guard_home_admin.dart';

import 'a_guard_request_admin.dart';
import 'a_guard_users_admin.dart';

class GuardAdminFirstPage extends StatefulWidget {
  const GuardAdminFirstPage({super.key});

  @override
  State<GuardAdminFirstPage> createState() => _GuardAdminFirstPageState();
}

class _GuardAdminFirstPageState extends State<GuardAdminFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست ها"),
    const Tab(text: "پرسنل"),
    const Tab(text: "دسترسی ها"),
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
            AdminGuardRequestAdmin(),
            AdminGuardUsersAdmin(),
            AdminGuardHomeAdmin(),
          ],
        ),
      ),
    );
  }
}
