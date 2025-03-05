import 'dart:async';
import 'dart:convert';
import 'package:ed/pages/home/admin_page/report_all/chart_data/all_report_firstpage.dart';
import 'package:ed/pages/home/admin_page/check_page/request/request_first_page.dart';
import 'package:ed/pages/home/admin_page/guard/a_guard_firstpage.dart';
import 'package:ed/pages/home/admin_page/report_all/admin_all_report_firstpage.dart';
import 'package:ed/pages/home/entry_exit/entry_firstpage.dart';
import 'package:ed/pages/home/kargozini/gharardad/gharardad_firstpage.dart';
import 'package:ed/pages/home/kargozini/leave/k_leave_firstpage.dart';
import 'package:ed/pages/home/leave_count/leave_count_firstpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ed/pages/home/kargozini/money_box/money_firstpage.dart';
import 'package:ed/pages/home/kargozini/overtime/k_overtime_firstpage.dart';
import 'package:ed/pages/home/kargozini/phone_admin/phone_admin_firstpage.dart';
import 'package:ed/pages/home/letter/letter_firstpage.dart';
import '../../../../components/count_widget.dart';
import '../../../../models/fund/count_fund_model.dart';
import '../../../../static/helper_page.dart';
import '../../kargozini/all_check/kargozini_all_check_page.dart';
import '../../kargozini/message/send_message_firstpage.dart';
import '../../kargozini/sms/sms_firstpage.dart';
import '../../kargozini/unit/unit_manager_firstpage.dart';
import '../../kargozini/users/kargozini_users_firstpage.dart';
import '../../shift/shift_firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class AdminCheckPageFirst extends StatefulWidget {
  const AdminCheckPageFirst({super.key});

  @override
  State<AdminCheckPageFirst> createState() => _AdminCheckPageFirstState();
}

class _AdminCheckPageFirstState extends State<AdminCheckPageFirst> {
  List? data = [];
  var adminAccess;
  String? accessString;
  List<dynamic>? accessList;
  bool? is_check_all = false;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      adminAccess =
          prefsUser.getString("admin_access"); // adminAccess could be null

      if (adminAccess != null && adminAccess.isNotEmpty) {
        accessString = adminAccess;
        accessList = jsonDecode(accessString!); // Now safe to use jsonDecode
        data = accessList;
        is_check_all = true;
      } else {
        is_check_all = false;
        accessList = [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
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
    return Scaffold(
      body: Padding(
        padding: PagePadding.page_padding,
        child: is_check_all!
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0),
                itemCount: data?.length ?? 0,
                itemBuilder: (context, index) {
                  String name = data![index]['name'] != null
                      ? utf8.decode(data![index]['name'].codeUnits)
                      : '';
                  return GestureDetector(
                    onTap: () {
                      if (name == "مرخصی") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const KargoziniLeaveFirstPage()));
                      } else if (name == "کاربران") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const KargoziniUsersFirstPage()));
                      } else if (name == "قرارداد") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GharadadFirstPage()));
                      } else if (name == "اضافه کاری") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const KargoziniOvertimeFirstPage()));
                      } else if (name == "چک کامل") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const KargoziniAllCheckPage()));
                      } else if (name == "حقوق") {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const KargoziniStipendpage()));
                      } else if (name == "صندوق ذخیره") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MoneyFirstPage()));
                      } else if (name == "درخواست ها") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ManagerRequestFirstPage()));
                      } else if (name == "پیام ها") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SendMessageFirstPage(),
                            ));
                      } else if (name == "اس ام اس") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SmsFirstPage(),
                            ));
                      } else if (name == "شیفت") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShiftFirstPage(),
                            ));
                      } else if (name == "نگهبانی") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminGuardFirstPage(),
                            ));
                      } else if (name == "نامه نگاری") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LetterFirstPage(),
                            ));
                      } else if (name == "ورود و خروج") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EntryFirstPage(),
                            ));
                      } else if (name == "شماره های داخلی") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PhoneAdminFirstPage(),
                            ));
                      } else if (name == "واحد ها") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UnitManagerFirstPage(),
                            ));
                      } else if (name == "گزارشات") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminAllReportFirstPage(),
                            ));
                      } else if (name == "روزهای مرخصی") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeaveCountFirstPage(),
                            ));
                      } else if (name == "گزارش کامل") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllReportFirstPage(),
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
                                  name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          data![index]['name'] == "درخواست ها"
                              ? count_all == 0
                                  ? const SizedBox()
                                  : BadgeWidget(
                                      child:
                                          Icon(Icons.notifications, size: 20),
                                      value: count_all!)
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Lottie.asset("assets/lottie/loading.json", height: 40.0),
              ),
      ),
    );
  }

  Timer? timer;
  int? count_loan = 0;
  int? count_shop = 0;
  int? count_user = 0;
  int? count_all = 0;
  bool? is_get_data = false;
  Future<void> get_count_fund() async {
    String infourl =
        Helper.url.toString() + 'all_data/get_all_count_request_admin';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      CountFundModel recive_data = CountFundModel.fromJson(json.decode(x));
      setState(() {
        count_loan = recive_data.loanCount;
        count_shop = recive_data.shopCount;
        count_user = recive_data.userCount;
        count_all = recive_data.sumCount;
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
