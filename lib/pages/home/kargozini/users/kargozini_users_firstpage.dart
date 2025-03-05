import 'package:flutter/material.dart';
import 'package:ed/pages/home/kargozini/users/kargozini_user_all.dart';
import 'package:ed/pages/home/kargozini/users/kargozini_user_mahtab.dart';

import 'kargozini_user_sadaf.dart';

class KargoziniUsersFirstPage extends StatefulWidget {
  const KargoziniUsersFirstPage({super.key});

  @override
  State<KargoziniUsersFirstPage> createState() =>
      _KargoziniUsersFirstPageState();
}

class _KargoziniUsersFirstPageState extends State<KargoziniUsersFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "همه"),
    const Tab(text: "مهتاب"),
    const Tab(text: "صدف"),
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
            KargoziniUserAllPage(),
            KargoziniUserMahtabPage(),
            KargoziniUserSadafPage(),
          ],
        ),
      ),
    );
  }
}
