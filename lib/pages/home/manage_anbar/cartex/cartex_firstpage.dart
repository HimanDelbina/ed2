import 'package:flutter/material.dart';

import 'cartex_add.dart';
import 'cartex_select.dart';
import 'cartex_users.dart';

class ManagerAnbarCartex extends StatefulWidget {
  const ManagerAnbarCartex({super.key});

  @override
  State<ManagerAnbarCartex> createState() => _ManagerAnbarCartexState();
}

class _ManagerAnbarCartexState extends State<ManagerAnbarCartex>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "ایجاد ابزار"),
    const Tab(text: "کارمندان"),
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
              ManagerAnbarCartexAdd(),
              ManagerAnbarCartexUsers(),
            ],
          ),
        ));
  }
}
