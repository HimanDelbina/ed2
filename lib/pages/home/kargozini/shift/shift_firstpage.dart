// import 'package:test_ed/pages/home/kargozini/shift/create_shift.dart';
// import 'package:test_ed/pages/home/kargozini/shift/report_shift_unit.dart';
// import 'package:test_ed/pages/home/kargozini/shift/report_shift_user.dart';
// import 'package:flutter/material.dart';

// class ShiftFirstPage extends StatefulWidget {
//   const ShiftFirstPage({super.key});

//   @override
//   State<ShiftFirstPage> createState() => _ShiftFirstPageState();
// }

// class _ShiftFirstPageState extends State<ShiftFirstPage>
//     with SingleTickerProviderStateMixin {
//   TabController? tabController;
//   final List<Tab> topTabs = <Tab>[
//     const Tab(text: "ایجاد شیفت"),
//     const Tab(text: "گزارش کاربران"),
//     const Tab(text: "گزارش واحد ها"),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(vsync: this, length: 3);
//   }

//   @override
//   void dispose() {
//     tabController!.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           toolbarHeight: 10,
//           bottom: TabBar(
//             controller: tabController,
//             indicatorColor: Colors.blueGrey,
//             indicatorSize: TabBarIndicatorSize.tab,
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.grey,
//             labelStyle: const TextStyle(
//                 fontWeight: FontWeight.bold, fontFamily: "Vazir"),
//             tabs: topTabs,
//           ),
//         ),
//         body: TabBarView(
//           controller: tabController,
//           children: const [
//             CreateShiftPage(),
//             ReportShiftUser(),
//             ReportShiftUnit(),
//           ],
//         ),
//       ),
//     );
//   }
// }
