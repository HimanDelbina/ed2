import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../models/overtime/overtime_new_model.dart';
import '../../../../../static/helper_page.dart';

class KargoziniOvertimeSelectExcelPage extends StatefulWidget {
  int? user_id;
  KargoziniOvertimeSelectExcelPage({super.key, this.user_id});

  @override
  State<KargoziniOvertimeSelectExcelPage> createState() =>
      _KargoziniOvertimeSelectExcelPageState();
}

class _KargoziniOvertimeSelectExcelPageState
    extends State<KargoziniOvertimeSelectExcelPage> {
  @override
  void initState() {
    super.initState();
    get_all_overtime_by_user_id();
    current_month = date_now!.month.toString();
    current_year = date_now!.year.toString();
    filter_month = current_month;
    filter_year = current_year;
  }

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

  bool? is_ez_all = true;
  String? select_ez = "all";
  bool? is_ez = false;
  bool? is_go = false;
  bool? is_ta = false;
  bool? is_ma = false;

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
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  is_ez_all = true;
                                  is_ez = false;
                                  is_go = false;
                                  is_ta = false;
                                  is_ma = false;
                                  select_ez = "all";
                                });
                                get_all_overtime_by_user_id();
                              },
                              child: Container(
                                width: my_width,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7.0, horizontal: 10.0),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 7.0),
                                decoration: BoxDecoration(
                                  color: is_ez_all!
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "همه",
                                    style: TextStyle(
                                        color: is_ez_all!
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: is_ez_all!
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // exportSelectedToExcel();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Center(
                              child: Image.asset("assets/image/xls.png",
                                  height: 20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        show_filter(
                          "اضافه کاری",
                          is_ez,
                          () {
                            setState(() {
                              is_ez_all = false;
                              is_ez = true;
                              is_go = false;
                              is_ta = false;
                              is_ma = false;
                              select_ez = "EZ";
                            });
                            get_all_overtime_by_user_id();
                          },
                        ),
                        show_filter(
                          "جمعه کاری",
                          is_go,
                          () {
                            setState(() {
                              is_ez_all = false;
                              is_ez = false;
                              is_go = true;
                              is_ta = false;
                              is_ma = false;
                              select_ez = "GO";
                            });
                            get_all_overtime_by_user_id();
                          },
                        ),
                        show_filter(
                          "تعطیل کاری",
                          is_ta,
                          () {
                            setState(() {
                              is_ez_all = false;
                              is_ez = false;
                              is_go = false;
                              is_ta = true;
                              is_ma = false;
                              select_ez = "TA";
                            });
                            get_all_overtime_by_user_id();
                          },
                        ),
                        show_filter(
                          "ماموریت",
                          is_ma,
                          () {
                            setState(() {
                              is_ez_all = false;
                              is_ez = false;
                              is_go = false;
                              is_ta = false;
                              is_ma = true;
                              select_ez = "MA";
                            });
                            get_all_overtime_by_user_id();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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
                            get_all_overtime_by_user_id();
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
                            get_all_overtime_by_user_id();
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
                          get_all_overtime_by_user_id();
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
                child: is_get_data!
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border:
                                  TableBorder.all(color: Colors.grey, width: 1),
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'جمعه کاری',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'اضافه کاری',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'تعطیل کاری',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataColumn(
                                    label: Text(
                                  'ماموریت',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text(sumData_go == null
                                      ? 0.toString().toPersianDigit()
                                      : sumData_go
                                          .toString()
                                          .toPersianDigit())),
                                  DataCell(Text(sumData_ez == null
                                      ? 0.toString().toPersianDigit()
                                      : sumData_ez
                                          .toString()
                                          .toPersianDigit())),
                                  DataCell(Text(sumData_ta == null
                                      ? 0.toString().toPersianDigit()
                                      : sumData_ta
                                          .toString()
                                          .toPersianDigit())),
                                  DataCell(Text(sumData_ma == null
                                      ? 0.toString().toPersianDigit()
                                      : sumData_ma
                                          .toString()
                                          .toPersianDigit())),
                                ]),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("جزییات"),
                              ),
                              Expanded(child: Divider(color: Colors.blue)),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                border: TableBorder.all(
                                    color: Colors.grey, width: 1),
                                columns: const [
                                  DataColumn(
                                      label: Text(
                                    'نام کاربر',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'نوع اضافه‌کاری',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'تاریخ درخواست',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'ساعت شروع',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'ساعت پایان',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'زمان نهایی',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'وضعیت تایید',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ],
                                rows: all_data!.map<DataRow>((item) {
                                  String dateTimeString =
                                      item.overtimeDate!.toString();
                                  String onlyDate =
                                      dateTimeString.split(' ')[0];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                          '${item.user!.firstName.toString()} ${item.user!.lastName.toString()}')),
                                      DataCell(Text(
                                        item.select == "EZ"
                                            ? "اضافه کاری"
                                            : item.select == "GO"
                                                ? "جمعه کاری"
                                                : item.select == "TA"
                                                    ? "تعطیل کاری"
                                                    : item.select == "MA"
                                                        ? "ماموریت"
                                                        : "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: item.select == "EZ"
                                              ? Colors.blue
                                              : item.select == "GO"
                                                  ? Colors.purple
                                                  : item.select == "TA"
                                                      ? Colors.green
                                                      : item.select == "MA"
                                                          ? Colors.deepOrange
                                                          : Colors.blue,
                                        ),
                                      )),
                                      DataCell(Text(
                                          '${FormateDate.formatDate(onlyDate)}')),
                                      DataCell(Text(
                                          '${item.startTime.toString().toPersianDigit()}')),
                                      DataCell(Text(
                                          '${item.endTime.toString().toPersianDigit()}')),
                                      DataCell(Text(
                                          '${item.finalTime.toString().toPersianDigit()} ساعت')),
                                      DataCell(Text(
                                        item.managerAccept!
                                            ? 'تایید توسط مدیر واحد'
                                            : 'تایید توسط مدیر سالن',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List? data = [];
  List? data_go = [];
  List? data_ez = [];
  List? data_ta = [];
  List? data_ma = [];
  List? all_data = [];
  bool? is_get_data = false;
  double? sumData_go;
  double? sumData_ez;
  double? sumData_ta;
  double? sumData_ma;
  String? infourl;
  Future<void> get_all_overtime_by_user_id() async {
    is_all_filter!
        ? infourl = Helper.url.toString() +
            'overtime/get_filter_overtime/' +
            widget.user_id.toString() +
            '?select=' +
            select_ez!
        : is_start_date!
            ? infourl = Helper.url.toString() +
                'overtime/get_filter_overtime/' +
                widget.user_id.toString() +
                '?select=' +
                select_ez! +
                '&start_date=' +
                start_date.toString() +
                "&end_date=" +
                end_date.toString()
            : infourl = Helper.url.toString() +
                'overtime/get_filter_overtime/' +
                widget.user_id.toString() +
                '?select=' +
                select_ez! +
                '&month=' +
                filter_month.toString() +
                "&year=" +
                filter_year.toString();
    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = overtimeNewModelFromJson(x);

      setState(() {
        all_data!.clear();
        data_go = recive_data.leaveEntriesBySelect!.go;
        data_ez = recive_data.leaveEntriesBySelect!.ez;
        data_ta = recive_data.leaveEntriesBySelect!.ta;
        data_ma = recive_data.leaveEntriesBySelect!.ma;
        sumData_go = recive_data.sumDataBySelect!.go;
        sumData_ez = recive_data.sumDataBySelect!.ez;
        sumData_ta = recive_data.sumDataBySelect!.ta;
        sumData_ma = recive_data.sumDataBySelect!.ma;
        all_data!.addAll(data_go!);
        all_data!.addAll(data_ez!);
        all_data!.addAll(data_ta!);
        all_data!.addAll(data_ma!);
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
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
            get_all_overtime_by_user_id();
          },
        ),
      ],
    );
  }
}
