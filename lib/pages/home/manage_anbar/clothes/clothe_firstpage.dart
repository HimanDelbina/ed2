import 'package:ed/pages/home/manage_anbar/clothes/clothe_add.dart';
import 'package:ed/pages/home/manage_anbar/clothes/clothe_users.dart';
import 'package:flutter/material.dart';

class ManagerAnbarClothe extends StatefulWidget {
  const ManagerAnbarClothe({super.key});

  @override
  State<ManagerAnbarClothe> createState() => _ManagerAnbarClotheState();
}

class _ManagerAnbarClotheState extends State<ManagerAnbarClothe>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "لباس کار جدید"),
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
              ClothesAddPage(),
              ClotheUsers(),
            ],
          ),
        ));
  }
}
