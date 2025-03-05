import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../static/helper_page.dart';

class LeaveClockPage extends StatefulWidget {
  const LeaveClockPage({super.key});

  @override
  State<LeaveClockPage> createState() => _LeaveClockPageState();
}

class _LeaveClockPageState extends State<LeaveClockPage> {
  Jalali? picked_to = Jalali.now();
  Jalali? picked_to_selected = Jalali.now();

  @override
  void initState() {
    super.initState();
    get_user_data();
    checkTime();
  }

  String? start_time = "00:00";

  String? end_time = "00:00";

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
          Container(
            height: my_height * 0.06,
            width: my_width,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0)),
            child: ListTile(
              onTap: () async {
                pickedDate = await showModalBottomSheet<Jalali>(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    Navigator.of(context)
                                        .pop(tempPickedDate ?? Jalali.now());
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

                if (pickedDate != null) {
                  setState(() {
                    date_select = '${pickedDate!.toDateTime()}';
                  });
                }
              },
              title: const Text(
                "انتخاب تاریخ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                pickedDate!
                    .toGregorian()
                    .toDateTime()
                    .toIso8601String()
                    .toPersianDate(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              height: my_height * 0.06,
              width: my_width,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.0)),
              child: ListTile(
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!,
                      );
                    },
                  );

                  if (pickedTime != null) {
                    setState(() {
                      // تبدیل TimeOfDay به String
                      final DateTime now = DateTime.now();
                      final DateTime combinedDateTime = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      start_time = combinedDateTime
                          .toIso8601String(); // ذخیره تاریخ و زمان
                      formattedStartTime = DateFormat.Hm()
                          .format(combinedDateTime); // تنظیم فرمت ساعت
                    });
                  }
                },
                // onTap: () async {
                //   Jalali? pickedDate = await showModalBottomSheet<Jalali>(
                //     context: context,
                //     builder: (context) {
                //       Jalali? tempPickedDate;
                //       return Container(
                //         height: 250,
                //         color: Colors.blue,
                //         child: Column(
                //           children: <Widget>[
                //             Container(
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: <Widget>[
                //                   CupertinoButton(
                //                     child: const Text(
                //                       'لغو',
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.bold),
                //                     ),
                //                     onPressed: () {
                //                       Navigator.of(context).pop();
                //                     },
                //                   ),
                //                   CupertinoButton(
                //                     child: const Text(
                //                       'تایید',
                //                       style: TextStyle(
                //                         color: Colors.white,
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     ),
                //                     onPressed: () {
                //                       print(tempPickedDate ?? Jalali.now());

                //                       Navigator.of(context)
                //                           .pop(tempPickedDate ?? Jalali.now());
                //                     },
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             const Divider(height: 0, thickness: 1),
                //             Expanded(
                //               child: Container(
                //                 child: PCupertinoDatePicker(
                //                   mode: PCupertinoDatePickerMode.time,
                //                   onDateTimeChanged: (Jalali dateTime) {
                //                     tempPickedDate = dateTime;
                //                   },
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   );

                //   if (pickedDate != null) {
                //     setState(() {
                //       start_time = '${pickedDate.toJalaliDateTime()}';
                //       formattedStartTime =
                //           DateFormat.Hm().format(DateTime.parse(start_time!));
                //     });
                //   }
                // },
                title: const Text(
                  "از ساعت",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  formattedStartTime!.toString().toPersianDigit(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16.0),
                ),
              ),
            ),
          ),
          Container(
            height: my_height * 0.06,
            width: my_width,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5.0)),
            child: ListTile(
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );

                if (pickedTime != null) {
                  setState(() {
                    // تبدیل TimeOfDay به String
                    final DateTime now = DateTime.now();
                    final DateTime combinedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );

                    end_time = combinedDateTime
                        .toIso8601String(); // ذخیره تاریخ و زمان
                    formattedEndTime = DateFormat.Hm()
                        .format(combinedDateTime); // تنظیم فرمت ساعت
                  });
                }
              },
              // onTap: () async {
              //   Jalali? pickedDate = await showModalBottomSheet<Jalali>(
              //     context: context,
              //     builder: (context) {
              //       Jalali? tempPickedDate;
              //       return Container(
              //         height: 250,
              //         color: Colors.blue,
              //         child: Column(
              //           children: <Widget>[
              //             Container(
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: <Widget>[
              //                   CupertinoButton(
              //                     child: const Text(
              //                       'لغو',
              //                       style: TextStyle(
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     },
              //                   ),
              //                   CupertinoButton(
              //                     child: const Text(
              //                       'تایید',
              //                       style: TextStyle(
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     onPressed: () {
              //                       print(tempPickedDate ?? Jalali.now());

              //                       Navigator.of(context)
              //                           .pop(tempPickedDate ?? Jalali.now());
              //                     },
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             const Divider(height: 0, thickness: 1),
              //             Expanded(
              //               child: Container(
              //                 child: PCupertinoDatePicker(
              //                   mode: PCupertinoDatePickerMode.time,
              //                   onDateTimeChanged: (Jalali dateTime) {
              //                     tempPickedDate = dateTime;
              //                   },
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     },
              //   );

              //   if (pickedDate != null) {
              //     setState(() {
              //       end_time = '${pickedDate.toJalaliDateTime()}';
              //       formattedEndTime =
              //           DateFormat.Hm().format(DateTime.parse(end_time!));
              //     });
              //   }
              // },
              title: const Text(
                "تا ساعت",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                formattedEndTime!.toString().toPersianDigit(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16.0),
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
  Jalali? pickedDate = Jalali.now();
  String? date_select = "";
  String? formattedStartTime = "";
  String? formattedEndTime = "";
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

  Future create_leave() async {
    var jalaliDate = pickedDate!.formatter.yyyy +
        '-' +
        pickedDate!.formatter.mm +
        '-' +
        pickedDate!.formatter.dd +
        ' ' +
        formattedStartTime!;
    var body = jsonEncode({
      "user": id_user,
      "is_days": false,
      "is_clock": true,
      "days_select": null,
      "manager_select": mv_select! ? mv_select_str : ms_select_str,
      "is_accept": false,
      "clock_leave_date": jalaliDate,
      "days_start_date": null,
      "days_end_date": null,
      "clock_start_time": formattedStartTime!.toEnglishDigit(),
      "clock_end_time": formattedEndTime!.toEnglishDigit(),
      "description": controllerLeavedescription.text
    });
    String infourl = Helper.url.toString() + 'leave/create_leave';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 201) {
      setState(() {
        controllerLeavedescription.clear();
        picked_to_selected = Jalali.now();
        start_time = "00:00";
        end_time = "00:00";
      });

      MyMessage.mySnackbarMessage(context, "فرم با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String formatGregorianDate(Jalali pickedDate) {
    final gregorianDate = pickedDate.toGregorian();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(gregorianDate.toDateTime());
  }
}
