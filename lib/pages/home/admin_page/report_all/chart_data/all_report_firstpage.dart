import 'package:ed/pages/home/admin_page/report_all/anbar/report_all_admin_anbar.dart';
import 'package:ed/pages/home/admin_page/report_all/guard/guard_report_all.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';

import 'overtime_all_data/user_all_report_overtime.dart';

class AllReportFirstPage extends StatefulWidget {
  const AllReportFirstPage({super.key});

  @override
  State<AllReportFirstPage> createState() => _AllReportFirstPageState();
}

class _AllReportFirstPageState extends State<AllReportFirstPage> {
  List data = [
    {"name": "انبار", "image": "assets/image/warehouse.png"},
    {"name": "اضافه کاری ها", "image": "assets/image/calendar.png"},
    {"name": "نگهبانی", "image": "assets/image/shield.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (data[index]['name'] == "اضافه کاری ها") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserAllReportOvertime(),
                        ));
                  } else if (data[index]['name'] == "انبار") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportAllAdminAnbar(),
                        ));
                  } else if (data[index]['name'] == "نگهبانی") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GuardReportAll(),
                        ));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(data[index]["image"].toString(),
                          height: 40.0),
                      Text(
                        data[index]['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
