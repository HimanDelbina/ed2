import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';

import 'admin_all_report.dart';

class AdminAllReportFirstPage extends StatefulWidget {
  const AdminAllReportFirstPage({super.key});

  @override
  State<AdminAllReportFirstPage> createState() => _AdminAllReportPageState();
}

class _AdminAllReportPageState extends State<AdminAllReportFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController; // تعریف TabController

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(vsync: this, length: 4); // تنظیمات TabController
  }

  @override
  void dispose() {
    tabController!.dispose(); // آزادسازی منابع
    super.dispose();
  }

  final List<Tab> topTabs = <Tab>[
    const Tab(text: "همه"),
    const Tab(text: "خرید"),
    const Tab(text: "وام"),
    const Tab(text: "کاربران"),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
            AdminAllReportPage(),
            AdminAllReportPage(),
            AdminAllReportPage(),
            AdminAllReportPage(),
          ],
        ),
      ),
    );
  }
}
