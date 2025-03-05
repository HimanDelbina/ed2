import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:ed/models/leave/leave_report_all_user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../../static/helper_page.dart';
import 'package:excel/excel.dart';
import 'dart:io';

class KargoziniLeaveAll extends StatefulWidget {
  const KargoziniLeaveAll({super.key});

  @override
  State<KargoziniLeaveAll> createState() => _KargoziniLeaveAllState();
}

class _KargoziniLeaveAllState extends State<KargoziniLeaveAll> {
  @override
  void initState() {
    super.initState();
    get_unit_data();
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

  double? finalClockthismonth = 0.0;
  double? finalDaythismonth = 0.0;
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
                            get_unit_data();
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
                            get_unit_data();
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
                                                  tempPickedDate ??
                                                      Jalali.now());
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
                                color: is_start_date!
                                    ? Colors.white
                                    : Colors.black,
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
                                                  tempPickedDate ??
                                                      Jalali.now());
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
                              date_end_select =
                                  '${pickedEndDate!.toDateTime()}';
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
                                color:
                                    is_end_date! ? Colors.white : Colors.black,
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
                          get_unit_data();
                        } else if (is_start_date!) {
                          MyMessage.mySnackbarMessage(context,
                              "لطفا اول تاریخ پایان را انتخاب کنید", 1);
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                ],
              ),
              const Divider(),
              Expanded(
                child: is_get_data
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: TableBorder.all(color: Colors.grey, width: 1),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'انتخاب',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                                label: Text('شناسه کاربر',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('نام کاربر',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('مرخصی روزانه',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('مرخصی ساعتی',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('تبدیل روز به ساعت',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('تبدیل ساعت به روز',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('کل مرخصی (روز)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('کل مرخصی (ساعت)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: data!.map((user) {
                            int index =
                                data!.indexOf(user); // اندیس کاربر در لیست
                            return DataRow(cells: [
                              DataCell(Checkbox(
                                value: selectedUsers[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedUsers[index] = value ?? false;
                                  });
                                },
                              )),
                              DataCell(Text(
                                  user.userId.toString().toPersianDigit())),
                              DataCell(Text(user.userName.toString())),
                              DataCell(Text(
                                  '${user.dailyLeaves.toString().toPersianDigit()} روز')),
                              DataCell(Text(
                                  "${user.clockLeaves.toString().toPersianDigit()} ساعت")),
                              DataCell(Text(
                                  "${user.convertedDaysToClock.toString().toPersianDigit()} ساعت")),
                              DataCell(Text(
                                  "${user.convertedClockToDays.toString().toPersianDigit()} روز")),
                              DataCell(Text(
                                  "${user.totalLeavesInDays.toString().toPersianDigit()} روز")),
                              DataCell(Text(
                                  "${user.totalLeavesInHours.toString().toPersianDigit()} ساعت")),
                            ]);
                          }).toList(),
                        ),
                      )
                    : Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0)),
              ),
              GestureDetector(
                onTap: () {
                  exportSelectedToExcel();
                },
                child: Container(
                  height: my_height * 0.06,
                  width: my_width,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "خروجی اکسل",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // لیست برای ذخیره وضعیت انتخابی هر ردیف
  List<bool> selectedUsers = [];
  List? data = [];
  bool is_get_data = false;
  String? infourl;
  Future get_unit_data() async {
    is_all_filter!
        ? infourl = Helper.url.toString() + 'leave/calculate_leaves_all_user'
        : is_start_date!
            ? infourl = Helper.url.toString() +
                'leave/calculate_leaves_all_user' +
                '?start_date=' +
                start_date.toString() +
                "&end_date=" +
                end_date.toString()
            : infourl = Helper.url.toString() +
                'leave/calculate_leaves_all_user' +
                '?month=' +
                filter_month.toString() +
                "&year=" +
                filter_year.toString();
    // String infourl = Helper.url.toString() + 'leave/calculate_leaves_all_user';
    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = leaveReportAllModelFromJson(x);
      setState(() {
        data = recive_data.users;
        is_get_data =
            true; // مقداردهی اولیه وضعیت چک‌باکس‌ها (همه به‌صورت پیش‌فرض غیرفعال)
        selectedUsers = List.generate(data!.length, (_) => true);
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  // متد برای صادر کردن داده‌های کاربران انتخاب شده
  Future<void> exportSelectedToExcel() async {
    List<User> selectedData = [];
    for (int i = 0; i < data!.length; i++) {
      if (selectedUsers[i]) {
        selectedData.add(data![i]);
      }
    }

    if (selectedData.isNotEmpty) {
      await exportToExcel(selectedData);
    } else {
      print("هیچ کاربری انتخاب نشده است.");
    }
  }

  Future<void> exportToExcel(List<dynamic> data) async {
    // ایجاد فایل اکسل جدید
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // افزودن عناوین ستون‌ها
    sheetObject.appendRow([
      TextCellValue('شناسه کاربر'),
      TextCellValue('نام کاربر'),
      TextCellValue('مرخصی روزانه'),
      TextCellValue('مرخصی ساعتی'),
      TextCellValue('تبدیل روز به ساعت'),
      TextCellValue('تبدیل ساعت به روز'),
      TextCellValue('کل مرخصی (روز)'),
      TextCellValue('کل مرخصی (ساعت)'),
    ]);

    // افزودن داده‌های کاربران
    for (var user in data) {
      sheetObject.appendRow([
        TextCellValue(user.userId.toString()),
        TextCellValue(user.userName.toString()),
        TextCellValue('${user.dailyLeaves.toString()} روز'),
        TextCellValue('${user.clockLeaves.toString()} ساعت'),
        TextCellValue('${user.convertedDaysToClock.toString()} ساعت'),
        TextCellValue('${user.convertedClockToDays.toString()} روز'),
        TextCellValue('${user.totalLeavesInDays.toString()} روز'),
        TextCellValue('${user.totalLeavesInHours.toString()} ساعت'),
      ]);
    }

    // دریافت بایت‌های فایل اکسل
    List<int>? fileBytes = excel.save();

    if (fileBytes != null) {
      // ذخیره فایل اکسل
      await saveFile('leaves_all_report.xlsx', fileBytes);
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
            get_unit_data();
          },
        ),
      ],
    );
  }
}
