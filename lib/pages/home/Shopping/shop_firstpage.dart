
import 'package:flutter/material.dart';
import 'shop_create.dart';
import 'shop_report.dart';

class ShopFirstPage extends StatefulWidget {
  const ShopFirstPage({super.key});

  @override
  State<ShopFirstPage> createState() => _ShopFirstPageState();
}

class _ShopFirstPageState extends State<ShopFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست خرید"),
    const Tab(text: "گزارشات"),
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
            ShopCreate(),
            ShopReport(),
          ],
        ),
      ),
    );
  }
}
