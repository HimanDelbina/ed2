import 'package:flutter/material.dart';
import 'package:ed/pages/home/kargozini/money_box/kargozini_money_data.dart';
import 'kargozini_money_box.dart';

class MoneyFirstPage extends StatefulWidget {
  const MoneyFirstPage({super.key});

  @override
  State<MoneyFirstPage> createState() => _MoneyFirstPageState();
}

class _MoneyFirstPageState extends State<MoneyFirstPage>
 with SingleTickerProviderStateMixin  {
    TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "گزارش"),
    const Tab(text: "گزارش جدولی"),
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
            KargoziniMoneyBoxPage(),
            KargoziniMoneyData(),
          ],
        ),
      ),
    );
  }
}