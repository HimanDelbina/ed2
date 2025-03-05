import 'package:ed/pages/home/loan/loan_home.dart';
import 'package:ed/pages/home/loan/loan_report_page.dart';
import 'package:flutter/material.dart';

class LoanFirstPage extends StatefulWidget {
  const LoanFirstPage({super.key});

  @override
  State<LoanFirstPage> createState() => _LoanFirstPageState();
}

class _LoanFirstPageState extends State<LoanFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست وام"),
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
              LoanHomePage(),
              LoanReportPage(),
            ],
          ),
        ));
  }
}
