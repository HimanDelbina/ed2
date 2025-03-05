import 'dart:convert';
import 'package:ed/models/shift/shift_all_report_model.dart';
import 'package:ed/models/shift/shift_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';
import '../../../../test.dart';

class ReportShiftUserSelect extends StatefulWidget {
  int? user_id;
  ReportShiftUserSelect({super.key, this.user_id});

  @override
  State<ReportShiftUserSelect> createState() => _ReportShiftUserSelectState();
}

class _ReportShiftUserSelectState extends State<ReportShiftUserSelect> {
  @override
  void initState() {
    super.initState();
    get_shift_by_user_id();
    get_shift_all_report();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: is_get_data == false
              ? Center(
                  child:
                      Lottie.asset("assets/lottie/loading.json", height: 40.0))
              : Column(
                  children: [
                    buildShiftTable(data_all_report),
                    Expanded(child: ShiftSchedule(data_show: data_show)),
                  ],
                ),
          // : ListView(
          //     children: data_show.keys.map((monthNumber) {
          //       return Container(
          //         decoration: BoxDecoration(
          //           color: Colors.grey.withOpacity(0.1),
          //           borderRadius: BorderRadius.circular(5.0),
          //         ),
          //         margin:
          //             const EdgeInsetsDirectional.symmetric(vertical: 5.0),
          //         child: ExpansionTile(
          //           title: Text(
          //             monthNumber,
          //             style: const TextStyle(
          //                 fontSize: 18, fontWeight: FontWeight.bold),
          //           ),
          //           children: data_show[monthNumber]!.map((shift) {
          //             String date =
          //                 shift.shiftDate.toString().split(' ')[0];
          //             return Container(
          //               decoration: BoxDecoration(
          //                 color: shift.daysSelect == "SO"
          //                     ? Colors.red.withOpacity(0.1)
          //                     : shift.daysSelect == "AS"
          //                         ? Colors.amber.withOpacity(0.1)
          //                         : shift.daysSelect == "SH"
          //                             ? Colors.black.withOpacity(0.1)
          //                             : Colors.grey.withOpacity(0.1),
          //                 borderRadius: BorderRadius.circular(5.0),
          //               ),
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 15.0, vertical: 10.0),
          //               margin: const EdgeInsets.symmetric(vertical: 5.0),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Row(
          //                     children: [
          //                       Padding(
          //                         padding:
          //                             const EdgeInsets.only(left: 15.0),
          //                         child: Icon(
          //                           shift.isCheck!
          //                               ? Icons.check
          //                               : Icons.clear,
          //                           size: 20.0,
          //                           color: shift.isCheck!
          //                               ? Colors.green
          //                               : Colors.red,
          //                         ),
          //                       ),
          //                       Column(
          //                         crossAxisAlignment:
          //                             CrossAxisAlignment.start,
          //                         children: [
          //                           Text(
          //                             shift.daysSelect == "SO"
          //                                 ? "صبح"
          //                                 : shift.daysSelect == "AS"
          //                                     ? "عصر"
          //                                     : shift.daysSelect == "SH"
          //                                         ? "شب"
          //                                         : "",
          //                             style: const TextStyle(
          //                                 fontWeight: FontWeight.bold),
          //                           ),
          //                           Text(
          //                             date.toPersianDigit(),
          //                             style: const TextStyle(
          //                                 color: Colors.blue),
          //                           ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                   GestureDetector(
          //                     onTap: () {
          //                       // اضافه کردن اکشن برای ویرایش
          //                     },
          //                     child: const Icon(Icons.edit,
          //                         size: 20.0, color: Colors.black),
          //                   )
          //                 ],
          //               ),
          //             );
          //           }).toList(),
          //         ),
          //       );
          //     }).toList(),
          //   ),
        ),
      ),
    );
  }

  final Map<String, String> monthNames = {
    "1": "فروردین",
    "2": "اردیبهشت",
    "3": "خرداد",
    "4": "تیر",
    "5": "مرداد",
    "6": "شهریور",
    "7": "مهر",
    "8": "آبان",
    "9": "آذر",
    "10": "دی",
    "11": "بهمن",
    "12": "اسفند",
  };

  Map<String, List<ShiftModel>> data_get =
      {}; // تغییر به Map از نوع List<ShiftModel>
  Map<String, List<ShiftModel>> data_show =
      {}; // تغییر داده به Map برای ذخیره داده‌ها بر اساس ماه
  bool is_get_data = false;
  List? data = [];

  Future<void> get_shift_by_user_id() async {
    String infourl = Helper.url.toString() +
        'shift/get_shift_by_user_id/' +
        widget.user_id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = shiftModelFromJson(x);

      setState(() {
        data = recive_data;
        data_get.clear(); // پاک کردن داده‌ها قبل از افزودن داده‌های جدید
        is_get_data = true;
      });

      if (recive_data.isNotEmpty) {
        // برای هر شیء در داده‌های دریافتی
        for (var item in recive_data) {
          // چاپ تاریخ دریافتی
          // print("Received Date: ${item.shiftDate}");

          // فرض کنید shiftDate از نوع String است که تاریخ شمسی را در قالب YYYY-MM-DD دارد
          var dateParts = item.shiftDate
              .toString()
              .split(' ')[0]
              .split('-'); // جدا کردن تاریخ از زمان

          if (dateParts.length >= 3) {
            // استفاده از تاریخ شمسی
            try {
              Jalali jDate = Jalali(
                  int.parse(dateParts[0]),
                  int.parse(dateParts[1]),
                  int.parse(dateParts[2])); // تاریخ شمسی

              // دریافت شماره ماه شمسی
              String monthNumber = jDate.formatter.m; // شماره ماه شمسی

              // چاپ شماره ماه
              // print("Month Number: $monthNumber");

              // دریافت نام ماه از monthNames
              String monthName =
                  monthNames[monthNumber] ?? "نامشخص"; // ماه به فارسی

              // چاپ نام ماه
              // print("Month Name: $monthName");

              // اگر لیستی برای ماه خاص وجود ندارد، آن را ایجاد می‌کنیم
              if (data_get[monthName] == null) {
                data_get[monthName] = [];
              }

              // افزودن شیء ShiftModel به لیست مربوطه
              data_get[monthName]!
                  .add(item); // استفاده از علامت '!' برای دسترسی به لیست
            } catch (e) {
              print("Error parsing date: $e");
              continue; // اگر تاریخ به درستی تبدیل نشد، از پردازش آن صرف‌نظر کنید
            }
          } else {
            print("Invalid date format");
          }
        }
      } else {
        // در صورت خالی بودن داده‌ها
        MyMessage.mySnackbarMessage(context, "داده‌ای وجود ندارد", 1);
      }

      // پس از پردازش داده‌ها، گروه‌بندی شده‌ها را به data_show نسبت می‌دهیم
      setState(() {
        data_show = data_get;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  bool? is_get_all_report = false;
  List<ShiftReport> data_all_report = [];
  Future<void> get_shift_all_report() async {
    String infourl = Helper.url.toString() +
        'shift/get_shift_by_user_id_new/' +
        widget.user_id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<ShiftReport> reports = [];
      if (data is List) {
        reports = data.map((item) => ShiftReport.fromJson(item)).toList();
      }

      if (mounted) {
        setState(() {
          data_all_report = reports;
          is_get_all_report = true;
        });
      }
    } else {
      // Handle error
      if (mounted) {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    }
  }

  Widget buildShiftTable(List<ShiftReport> reports) {
    return Table(
      border: TableBorder.all(),
      children: [
        const TableRow(
          children: [
            TableCell(
                child: Center(
                    child: Text(
              'ماه',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
            TableCell(
                child: Center(
                    child: Text(
              'نوع شیفت',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
            TableCell(
                child: Center(
                    child: Text(
              'تعداد شیفت‌ها',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
            TableCell(
                child: Center(
                    child: Text(
              'تعداد تایید شده‌ها',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
          ],
        ),
        for (var report in reports) ...[
          for (var shift in report.shiftTypes) ...[
            TableRow(
              decoration: BoxDecoration(
                  color: shift.totalShifts == 0
                      ? Colors.red.withOpacity(0.2)
                      : Colors.transparent),
              children: [
                TableCell(
                    child: Center(
                        child: Text(
                            '${report.month.toString().toPersianDigit()}'))),
                TableCell(child: Center(child: Text(shift.shiftTypeName))),
                TableCell(
                    child: Center(
                        child: shift.totalShifts == 0
                            ? const Text("ندارد")
                            : Text(
                                '${shift.totalShifts.toString().toPersianDigit()}'))),
                TableCell(
                    child: Center(
                        child: shift.totalShifts == 0
                            ? const Text("ندارد")
                            : Text(
                                '${shift.approvedShifts.toString().toPersianDigit()}'))),
              ],
            ),
          ],
          // اضافه کردن یک ردیف برای مجموع شیفت‌ها و تایید شده‌ها در هر ماه
          TableRow(
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.3)),
            children: [
              const TableCell(child: Text('')),
              const TableCell(child: Text('')),
              TableCell(
                  child: Center(
                      child: Text(
                '${report.totalShiftsInMonth.toString().toPersianDigit()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))),
              TableCell(
                  child: Center(
                      child: Text(
                '${report.approvedShiftsInMonth.toString().toPersianDigit()}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))),
            ],
          ),
        ],
      ],
    );
  }
}
