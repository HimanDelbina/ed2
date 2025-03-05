import 'package:ed/pages/home/anbar/anbar_home_page.dart';
import 'package:flutter/material.dart';

import 'cartex/anbar_cartex_page.dart';
import 'cloth/anbar_cloth_page.dart';
import 'anbar_report_page.dart';

class AnbarFirstPage extends StatefulWidget {
  const AnbarFirstPage({super.key});

  @override
  State<AnbarFirstPage> createState() => _AnbarFirstPageState();
}

class _AnbarFirstPageState extends State<AnbarFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "درخواست کالا"),
    const Tab(text: "گزارش"),
    const Tab(text: "کارتکس"),
    const Tab(text: "لباس کار"),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
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
            AnbarHomePage(),
            AnbarReportPage(),
            AnbarCartexPage(),
            AnbarClothPage(),
          ],
        ),
      ),
    );
  }
}
