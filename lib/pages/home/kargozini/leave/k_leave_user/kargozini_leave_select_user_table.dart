import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../models/leave/leave_two_model.dart';
import '../../../../../static/helper_page.dart';

class KargoziniLeaveSelectUserTable extends StatefulWidget {
  int? user_id;
  KargoziniLeaveSelectUserTable({super.key, this.user_id});

  @override
  State<KargoziniLeaveSelectUserTable> createState() =>
      _KargoziniLeaveSelectUserTableState();
}

class _KargoziniLeaveSelectUserTableState
    extends State<KargoziniLeaveSelectUserTable> {
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
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              export_widget(
                "خروجی جزییات",
                "assets/image/xls.png",
                () {
                  exportLeavesToExcel(data_days!, data_clock!);
                },
              ),
              export_widget(
                "خروجی کلی",
                "assets/image/xls.png",
                () {},
              ),
            ],
          ),
          const Divider(),
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
                            color: is_start_date! ? Colors.white : Colors.black,
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
                        print(end_date);
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
              child: Column(
            children: [
              Expanded(
                child: LeaveTable(
                  dataDays: data_days!,
                  dataClock: data_clock!,
                ),
              ),
              const Divider(),
              Container(
                child: Container(
                  width: my_width,
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey, width: 1.0),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      // Header Row
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "عنوان",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "مقدار",
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      // Data Rows
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("کل مرخصی‌های روزانه"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${totalDaysSum.toString().toPersianDigit()} روز"),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("کل مرخصی‌های ساعتی"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${sumData.toString().toPersianDigit()} ساعت"),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("جمع مرخصی‌ها به ساعت"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${sumAllClock.toString().toPersianDigit()} ساعت"),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("جمع مرخصی‌ها به روز"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${sumAllDay.toString().toPersianDigit()} روز"),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("مانده مرخصی ساعتی تا این ماه"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${finalClockthismonth!.toStringAsFixed(2).toPersianDigit()} ساعت",
                              style: TextStyle(
                                  color: finalClockthismonth! <= 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("مانده مرخصی روزانه تا این ماه"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${finalDaythismonth!.toStringAsFixed(2).toPersianDigit()} روز",
                              style: TextStyle(
                                  color: finalDaythismonth! <= 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("مانده مرخصی ساعتی تا پایان سال"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${remainingHours!.toStringAsFixed(2).toPersianDigit()} ساعت",
                              style: TextStyle(
                                  color: remainingHours! <= 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("مانده مرخصی روزانه تا پایان سال"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${remainingDays!.toStringAsFixed(2).toPersianDigit()} روز",
                              style: TextStyle(
                                  color: remainingDays! <= 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget export_widget(String title, String image, VoidCallback onTab) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 15.0, vertical: 5.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(title),
            ),
            Image.asset(image, height: 15.0)
          ],
        ),
      ),
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
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Widget month_select() {
    return Row(
      children: [
        Text(
          shamsi_month_select == 0
              ? "انتخاب ماه"
              : shamsi_month_select == 1
                  ? "فروردین"
                  : shamsi_month_select == 2
                      ? "اردیبهشت"
                      : shamsi_month_select == 3
                          ? "خرداد"
                          : shamsi_month_select == 4
                              ? "تیر"
                              : shamsi_month_select == 5
                                  ? "مرداد"
                                  : shamsi_month_select == 6
                                      ? "شهریور"
                                      : shamsi_month_select == 7
                                          ? "مهر"
                                          : shamsi_month_select == 8
                                              ? "آبان"
                                              : shamsi_month_select == 9
                                                  ? "آذر"
                                                  : shamsi_month_select == 10
                                                      ? "دی"
                                                      : shamsi_month_select ==
                                                              11
                                                          ? "بهمن"
                                                          : shamsi_month_select ==
                                                                  12
                                                              ? "اسفند"
                                                              : "انتخاب ماه",
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        PopupMenuButton(
          itemBuilder: (context) => const [
            PopupMenuItem(
              child: Text("فروردین"),
              value: 1,
            ),
            PopupMenuItem(
              child: Text("اردیبهشت"),
              value: 2,
            ),
            PopupMenuItem(
              child: Text("خرداد"),
              value: 3,
            ),
            PopupMenuItem(
              child: Text("تیر"),
              value: 4,
            ),
            PopupMenuItem(
              child: Text("مرداد"),
              value: 5,
            ),
            PopupMenuItem(
              child: Text("شهریور"),
              value: 6,
            ),
            PopupMenuItem(
              child: Text("مهر"),
              value: 7,
            ),
            PopupMenuItem(
              child: Text("آبان"),
              value: 8,
            ),
            PopupMenuItem(
              child: Text("آذر"),
              value: 9,
            ),
            PopupMenuItem(
              child: Text("دی"),
              value: 10,
            ),
            PopupMenuItem(
              child: Text("بهمن"),
              value: 11,
            ),
            PopupMenuItem(
              child: Text("اسفند"),
              value: 12,
            ),
          ],
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

  Future<void> exportLeavesToExcel(
      List<dynamic> dataDays, List<dynamic> dataClock) async {
    // ایجاد فایل اکسل جدید
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // افزودن عناوین ستون‌ها
    sheetObject.appendRow([
      TextCellValue('نوع مرخصی'),
      TextCellValue("تاریخ شروع/ساعت"),
      TextCellValue("تاریخ پایان/ساعت"),
      TextCellValue("وضعیت"),
      TextCellValue("مدت"),
    ]);

    // افزودن داده‌های روزانه
    for (var leave in dataDays) {
      sheetObject.appendRow([
        TextCellValue("روزانه"),
        TextCellValue(leave.daysStartDate.toString().toPersianDigit()),
        TextCellValue(leave.daysEndDate.toString().toPersianDigit()),
        TextCellValue(leave.isAccept ? "تایید شده" : "تایید نشده"),
        TextCellValue("${leave.totalDays.toString().toPersianDigit()} روز"),
      ]);
    }

    // افزودن داده‌های ساعتی
    for (var leaveClock in dataClock) {
      sheetObject.appendRow([
        TextCellValue("ساعتی"),
        TextCellValue(leaveClock.clockStartTime.toString().toPersianDigit()),
        TextCellValue(leaveClock.clockEndTime.toString().toPersianDigit()),
        TextCellValue(leaveClock.isAccept ? "تایید شده" : "تایید نشده"),
        TextCellValue(
            "${leaveClock.finalTime.toString().toPersianDigit()} ساعت"),
      ]);
    }

    // ذخیره فایل
    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      await saveFile('leaves_details_report.xlsx', fileBytes);
    }
  }

  Future<void> saveFile(String fileName, List<int> bytes) async {
    await requestPermissions();
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      String outputPath = "$selectedDirectory/$fileName";
      File file = File(outputPath);
      file.createSync(recursive: true);
      file.writeAsBytesSync(bytes);
      print("فایل با موفقیت در مسیر $outputPath ذخیره شد.");
    } else {
      print("مسیر انتخاب نشد.");
    }
  }

  Future<void> requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception("Storage permission denied.");
      }
    }
  }
}

class LeaveTable extends StatelessWidget {
  final List<dynamic> dataDays;
  final List<dynamic> dataClock;

  LeaveTable({required this.dataDays, required this.dataClock});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(color: Colors.grey, width: 1.0),
          columns: const [
            DataColumn(label: Text("نوع مرخصی")),
            DataColumn(label: Text("تاریخ شروع/ساعت")),
            DataColumn(label: Text("تاریخ پایان/ساعت")),
            DataColumn(label: Text("وضعیت")),
            DataColumn(label: Text("مدت")),
          ],
          rows: [
            ...dataDays.map((leave) {
              return DataRow(cells: [
                const DataCell(Text("روزانه")),
                DataCell(Text(leave.daysStartDate.toString().toPersianDigit())),
                DataCell(Text(leave.daysEndDate.toString().toPersianDigit())),
                DataCell(
                  Text(
                    leave.isAccept ? "تایید شده" : "تایید نشده",
                    style: TextStyle(
                      color: leave.isAccept ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                DataCell(
                    Text("${leave.totalDays.toString().toPersianDigit()} روز")),
              ]);
            }).toList(),
            ...dataClock.map((leaveClock) {
              return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return Colors.grey
                          .withOpacity(0.1); // رنگ پس‌زمینه برای کل ردیف
                    },
                  ),
                  cells: [
                    const DataCell(Text("ساعتی")),
                    DataCell(Text(
                        leaveClock.clockStartTime.toString().toPersianDigit())),
                    DataCell(Text(
                        leaveClock.clockEndTime.toString().toPersianDigit())),
                    DataCell(
                      Text(
                        leaveClock.isAccept ? "تایید شده" : "تایید نشده",
                        style: TextStyle(
                          color:
                              leaveClock.isAccept ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    DataCell(Text(
                        "${leaveClock.finalTime.toString().toPersianDigit()} ساعت")),
                  ]);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
