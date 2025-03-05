import 'dart:convert';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OvertimeHome extends StatefulWidget {
  const OvertimeHome({super.key});

  @override
  State<OvertimeHome> createState() => _OvertimeHomeState();
}

class _OvertimeHomeState extends State<OvertimeHome> {
  Jalali? picked_to = Jalali.now();
  Jalali? picked_to_selected = Jalali.now();
  Jalali? pickedDate = Jalali.now();

  String? start_time = "00:00";
  String? end_time = "00:00";
  String? date_select = "";

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

  @override
  void initState() {
    get_user_data();
    checkTime();
    super.initState();
  }

  bool? is_ezafe = true;
  bool? is_gome = false;
  bool? is_tatil = false;
  bool? is_mamoriat = false;
  bool? is_unitManager = true;
  bool? is_salonManager = false;
  void checkTime() {
    final now = DateTime.now();
    if (now.hour >= 14) {
      setState(() {
        is_unitManager = false;
        is_salonManager = true;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: group_name == "کنترل کیفیت" ||
                    group_name == "اداری" ||
                    group_name == "نگهبانی"
                ? show_filter_manager(
                    "مدیر واحد",
                    is_unitManager,
                    () {
                      setState(() {
                        is_unitManager = true;
                        is_salonManager = false;
                      });
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      show_filter_manager(
                        "مدیر واحد",
                        is_unitManager,
                        () {
                          setState(() {
                            is_unitManager = true;
                            is_salonManager = false;
                          });
                        },
                      ),
                      show_filter_manager(
                        "مدیر سالن",
                        is_salonManager,
                        () {
                          setState(() {
                            is_unitManager = false;
                            is_salonManager = true;
                          });
                        },
                      ),
                    ],
                  ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                show_filter(
                  "اضافه کاری",
                  is_ezafe,
                  () {
                    setState(() {
                      is_ezafe = true;
                      is_gome = false;
                      is_tatil = false;
                      is_mamoriat = false;
                    });
                  },
                ),
                show_filter(
                  "جمعه کاری",
                  is_gome,
                  () {
                    setState(() {
                      is_ezafe = false;
                      is_gome = true;
                      is_tatil = false;
                      is_mamoriat = false;
                    });
                  },
                ),
                show_filter(
                  "تعطیل کاری",
                  is_tatil,
                  () {
                    setState(() {
                      is_ezafe = false;
                      is_gome = false;
                      is_tatil = true;
                      is_mamoriat = false;
                    });
                  },
                ),
                show_filter(
                  "ماموریت",
                  is_mamoriat,
                  () {
                    setState(() {
                      is_ezafe = false;
                      is_gome = false;
                      is_tatil = false;
                      is_mamoriat = true;
                    });
                  },
                ),
              ],
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
                //     print(formattedStartTime);
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
          const Spacer(),
          GestureDetector(
            onTap: () {
              create_mission();
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

  String? leave_description = "";
  TextEditingController controllerLeavedescription = TextEditingController();
  String? formattedStartTime = "";
  String? formattedEndTime = "";
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

  Widget show_filter_manager(
      String? title, bool? is_select, VoidCallback ontap) {
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

  Future create_mission() async {
    var jalaliDate = pickedDate!.formatter.yyyy +
        '-' +
        pickedDate!.formatter.mm +
        '-' +
        pickedDate!.formatter.dd +
        ' ' +
        formattedStartTime!;
    var body = jsonEncode({
      "user": id_user,
      "is_accept": false,
      "select": is_ezafe!
          ? "EZ"
          : is_gome!
              ? "GO"
              : is_tatil!
                  ? "TA"
                  : is_mamoriat!
                      ? "MA"
                      : "",
      "overtime_date": jalaliDate,
      "manager_accept": is_unitManager,
      "salon_accept": is_salonManager,
      "start_time": formattedStartTime!.toEnglishDigit(),
      "end_time": formattedEndTime!.toEnglishDigit(),
      "description": controllerLeavedescription.text
    });
    String infourl = Helper.url.toString() + 'overtime/create_overtime';
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
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
