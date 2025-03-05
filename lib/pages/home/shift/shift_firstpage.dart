
import 'package:flutter/material.dart';

import '../../../static/helper_page.dart';
import 'change_shift.dart';
import 'create_shift.dart';
import 'move_shift.dart';
import 'report_shift.dart';
import 'shift_report/history_report_swap.dart';
import 'shift_request.dart';

class ShiftFirstPage extends StatefulWidget {
  const ShiftFirstPage({super.key});

  @override
  State<ShiftFirstPage> createState() => _ShiftFirstPageState();
}

class _ShiftFirstPageState extends State<ShiftFirstPage> {
  List? data = [
    {"id": 1, "title": "ایجاد شیفت", "icon": "assets/image/plus.png"},
    {"id": 2, "title": "تعویض شیفت", "icon": "assets/image/repost.png"},
    {"id": 3, "title": "درخواست ها", "icon": "assets/image/request.png"},
    {"id": 4, "title": "جا به جایی", "icon": "assets/image/move-right.png"},
    {"id": 5, "title": "گزارشات", "icon": "assets/image/report.png"},
    {"id": 5, "title": "تاریخچه", "icon": "assets/image/history.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: PagePadding.page_padding,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
          itemCount: data!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (data![index]['title'] == "ایجاد شیفت") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateShiftPage(),
                      ));
                } else if (data![index]['title'] == "تعویض شیفت") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeShiftPage(),
                      ));
                } else if (data![index]['title'] == "جا به جایی") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoveShiftPage(),
                      ));
                } else if (data![index]['title'] == "گزارشات") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportShiftPage(),
                      ));
                } else if (data![index]['title'] == "تاریخچه") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HistoryReportSwapShiftPage(),
                      ));
                } else if (data![index]['title'] == "درخواست ها") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShiftRequestPage(),
                      ));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(data![index]['icon'], height: 35.0),
                          Text(
                            data![index]['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
