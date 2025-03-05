import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../static/helper_page.dart';

class LeaveDayPage extends StatefulWidget {
  const LeaveDayPage({super.key});

  @override
  State<LeaveDayPage> createState() => _LeaveDayPageState();
}

class _LeaveDayPageState extends State<LeaveDayPage> {
  int? id_user = 0;
  int? id_unit = 0;
  String? group_name;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
      group_name = prefsUser.getString("group_name") ?? "";
    });
  }

  Jalali? picked_start = Jalali.now();
  Jalali? picked_start_selected = Jalali.now();
  Jalali? picked_end = Jalali.now();
  Jalali? picked_end_selected = Jalali.now();
  Set<Jalali> dateRangeSet = {};
  List<Jalali> dateRange = [];
  String? dateRange_send;
  @override
  void initState() {
    super.initState();
    get_user_data();
    checkTime();
    select_choice = "ES";
  }

  String label = 'انتخاب تاریخ زمان';
  String select_start_date = "";
  String select_end_date = "";
  bool? is_date_select = false;
  int? date_length = 0;

  String selectedDate = Jalali.now().toJalaliDateTime();
  bool? select_es = true;
  bool? select_et = false;
  String? select_choice;

  void checkTime() {
    final now = DateTime.now();
    if (now.hour >= 14) {
      setState(() {
        mv_select = false;
        ms_select = true;
      });
    }
  }

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
              GestureDetector(
                onTap: () {
                  setState(() {
                    select_es = true;
                    select_et = false;
                    select_choice = "ES";
                  });
                },
                child: Container(
                  height: my_height * 0.06,
                  width: my_width * 0.4,
                  decoration: BoxDecoration(
                      color: select_es!
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      "مرخصی استحقاقی",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: select_es! ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    select_es = false;
                    select_et = true;
                    select_choice = "ET";
                  });
                },
                child: Container(
                  height: my_height * 0.06,
                  width: my_width * 0.4,
                  decoration: BoxDecoration(
                      color: select_et!
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text(
                      "مرخصی استعلاجی",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: select_et! ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: GestureDetector(
              onTap: () async {
                Jalali today = Jalali.now();
                Jalali endDate = Jalali.now();

                if (today.isAfter(endDate)) {
                  today = endDate;
                }

                var picked = await showPersianDateRangePicker(
                  context: context,
                  initialDateRange: JalaliRange(
                    start: today,
                    end: endDate,
                  ),
                  firstDate: Jalali(1385, 8),
                  lastDate: Jalali(1450, 9),
                );

                if (picked != null) {
                  Jalali current = picked.start;
                  setState(() {
                    dateRangeSet.clear();
                  });

                  while (current.isBefore(picked.end) ||
                      (current.year == picked.end.year &&
                          current.month == picked.end.month &&
                          current.day == picked.end.day)) {
                    dateRangeSet.add(current);
                    if (current.day <
                        daysInMonth(current.year, current.month)) {
                      current =
                          Jalali(current.year, current.month, current.day + 1);
                    } else if (current.month < 12) {
                      current = Jalali(current.year, current.month + 1, 1);
                    } else {
                      current = Jalali(current.year + 1, 1, 1);
                    }
                  }

                  dateRange = dateRangeSet.toList()
                    ..sort((a, b) => a.compareTo(b));

                  List<String> dateRangeNumbers = dateRange
                      .map((date) =>
                          '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}')
                      .toList();

                  setState(() {
                    dateRange_send = jsonEncode(dateRangeNumbers);

                    /// ذخیره تاریخ‌های جلالی با فرمت استاندارد `YYYY-MM-DD`
                    finalStartDate =
                        '${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}';
                    finalEndDate =
                        '${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}';
                  });
                }

                setState(() {
                  select_start_date = picked!.start.formatShortDate();
                  select_end_date = picked.end.formatShortDate();
                  date_length = dateRange.length;
                  is_date_select = true;
                });
              },

              // onTap: () async {
              //   Jalali today = Jalali.now();
              //   Jalali endDate = Jalali.now();

              //   if (today.isAfter(endDate)) {
              //     today = endDate;
              //   }
              //   var picked = await showPersianDateRangePicker(
              //     context: context,
              //     initialDateRange: JalaliRange(
              //       start: today,
              //       end: endDate,
              //     ),
              //     firstDate: Jalali(1385, 8),
              //     lastDate: Jalali(1450, 9),
              //   );
              //   if (picked != null) {
              //     Jalali current = picked.start;
              //     setState(() {
              //       dateRangeSet.clear();
              //     });
              //     while (current.isBefore(picked.end) ||
              //         (current.year == picked.end.year &&
              //             current.month == picked.end.month &&
              //             current.day == picked.end.day)) {
              //       dateRangeSet.add(current);
              //       if (current.day <
              //           daysInMonth(current.year, current.month)) {
              //         current =
              //             Jalali(current.year, current.month, current.day + 1);
              //       } else if (current.month < 12) {
              //         current = Jalali(current.year, current.month + 1, 1);
              //       } else {
              //         current = Jalali(current.year + 1, 1, 1);
              //       }
              //     }
              //     dateRange = dateRangeSet.toList()
              //       ..sort((a, b) => a.compareTo(b));

              //     List<String> dateRangeNumbers = dateRange
              //         .map((date) =>
              //             '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}')
              //         .toList();
              //     setState(() {
              //       dateRange_send = jsonEncode(dateRangeNumbers);
              //     });
              //   }
              //   setState(() {
              //     select_start_date = picked!.start.formatShortDate();
              //     select_end_date = picked.end.formatShortDate();
              //     date_length = 0;
              //     date_length = dateRange.length;
              //     is_date_select = true;
              //   });
              // },
              child: Container(
                height: my_height * 0.06,
                width: my_width,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        is_date_select! == false
                            ? label
                            : select_start_date +
                                " "
                                    " تا " +
                                select_end_date,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        date_length.toString().toPersianDigit() + " روز ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          text_form("توضیحات", IconlyBold.paper, controllerLeavedescription,
              leave_description, false, 3, TextInputType.name),
          group_name == "کنترل کیفیت" ||
                  group_name == "اداری" ||
                  group_name == "نگهبانی"
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      mv_select = true;
                    });
                  },
                  child: Container(
                    height: my_height * 0.06,
                    width: my_width,
                    decoration: BoxDecoration(
                        color: mv_select!
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        "مدیر واحد",
                        style: TextStyle(
                            fontWeight: mv_select!
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: mv_select! ? Colors.white : Colors.black,
                            fontSize: mv_select! ? 18.0 : 16.0),
                      ),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          mv_select = true;
                          ms_select = false;
                        });
                      },
                      child: Container(
                        height: my_height * 0.06,
                        width: my_width * 0.4,
                        decoration: BoxDecoration(
                            color: mv_select!
                                ? Colors.blue
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Center(
                          child: Text(
                            "مدیر واحد",
                            style: TextStyle(
                                fontWeight: mv_select!
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: mv_select! ? Colors.white : Colors.black,
                                fontSize: mv_select! ? 18.0 : 16.0),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          mv_select = false;
                          ms_select = true;
                        });
                      },
                      child: Container(
                        height: my_height * 0.06,
                        width: my_width * 0.4,
                        decoration: BoxDecoration(
                            color: ms_select!
                                ? Colors.blue
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Center(
                          child: Text(
                            "مدیر سالن",
                            style: TextStyle(
                                fontWeight: ms_select!
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: ms_select! ? Colors.white : Colors.black,
                                fontSize: ms_select! ? 18.0 : 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              create_leave();
            },
            child: Container(
              height: my_height * 0.06,
              width: my_width,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
              child: const Center(
                child: Text(
                  "تایید",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool? mv_select = true;
  bool? ms_select = false;
  String? mv_select_str = "MV";
  String? ms_select_str = "MS";
  String? leave_description = "";
  TextEditingController controllerLeavedescription = TextEditingController();

  Widget text_form(
    String lable,
    IconData icon,
    TextEditingController controller,
    String? save,
    bool is_show,
    int? maxline,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        // initialValue: 'رمز',
        keyboardType: type,
        controller: controller,
        onSaved: (value) => save = value,
        obscureText: is_show,
        cursorColor: Colors.blue,
        maxLines: maxline,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          // errorText: erroetext,
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
          iconColor: Colors.grey,
        ),
      ),
    );
  }

  String? finalStartDate;
  String? finalEndDate;
  Future create_leave() async {
    print(dateRange_send);
    print(finalStartDate);
    print(finalEndDate);
    var body = jsonEncode({
      "user": id_user,
      "is_days": true,
      "is_clock": false,
      "days_select": select_choice,
      "manager_select": mv_select! ? mv_select_str : ms_select_str,
      "is_accept": false,
      "clock_leave_date": null,
      "days_start_date": finalStartDate,
      "days_end_date": finalEndDate,
      "clock_start_time": "",
      "clock_end_time": "",
      "description": controllerLeavedescription.text,
      "all_date": dateRange_send
    });
    String infourl = Helper.url.toString() + 'leave/create_leave';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 201) {
      // Map<String, dynamic> result = json.decode(response.body);
      setState(() {
        controllerLeavedescription.clear();
        // picked_to_selected = Jalali.now();
        // start_time = "00:00";
        // end_time = "00:00";
      });

      MyMessage.mySnackbarMessage(context, "فرم با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int daysInMonth(int year, int month) {
    if (month == 12) {
      // ماه 12 (اسفند) در سال کبیسه 30 روز دارد و در غیر این صورت 29 روز دارد.
      return (year % 4 == 3) ? 30 : 29;
    } else if (month >= 1 && month <= 6) {
      return 31; // ماه‌های 1 تا 6 (فروردین تا خرداد) 31 روز دارند
    } else {
      return 30; // ماه‌های 7 تا 11 (تیر تا آذر) 30 روز دارند
    }
  }
}
