import 'dart:convert';
import 'package:ed/models/leave/leave_two_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../static/helper_page.dart';

class UserReportPage extends StatefulWidget {
  const UserReportPage({super.key});

  @override
  State<UserReportPage> createState() => _UserReportPageState();
}

class _UserReportPageState extends State<UserReportPage> {
  int? id_user = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
    });
    // get_leave_by_user_id();
    get_two_leave_today_by_user_id();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  bool? is_today = true;
  bool? is_month = false;
  bool? is_all = false;
  bool? is_accept = false;
  bool? is_reject = false;
  int? leave_id = 0;

  String formattedDate = '';

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          children: [
            Container(
              width: my_width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  show_filter("امروز", is_today, () {
                    setState(() {
                      is_today = true;
                      is_month = false;
                      is_all = false;
                      is_accept = false;
                      is_reject = false;
                    });
                    get_two_leave_today_by_user_id();
                  }),
                  show_filter("این ماه", is_month, () {
                    setState(() {
                      is_today = false;
                      is_month = true;
                      is_all = false;
                      is_accept = false;
                      is_reject = false;
                    });
                    get_two_leave_month_by_user_id();
                  }),
                  show_filter("همه", is_all, () {
                    setState(() {
                      is_today = false;
                      is_month = false;
                      is_all = true;
                      is_accept = false;
                      is_reject = false;
                    });
                    get_leave_by_user_id();
                  }),
                  show_filter("تایید شده", is_accept, () {
                    setState(() {
                      is_today = false;
                      is_month = false;
                      is_all = false;
                      is_accept = true;
                      is_reject = false;
                    });
                    get_two_leave_accept_by_user_id();
                  }),
                  show_filter("تایید نشده", is_reject, () {
                    setState(() {
                      is_today = false;
                      is_month = false;
                      is_all = false;
                      is_accept = false;
                      is_reject = true;
                    });
                    get_two_leave_reject_by_user_id();
                  }),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: data_days!.length + data_clock!.length,
                itemBuilder: (context, index) {
                  if (index < data_days!.length) {
                    // نمایش leave_entries
                    var leave = data_days![index];
                    DateTime dateTime =
                        DateTime.parse(leave.createAt.substring(0, 19));
                    String formattedDate =
                        DateFormat('yyyy/MM/dd').format(dateTime);
                    return Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "مرخصی روزانه",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "تاریخ درخواست : ${formattedDate.toPersianDigit()}")
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "از تاریخ : ${leave.daysStartDate.toString().toPersianDigit()} - تا : ${leave.daysEndDate.toString().toPersianDigit()}"),
                              Text(
                                leave.isAccept ? "تایید شده" : "تایید نشده",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    color: leave.isAccept
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                " تعداد روزها : ${leave.totalDays.toString().toPersianDigit()}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                              Text(
                                leave.minusDate == 0
                                    ? "تمامی روزها محاسبه شده"
                                    : "${leave.minusDate.toString().toPersianDigit()} روز به دلیل تعطیلی از مرخصی کم شده",
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                          leave.isAccept ||
                                  leave.managerAccept ||
                                  leave.salonAccept
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      leave_id = leave.id;
                                    });
                                    delete_leave(leave_id);
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            vertical: 5.0, horizontal: 5.0),
                                    margin:
                                        const EdgeInsetsDirectional.symmetric(
                                            vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text.rich(
                                      TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "شما تا قبل از تایید میتوانید درخواست خود را لغو کنید : ",
                                              style: TextStyle(fontSize: 14.0)),
                                          TextSpan(
                                            text: 'حذف درخواست',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          leave.managerAccept || leave.salonAccept
                              ? const Divider(indent: 10.0, endIndent: 10.0)
                              : const SizedBox(),
                          Text(
                              "مرخصی روزانه تاییدیه ${2.toString().toPersianDigit()} لازم دارد ."),
                          leave.managerAccept || leave.salonAccept
                              ? Text(
                                  "مرحله اول : ${leave.managerAccept ? "درخواست شما توسط مدیر واحدتان تایید شد" : "درخواست شما توسط مدیر سالن تایید شد"}")
                              : const SizedBox(),
                          leave.finalAccept
                              ? const Text(
                                  "مرحله دوم :  درخواست شما توسط مدیر تایید شد")
                              : const SizedBox(),
                        ],
                      ),
                    );
                  } else {
                    // نمایش leave_data_clock
                    var leaveClock = data_clock![index - data_days!.length];
                    DateTime dateTime =
                        DateTime.parse(leaveClock.createAt.substring(0, 19));
                    String formattedDate =
                        DateFormat('yyyy/MM/dd').format(dateTime);

                    return Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "مرخصی ساعتی",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "تاریخ درخواست : ${formattedDate.toPersianDigit()}"),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "از ساعت : ${leaveClock.clockStartTime.toString().toPersianDigit()} تا ${leaveClock.clockEndTime.toString().toPersianDigit()} در تاریخ ${FormateDateCreateChange.formatDate(leaveClock.clockLeaveDate.toString())}"),
                              Text(
                                leaveClock.isAccept
                                    ? "تایید شده"
                                    : "تایید نشده",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                    color: leaveClock.isAccept
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                          leaveClock.isAccept ||
                                  leaveClock.managerAccept ||
                                  leaveClock.salonAccept
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      leave_id = leaveClock.id;
                                    });
                                    delete_leave(leave_id);
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            vertical: 5.0, horizontal: 5.0),
                                    margin:
                                        const EdgeInsetsDirectional.symmetric(
                                            vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text.rich(
                                      TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text:
                                                  "شما تا قبل از تایید میتوانید درخواست خود را لغو کنید : ",
                                              style: TextStyle(fontSize: 14.0)),
                                          TextSpan(
                                            text: 'حذف درخواست',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          leaveClock.finalTime >= 4.0
                              ? const Divider()
                              : const SizedBox(),
                          leaveClock.finalTime >= 4.0
                              ? Text(
                                  "مرخصی ساعتی شما چون بیشتر از ${4.toString().toPersianDigit()} ساعت است در صورت تایید به عنوان مرخصی روزانه محاسبه میشود",
                                  style: const TextStyle(color: Colors.blue))
                              : const SizedBox()
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            const Divider(),
            Container(
              width: my_width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " مجموع مرخصی های روزانه : ${totalDaysSum.toString().toPersianDigit()} روز ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${dayToClock.toString().toPersianDigit()} ساعت",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        " مجموع مرخصی های ساعتی :: ${sumData.toString().toPersianDigit()} ساعت",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${clockToDay.toString().toPersianDigit()} روز",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "مجموع کل مرخصی های ( به ساعت ) :  ${sumAllClock.toString().toPersianDigit()} ساعت",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "مجموع کل مرخصی های ( به روز ) :  ${sumAllDay.toString().toPersianDigit()} روز",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

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

  var leaveData;
  List? data = [];
  List? data_days = [];
  List? data_clock = [];
  double? sumData;
  double? dayToClock = 0.0;
  double? clockToDay = 0.0;
  double? sumAllClock = 0.0;
  double? sumAllDay = 0.0;
  int? totalDaysSum;
  Future get_leave_by_user_id() async {
    String infourl =
        Helper.url.toString() + 'leave/get_two_leave/' + id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      LeaveTwoModel leaveData = LeaveTwoModel.fromJson(jsonResponse);
      setState(() {
        data_days = leaveData.leaveEntries;
        data_clock = leaveData.leaveDataClock;
        sumData = leaveData.sumData;
        totalDaysSum = leaveData.totalDaysSum;
        dayToClock = leaveData.dayToClock;
        clockToDay = leaveData.clockToDay;
        sumAllClock = leaveData.sumAllClock;
        sumAllDay = leaveData.sumAllDay;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future get_two_leave_today_by_user_id() async {
    String infourl = Helper.url.toString() +
        'leave/get_two_leave_today/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      LeaveTwoModel leaveData = LeaveTwoModel.fromJson(jsonResponse);
      setState(() {
        data_days = leaveData.leaveEntries;
        data_clock = leaveData.leaveDataClock;
        sumData = leaveData.sumData;
        totalDaysSum = leaveData.totalDaysSum;
        dayToClock = leaveData.dayToClock;
        clockToDay = leaveData.clockToDay;
        sumAllClock = leaveData.sumAllClock;
        sumAllDay = leaveData.sumAllDay;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future get_two_leave_accept_by_user_id() async {
    String infourl = Helper.url.toString() +
        'leave/get_two_leave_accept/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      LeaveTwoModel leaveData = LeaveTwoModel.fromJson(jsonResponse);
      setState(() {
        data_days = leaveData.leaveEntries;
        data_clock = leaveData.leaveDataClock;
        sumData = leaveData.sumData;
        totalDaysSum = leaveData.totalDaysSum;
        dayToClock = leaveData.dayToClock;
        clockToDay = leaveData.clockToDay;
        sumAllClock = leaveData.sumAllClock;
        sumAllDay = leaveData.sumAllDay;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future get_two_leave_reject_by_user_id() async {
    String infourl = Helper.url.toString() +
        'leave/get_two_leave_reject/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      LeaveTwoModel leaveData = LeaveTwoModel.fromJson(jsonResponse);
      setState(() {
        data_days = leaveData.leaveEntries;
        data_clock = leaveData.leaveDataClock;
        sumData = leaveData.sumData;
        totalDaysSum = leaveData.totalDaysSum;
        dayToClock = leaveData.dayToClock;
        clockToDay = leaveData.clockToDay;
        sumAllClock = leaveData.sumAllClock;
        sumAllDay = leaveData.sumAllDay;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future get_two_leave_month_by_user_id() async {
    String infourl = Helper.url.toString() +
        'leave/get_two_leave_month/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      LeaveTwoModel leaveData = LeaveTwoModel.fromJson(jsonResponse);
      setState(() {
        data_days = leaveData.leaveEntries;
        data_clock = leaveData.leaveDataClock;
        sumData = leaveData.sumData;
        totalDaysSum = leaveData.totalDaysSum;
        dayToClock = leaveData.dayToClock;
        clockToDay = leaveData.clockToDay;
        sumAllClock = leaveData.sumAllClock;
        sumAllDay = leaveData.sumAllDay;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future delete_leave(int? id) async {
    String infourl =
        Helper.url.toString() + 'leave/delete_leave_by_id/' + id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت حذف شد", 1);
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
