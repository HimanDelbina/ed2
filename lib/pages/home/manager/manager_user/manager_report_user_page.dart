import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../models/all_check/all_data_model.dart';
import '../../../../static/helper_page.dart';

class ManagerReportUserPage extends StatefulWidget {
  const ManagerReportUserPage({super.key});

  @override
  State<ManagerReportUserPage> createState() => _ManagerReportUserPageState();
}

class _ManagerReportUserPageState extends State<ManagerReportUserPage> {
  int? id_user = 0;
  int? unit_id = 0;
  bool? is_manager;
  bool? is_salon_manager;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      unit_id = prefsUser.getInt("unit_id") ?? 0;
      is_manager = prefsUser.getBool("is_manager") ?? false;
      is_salon_manager = prefsUser.getBool("is_salon_manager") ?? false;
    });
    get_all_data_filter();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  String? url_select = "today";
  String? url_select_acc = "all";
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
        padding: PagePadding.page_padding,
        child: Column(
          children: [
            Container(
              width: my_width,
              child: Row(
                children: [
                  show_filter(
                    "امروز",
                    is_today,
                    () {
                      setState(() {
                        is_today = true;
                        is_month = false;
                        is_all = false;
                        is_accept = false;
                        is_reject = false;
                        get_data = false;
                        url_select = "today";
                        url_select_acc = "all";
                      });
                      get_all_data_filter();
                    },
                  ),
                  show_filter(
                    "این ماه",
                    is_month,
                    () {
                      setState(() {
                        is_today = false;
                        is_month = true;
                        is_all = false;
                        is_accept = false;
                        is_reject = false;
                        get_data = false;
                        url_select = "month";
                        url_select_acc = "all";
                      });
                      get_all_data_filter();
                    },
                  ),
                  show_filter(
                    "همه",
                    is_all,
                    () {
                      setState(() {
                        is_today = false;
                        is_month = false;
                        is_all = true;
                        is_accept = false;
                        is_reject = false;
                        get_data = false;
                        url_select = "all";
                        url_select_acc = "all";
                      });
                      get_all_data_filter();
                    },
                  ),
                  show_filter(
                    "تایید شده",
                    is_accept,
                    () {
                      setState(() {
                        is_today = false;
                        is_month = false;
                        is_all = false;
                        is_accept = true;
                        is_reject = false;
                        get_data = false;
                        url_select = "all";
                        url_select_acc = "approved";
                      });
                      get_all_data_filter();
                    },
                  ),
                  show_filter(
                    "تایید نشده",
                    is_reject,
                    () {
                      setState(() {
                        is_today = false;
                        is_month = false;
                        is_all = false;
                        is_accept = false;
                        is_reject = true;
                        get_data = false;
                        url_select = "all";
                        url_select_acc = "unapproved";
                      });
                      get_all_data_filter();
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: get_data!
                  ? ListView.builder(
                      itemCount: overtime_data!.length +
                          leave_data!.length +
                          food_data!.length +
                          anbar_data!.length,
                      itemBuilder: (context, index) {
                        if (index < overtime_data!.length) {
                          return _buildOvertimeItem(overtime_data![index]);
                        } else if (index <
                            overtime_data!.length + leave_data!.length) {
                          return _buildLeaveItem(
                              leave_data![index - overtime_data!.length]);
                        } else if (index <
                            overtime_data!.length +
                                leave_data!.length +
                                food_data!.length) {
                          return _buildFoodItem(food_data![index -
                              (overtime_data!.length + leave_data!.length)]);
                        } else {
                          return _buildAnbarItem(anbar_data![index -
                              (overtime_data!.length +
                                  leave_data!.length +
                                  food_data!.length)]);
                        }
                      },
                    )
                  : Center(
                      child: Lottie.asset("assets/lottie/loading.json",
                          height: 40.0)),
            ),
          ],
        ));
  }

  bool? is_today = true;
  bool? is_month = false;
  bool? is_all = false;
  bool? is_accept = false;
  bool? is_reject = false;

  Widget show_filter(String? title, bool? is_select, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 7.0),
        decoration: BoxDecoration(
          color: is_select! ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
                color: is_select ? Colors.white : Colors.black,
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget _buildOvertimeItem(Overtime overtime) {
    String dateTimeString = overtime.createAt!;
    String onlyDate = dateTimeString.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${overtime.user!.firstName} ${overtime.user!.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  "تاریخ درخواست : ${FormateDateCreateChange.formatDate(overtime.createAt!.toString())}")
            ],
          ),
          Divider(
              color: overtime.salonAccept! || overtime.managerAccept!
                  ? Colors.green
                  : Colors.red),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "درخواست : ${overtime.select! == "EZ" ? "اضافه کاری" : overtime.select! == "TA" ? "تعطیل کاری" : overtime.select! == "GO" ? "جمعه کاری" : overtime.select! == "MA" ? "ماموریت" : ""}"),
              overtime.isAccept!
                  ? Text(
                      "تایید توسط : ${overtime.salonAccept! ? "مدیر سالن" : "مدیر واحد"}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    )
                  : const Text("منتظر تایید",
                      style: TextStyle(color: Colors.red))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLeaveItem(Leave leave) {
    String dateTimeString = leave.createAt!;
    String onlyDate = dateTimeString.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${leave.user!.firstName} ${leave.user!.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  "تاریخ درخواست : ${FormateDateCreateChange.formatDate(leave.createAt!.toString())}")
            ],
          ),
          Divider(
              color: leave.salonAccept! || leave.managerAccept!
                  ? Colors.green
                  : Colors.red),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("درخواست مرخصی : ${leave.isClock! ? "ساعتی" : "روزانه"}"),
              leave.isAccept!
                  ? Text(
                      "تایید توسط : ${leave.salonAccept! ? "مدیر سالن" : "مدیر واحد"}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    )
                  : const Text("منتظر تایید",
                      style: TextStyle(color: Colors.red)),
            ],
          ),
          Text(leave.isClock!
              ? 'از ساعت ${leave.clockStartTime!.toPersianDigit()} تا ساعت ${leave.clockEndTime!.toPersianDigit()}'
              : 'از تاریخ ${leave.daysStartDate!.toPersianDigit()} تا تاریخ ${leave.daysEndDate!.toPersianDigit()}'),
          leave.isDays!
              ? const Text(
                  "مرحله دوم : مرخصی روزانه تاییده مدیر را میخواهد لطفا منتظر تاییدیه باشید .",
                  style: TextStyle(color: Colors.blue))
              : leave.finalAccept!
                  ? const Text("مرخصی تاییدیه نهایی شد .",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green))
                  : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Food food) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        // color: food.isAccept!
        //     ? Colors.green.withOpacity(0.1)
        //     : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${food.user!.firstName} ${food.user!.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  "تاریخ درخواست : ${FormateDateCreateChange.formatDate(food.createAt!.toString())}")
            ],
          ),
          Divider(
              color: food.salonAccept! || food.managerAccept!
                  ? Colors.green
                  : Colors.red),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "درخواست : ${food.lunchSelect! == "SO" ? "صبحانه" : food.lunchSelect! == "NA" ? "نهار" : food.lunchSelect! == "SH" ? "شام" : ""}"),
              food.isAccept!
                  ? Text(
                      "تایید توسط : ${food.salonAccept! ? "مدیر سالن" : "مدیر واحد"}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    )
                  : const Text("منتظر تایید",
                      style: TextStyle(color: Colors.red)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAnbarItem(Anbar anbar) {
    String dateTimeString = anbar.createAt!;
    String onlyDate = dateTimeString.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${anbar.user!.firstName} ${anbar.user!.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("تایید توسط"),
                anbar.isAccept!
                    ? Text(
                        anbar.salonAccept! ? "مدیر سالن" : "مدیر واحد",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      )
                    : const Text("منتظر تایید",
                        style: TextStyle(color: Colors.red)),
              ],
            )
          ],
        ),
        trailing: const Text(
          "کالا",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text("درخواست ها ")),
                Expanded(child: Divider()),
              ],
            ),
          ),
          ListView.builder(
            itemCount: anbar.commodities!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('${(index + 1).toString().toPersianDigit()} - '),
                        Text(anbar.commodities![index].name.toString()),
                      ],
                    ),
                    Text(
                        ' تعداد : ${anbar.commodities![index].count.toString().toPersianDigit()} ${anbar.commodities![index].unit}'),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  var leaveData;
  List? data_clock = [];
  List? overtime_data = [];
  List? leave_data = [];
  List? food_data = [];
  List? anbar_data = [];
  bool? get_data = false;

  Future get_all_data_filter() async {
    String infourl = Helper.url.toString() +
        'all_data/combined-data-report/?unit=' +
        unit_id.toString() +
        '&date_filter=' +
        url_select.toString() +
        '&status_filter=' +
        url_select_acc.toString() +
        "&manager_select=MV";
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(infourl);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      AllDataModel leaveData = AllDataModel.fromJson(jsonResponse);

      if (mounted) {
        setState(() {
          overtime_data = leaveData.overtime;
          leave_data = leaveData.leave;
          food_data = leaveData.food;
          anbar_data = leaveData.anbar;
          get_data = true;
        });
      }
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
