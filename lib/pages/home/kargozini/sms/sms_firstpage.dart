import 'package:ed/pages/home/kargozini/sms/sms_send.dart';
import 'package:ed/pages/home/kargozini/sms/sms_send_unit.dart';
import 'package:flutter/material.dart';
import 'package:ed/pages/home/kargozini/sms/sms_unitAdmin.dart';
import 'sms_all_send.dart';

class SmsFirstPage extends StatefulWidget {
  const SmsFirstPage({super.key});

  @override
  State<SmsFirstPage> createState() => _SmsFirstPageState();
}

class _SmsFirstPageState extends State<SmsFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  final List<Tab> topTabs = <Tab>[
    const Tab(text: "ارسال به همه"),
    const Tab(text: "ارسال به کاربر"),
    const Tab(text: "ارسال به واحد"),
    const Tab(text: "ارسال به سرپرستان"),
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
            SmsAllSend(),
            SmsSend(),
            SendSmsUnit(),
            SmsUnitAdminPage(),
          ],
        ),
      ),
    );
  }
}
