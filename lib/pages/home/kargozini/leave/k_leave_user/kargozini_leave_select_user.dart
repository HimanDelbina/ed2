import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../../models/leave/leave_two_model.dart';

class KargoziniLeaveSelectUser extends StatefulWidget {
  int? user_id;
  KargoziniLeaveSelectUser({super.key, this.user_id});

  @override
  State<KargoziniLeaveSelectUser> createState() =>
      _KargoziniLeaveSelectUserState();
}

class _KargoziniLeaveSelectUserState extends State<KargoziniLeaveSelectUser> {
  @override
  void initState() {
    super.initState();
    get_all_leave_kargozini();
    get_month_data();
    current_month = date_now!.month.toString();
    current_year = date_now!.year.toString();
    filter_month = current_month;
    filter_year = current_year;
  }

  void get_month_data() {
    setState(() {
      month = now.month.toString();
      month_int = int.parse(month!);
      finalClockthismonth = (month_int! * 7.20) - 187.2;
      finalDaythismonth = (month_int! / 2.16) - ((12 - month_int!) * 2.16);
    });
  }

  String? month;
  int? month_int;
  bool? is_month = true;

  Jalali now = Jalali.now();
  Jalali? date_now = Jalali.now();
  String? current_month;
  String? current_year;
  bool? is_leave_month = false;
  bool? is_leave_all = true;

  int? shamsi_month_select = 0;
  int? select_month_data;
  bool? is_all_filter = true;
  String? all_filter = "all";
  String? filter_month;
  String? filter_year;
  String? start_date;
  String? end_date;
  bool? is_start_date = false;
  bool? is_end_date = false;

  Jalali? pickedStartDate = Jalali.now();
  String? date_start_select = "";
  Jalali? pickedEndDate = Jalali.now();
  String? date_end_select = "";
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      show_filter(
                        "همه",
                        is_leave_all,
                        () {
                          setState(() {
                            is_leave_all = true;
                            is_leave_month = false;
                            is_all_filter = true;
                            is_start_date = false;
                            is_end_date = false;
                          });
                          get_all_leave_kargozini();
                        },
                      ),
                      show_filter(
                        "این ماه",
                        is_leave_month,
                        () {
                          setState(() {
                            is_leave_all = false;
                            is_leave_month = true;
                            is_all_filter = false;
                            current_month = date_now!.month.toString();
                            current_year = date_now!.year.toString();
                            is_start_date = false;
                            is_end_date = false;
                          });
                          get_all_leave_kargozini();
                        },
                      ),
                    ],
                  ),
                  month_select()
                ],
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text("از تاریخ : "),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          is_leave_all = false;
                          is_leave_month = false;
                          is_all_filter = false;
                          is_start_date = true;
                        });
                        pickedStartDate = await showModalBottomSheet<Jalali>(
                          context: context,
                          builder: (context) {
                            Jalali? tempPickedDate;
                            return Container(
                              height: 250,
                              color: Colors.blue,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CupertinoButton(
                                          child: const Text(
                                            'لغو',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoButton(
                                          child: const Text(
                                            'تایید',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                tempPickedDate ?? Jalali.now());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 0, thickness: 1),
                                  Expanded(
                                    child: Container(
                                      child: PCupertinoDatePicker(
                                        mode: PCupertinoDatePickerMode.date,
                                        onDateTimeChanged: (Jalali dateTime) {
                                          tempPickedDate = dateTime;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        if (pickedStartDate != null) {
                          setState(() {
                            date_start_select =
                                '${pickedStartDate!.toDateTime()}';
                            start_date = pickedStartDate!
                                .toGregorian()
                                .toDateTime()
                                .toIso8601String()
                                .toPersianDate()
                                .toEnglishDigit();
                          });
                          print(start_date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10.0),
                        margin: const EdgeInsets.symmetric(horizontal: 7.0),
                        decoration: BoxDecoration(
                          color: is_start_date!
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            date_start_select == ""
                                ? "انتخاب تاریخ"
                                : pickedStartDate!
                                    .toGregorian()
                                    .toDateTime()
                                    .toIso8601String()
                                    .toPersianDate(),
                            style: TextStyle(
                              color:
                                  is_start_date! ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text("تا تاریخ : "),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          is_leave_all = false;
                          is_leave_month = false;
                          is_all_filter = false;
                          is_end_date = true;
                        });
                        pickedEndDate = await showModalBottomSheet<Jalali>(
                          context: context,
                          builder: (context) {
                            Jalali? tempPickedDate;
                            return Container(
                              height: 250,
                              color: Colors.blue,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CupertinoButton(
                                          child: const Text(
                                            'لغو',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoButton(
                                          child: const Text(
                                            'تایید',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                tempPickedDate ?? Jalali.now());
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 0, thickness: 1),
                                  Expanded(
                                    child: Container(
                                      child: PCupertinoDatePicker(
                                        mode: PCupertinoDatePickerMode.date,
                                        onDateTimeChanged: (Jalali dateTime) {
                                          tempPickedDate = dateTime;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        if (pickedEndDate != null) {
                          setState(() {
                            date_end_select = '${pickedEndDate!.toDateTime()}';
                            end_date = pickedEndDate!
                                .toGregorian()
                                .toDateTime()
                                .toIso8601String()
                                .toPersianDate()
                                .toEnglishDigit();
                          });
                          // print(end_date);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 10.0),
                        margin: const EdgeInsets.symmetric(horizontal: 7.0),
                        decoration: BoxDecoration(
                          color: is_end_date!
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                          child: Text(
                            date_end_select == ""
                                ? "انتخاب تاریخ"
                                : pickedEndDate!
                                    .toGregorian()
                                    .toDateTime()
                                    .toIso8601String()
                                    .toPersianDate(),
                            style: TextStyle(
                              color: is_end_date! ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      if (is_start_date! && is_end_date!) {
                        get_all_leave_kargozini();
                      } else if (is_start_date!) {
                        MyMessage.mySnackbarMessage(
                            context, "لطفا اول تاریخ پایان را انتخاب کنید", 1);
                      } else if (is_end_date!) {
                        MyMessage.mySnackbarMessage(
                            context, "لطفا اول تاریخ شروع را انتخاب کنید", 1);
                      } else {
                        MyMessage.mySnackbarMessage(
                            context, "لطفا اول تاریخ ها را انتخاب کنید", 1);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 10.0),
                      margin: const EdgeInsets.symmetric(horizontal: 7.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: const Center(
                        child: Text(
                          "تایید",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
              ],
            ),
            const Divider(),
            Expanded(
              child: get_data! == false
                  ? Center(
                      child: Lottie.asset("assets/lottie/loading.json",
                          height: 40.0))
                  : ListView.builder(
                      itemCount: data_days!.length + data_clock!.length,
                      itemBuilder: (context, index) {
                        if (index < data_days!.length) {
                          // نمایش leave_entries
                          var leave = data_days![index];
                          return dateLeave(leave);
                        } else {
                          // نمایش leave_data_clock
                          var leaveClock =
                              data_clock![index - data_days!.length];
                          return clockLeave(leaveClock);
                        }
                      },
                    ),
            ),
            const Divider(),
            details()
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
  double? finalClock = 187.2;
  double? finalDay = 26.0;
  double? finalClockthismonth = 0.0;
  double? finalDaythismonth = 0.0;
  double? remainingHours = 0.0;
  double? remainingDays = 0.0;
  int? totalDaysSum;
  String? infourl;
  bool? get_data = false;
  Future get_all_leave_kargozini() async {
    is_all_filter!
        ? infourl = Helper.url.toString() +
            'leave/get_all_leave_kargozini/' +
            widget.user_id.toString()
        : is_start_date!
            ? infourl = Helper.url.toString() +
                'leave/get_all_leave_kargozini/' +
                widget.user_id.toString() +
                '?start_date=' +
                start_date.toString() +
                "&end_date=" +
                end_date.toString()
            : infourl = Helper.url.toString() +
                'leave/get_all_leave_kargozini/' +
                widget.user_id.toString() +
                '?month=' +
                filter_month.toString() +
                "&year=" +
                filter_year.toString();
    var response = await http.get(Uri.parse(infourl!), headers: {
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
        finalClockthismonth = leaveData.sumMonthClock;
        finalDaythismonth = leaveData.sumMonthDay;
        remainingHours = leaveData.remainingHours;
        remainingDays = leaveData.remainingDays;
        get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  List<String> persianMonths = [
    "فروردین",
    "اردیبهشت",
    "خرداد",
    "تیر",
    "مرداد",
    "شهریور",
    "مهر",
    "آبان",
    "آذر",
    "دی",
    "بهمن",
    "اسفند"
  ];
  Widget month_select() {
    return Row(
      children: [
        Text(
          shamsi_month_select == 0
              ? "انتخاب ماه"
              : persianMonths[shamsi_month_select! - 1],
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        PopupMenuButton<int>(
          itemBuilder: (context) =>
              List.generate(persianMonths.length, (index) {
            return PopupMenuItem(
              value: index + 1,
              child: Text(persianMonths[index]),
            );
          }),
          onSelected: (value) {
            setState(() {
              shamsi_month_select = value;
              select_month_data = shamsi_month_select!;
              is_leave_all = false;
              is_leave_month = false;
              is_all_filter = false;
              filter_month = shamsi_month_select.toString();
              filter_year = current_year;
              is_start_date = false;
              is_end_date = false;
            });
            get_all_leave_kargozini();
          },
        ),
      ],
    );
  }

  Widget details() {
    double my_width = MediaQuery.of(context).size.width;
    return Container(
      width: my_width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "کل مرخصی های روزانه : ${totalDaysSum.toString().toPersianDigit()} روز",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                " به ساعت : ${dayToClock.toString().toPersianDigit()} ساعت",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "کل مرخصی های ساعتی : ${sumData.toString().toPersianDigit()} ساعت",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                " به روز : ${clockToDay.toString().toPersianDigit()} روز",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "جمع مرخصی ها به ساعت :  ${sumAllClock.toString().toPersianDigit()} ساعت",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "جمع مرخصی ها به روز :  ${sumAllDay.toString().toPersianDigit()} ساعت",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("مانده مرخصی تا پایان ماه "),
              ),
              Expanded(child: Divider()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                " مانده مرخصی ساعتی تا این ماه :  ${finalClockthismonth!.toStringAsFixed(2).toPersianDigit()} ساعت",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        finalClockthismonth! <= 0 ? Colors.red : Colors.green),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "مانده مرخصی روزانه تا این ماه :   ${finalDaythismonth!.toStringAsFixed(2).toPersianDigit()} روز",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: finalDaythismonth! <= 0 ? Colors.red : Colors.green),
              ),
            ],
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("مانده مرخصی تا پایان سال "),
              ),
              Expanded(child: Divider()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "مانده مرخصی ساعتی تا پایان سال :  ${remainingHours!.toStringAsFixed(2).toPersianDigit()} ساعت",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: remainingHours! <= 0 ? Colors.red : Colors.green),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "مانده مرخصی روزانه تا پایان سال :  ${remainingDays!.toStringAsFixed(2).toPersianDigit()} روز",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: remainingDays! <= 0 ? Colors.red : Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dateLeave(var data) {
    return Container(
      decoration: BoxDecoration(
          color: data.isAccept
              ? Colors.blue.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "از تاریخ : ${data.daysStartDate.toString().toPersianDigit()} - تا : ${data.daysEndDate.toString().toPersianDigit()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                data.isAccept ? "تایید شده" : "تایید نشده",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: data.isAccept ? Colors.green : Colors.red),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                " تعداد روزها : ${data.totalDays.toString().toPersianDigit()}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13.0),
              ),
              Text(
                  "تاریخ درخواست : ${FormateDateCreateChange.formatDate(data.createAt.toString())}")
            ],
          ),
        ],
      ),
    );
  }

  Widget clockLeave(var data) {
    return Container(
      decoration: BoxDecoration(
          color: data.isAccept
              ? Colors.amber.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "از ساعت : ${data.clockStartTime.toString().toPersianDigit()} تا ${data.clockEndTime.toString().toPersianDigit()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                data.isAccept ? "تایید شده" : "تایید نشده",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: data.isAccept ? Colors.green : Colors.red),
              ),
            ],
          ),
          const Divider(),
          data.finalTime >= 4.0
              ? Text(
                  "مرخصی ساعتی شما چون بیشتر از 4 ساعت است در صورت تایید به عنوان مرخصی روزانه محاسبه میشود")
              : Text("تاریخ: ${data.createAt.toString().toPersianDate()}"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                " ${data.finalTime.toString().toPersianDigit()} ساعت",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13.0),
              ),
              Text(
                  "تاریخ درخواست : ${FormateDateCreateChange.formatDate(data.createAt.toString())}")
            ],
          ),
        ],
      ),
    );
  }
}
