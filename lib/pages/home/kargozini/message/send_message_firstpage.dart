import 'package:ed/pages/home/kargozini/message/send_all_message.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';

import 'send_message.dart';

class SendMessageFirstPage extends StatefulWidget {
  const SendMessageFirstPage({super.key});

  @override
  State<SendMessageFirstPage> createState() => _SendMessageFirstPageState();
}

class _SendMessageFirstPageState extends State<SendMessageFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "ارسال به همه"),
    const Tab(text: "ارسال به کاربر"),
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
            SendAllMessage(),
            SendMessagePage(),
          ],
        ),
      ),
    );
  }
}
