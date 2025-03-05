import 'package:flutter/material.dart';
import 'package:ed/pages/home/shift/user/user_change_shift_report.dart';
import 'package:ed/pages/home/shift/user/user_shift_firstpage.dart';
import 'package:ed/static/helper_page.dart';

class UserShiftCheckPage extends StatefulWidget {
  const UserShiftCheckPage({super.key});

  @override
  State<UserShiftCheckPage> createState() => _UserShiftCheckPageState();
}

class _UserShiftCheckPageState extends State<UserShiftCheckPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "شیفت ها"),
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
            UserShiftFirstPage(),
            UserChangeShiftReportPage(),
          ],
        ),
      ),
    );
  }
}
