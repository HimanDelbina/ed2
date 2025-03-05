import 'package:flutter/material.dart';
import 'package:ed/pages/home/manage_anbar/cartex/cartex_select.dart';
import 'package:ed/pages/home/manage_anbar/cartex/cartex_select_table.dart';

class CartexSelectFirstPage extends StatefulWidget {
  int? user_id;
  CartexSelectFirstPage({super.key, this.user_id});

  @override
  State<CartexSelectFirstPage> createState() => _CartexSelectFirstPageState();
}

class _CartexSelectFirstPageState extends State<CartexSelectFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "گزارش داده ای"),
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

  String? onlyDate;
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
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
            children: [
              ManagerAnbarCartexSelect(user_id: widget.user_id),
              CartexSelecttablePage(user_id: widget.user_id),
            ],
          ),
        ));
  }
}
