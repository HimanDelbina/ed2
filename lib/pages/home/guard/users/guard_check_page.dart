import 'dart:async';
import 'dart:convert';
import 'package:ed/pages/home/guard/users/commodity/export/export_firstpage.dart';
import 'package:ed/pages/home/guard/users/commodity/import/import_firstpage.dart';
import 'package:ed/pages/home/guard/users/register/register_firstpage.dart';
import 'package:ed/pages/home/guard/users/shift/guard_shift.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../components/count_widget.dart';
import '../../../../models/fund/count_fund_model.dart';
import '../../../../static/helper_page.dart';

class GuardCheckPage extends StatefulWidget {
  const GuardCheckPage({super.key});

  @override
  State<GuardCheckPage> createState() => _GuardCheckPageState();
}

class _GuardCheckPageState extends State<GuardCheckPage> {
  List? data = [
    {"id": 1, "title": "شیفت ها", "icon": "assets/image/shift.png"},
    {"id": 2, "title": "ورود کالا", "icon": "assets/image/import.png"},
    {"id": 3, "title": "خروج کالا", "icon": "assets/image/export.png"},
    {"id": 4, "title": "مراجعین", "icon": "assets/image/register.png"},
  ];

  @override
  void initState() {
    super.initState();
    get_count_fund();
    timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => get_count_fund());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: data!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (data![index]['title'] == "شیفت ها") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuardShift(),
                    ));
              } else if (data![index]['title'] == "ورود کالا") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImportCommodityFirstPage(),
                    ));
              } else if (data![index]['title'] == "خروج کالا") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExportCommodityFirstPage(),
                    ));
              } else if (data![index]['title'] == "مراجعین") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuardRegisterFirstPage(),
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
                  data![index]['id'] == 8
                      ? count_all == 0
                          ? const SizedBox()
                          : BadgeWidget(
                              child: Icon(Icons.notifications, size: 20),
                              value: count_all!)
                      : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Timer? timer;
  int? count_fund = 0;
  int? count_loan = 0;
  int? count_all = 0;
  bool? is_get_data = false;
  Future<void> get_count_fund() async {
    String infourl = Helper.url.toString() + 'loan/get_all_count_request';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      CountFundModel recive_data = CountFundModel.fromJson(json.decode(x));
      setState(() {
        count_loan = recive_data.loanCount;
        count_fund = recive_data.fundCount;
        count_all = recive_data.sumCount;
        is_get_data = true;
      });
      print(count_fund);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
