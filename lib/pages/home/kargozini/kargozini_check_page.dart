import 'dart:async';
import 'dart:convert';
import 'package:ed/models/fund/count_fund_model.dart';
import 'package:ed/pages/home/kargozini/all_check/kargozini_all_check_page.dart';
import 'package:ed/pages/home/kargozini/gharardad/gharardad_firstpage.dart';
import 'package:ed/pages/home/kargozini/leave/k_leave_firstpage.dart';
import 'package:ed/pages/home/kargozini/money_box/money_firstpage.dart';
import 'package:ed/pages/home/kargozini/overtime/k_overtime_firstpage.dart';
import 'package:ed/pages/home/kargozini/request/request_first_page.dart';
import 'package:ed/pages/home/kargozini/sms/sms_firstpage.dart';
import 'package:ed/pages/home/kargozini/users/kargozini_users_firstpage.dart';
import 'package:ed/pages/home/shift/shift_firstpage.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../components/count_widget.dart';
import 'message/send_message_firstpage.dart';

class KargoziniCheckPage extends StatefulWidget {
  const KargoziniCheckPage({super.key});

  @override
  State<KargoziniCheckPage> createState() => _KargoziniCheckPageState();
}

class _KargoziniCheckPageState extends State<KargoziniCheckPage> {
  List? data = [
    {"id": 1, "title": "مرخصی", "icon": "assets/image/leave.png"},
    {"id": 2, "title": "حقوق", "icon": "assets/image/money.png"},
    {"id": 3, "title": "اضافه کاری", "icon": "assets/image/calendar.png"},
    {"id": 4, "title": "قرارداد", "icon": "assets/image/contract.png"},
    {"id": 5, "title": "چک کامل", "icon": "assets/image/app.png"},
    {"id": 6, "title": "کاربران", "icon": "assets/image/team.png"},
    {"id": 7, "title": "صندوق ذخیره", "icon": "assets/image/charity.png"},
    {"id": 8, "title": "دزخواست ها", "icon": "assets/image/request.png"},
    {"id": 9, "title": "پیام ها", "icon": "assets/image/chat.png"},
    {"id": 10, "title": "اس ام اس", "icon": "assets/image/sms.png"},
    {"id": 11, "title": "شیفت", "icon": "assets/image/shift.png"},
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
    timer?.cancel(); // متوقف کردن تایمر هنگام خارج شدن از صفحه
    super.dispose();
  }

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
                if (data![index]['title'] == "مرخصی") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KargoziniLeaveFirstPage(),
                      ));
                } else if (data![index]['title'] == "کاربران") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KargoziniUsersFirstPage(),
                      ));
                } else if (data![index]['title'] == "قرارداد") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GharadadFirstPage(),
                      ));
                } else if (data![index]['title'] == "اضافه کاری") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const KargoziniOvertimeFirstPage(),
                      ));
                } else if (data![index]['title'] == "چک کامل") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KargoziniAllCheckPage(),
                      ));
                } else if (data![index]['title'] == "حقوق") {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const KargoziniStipendpage(),
                  //     ));
                } else if (data![index]['title'] == "صندوق ذخیره") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoneyFirstPage(),
                      ));
                } else if (data![index]['title'] == "دزخواست ها") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestFirstPage(),
                      ));
                } else if (data![index]['title'] == "پیام ها") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SendMessageFirstPage(),
                      ));
                } else if (data![index]['title'] == "اس ام اس") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SmsFirstPage(),
                      ));
                } else if (data![index]['title'] == "شیفت") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShiftFirstPage(),
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
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
