import 'dart:convert';

import 'package:ed/static/helper_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FoodHomePage extends StatefulWidget {
  const FoodHomePage({super.key});

  @override
  State<FoodHomePage> createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  bool? is_nahar = true;
  bool? is_sobhane = false;
  bool? is_sham = false;
  String? selected_lunch = "NA";
  Jalali? pickedDate = Jalali.now();
  String? date_select = "";
  String? selected_manager = "MV";
  bool? is_manager = true;
  bool? is_salon_manager = false;

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
    super.initState();
    get_user_data();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                show_filter(
                  "صبحانه",
                  is_sobhane,
                  () {
                    setState(() {
                      is_sobhane = true;
                      is_nahar = false;
                      is_sham = false;
                      selected_lunch = "SO";
                    });
                  },
                ),
                show_filter(
                  "نهار",
                  is_nahar,
                  () {
                    setState(() {
                      is_sobhane = false;
                      is_nahar = true;
                      is_sham = false;
                      selected_lunch = "NA";
                    });
                  },
                ),
                show_filter(
                  "شام",
                  is_sham,
                  () {
                    setState(() {
                      is_sobhane = false;
                      is_nahar = false;
                      is_sham = true;
                      selected_lunch = "SH";
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
          text_form("توضیحات", IconlyBold.paper, controllerfooddescription,
              food_description, false, 3, TextInputType.name),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: group_name == "کنترل کیفیت" ||
                    group_name == "اداری" ||
                    group_name == "نگهبانی"
                ? show_manager_filter(
                    "مدیر واحد",
                    is_manager,
                    () {
                      setState(() {
                        is_manager = true;
                        is_salon_manager = false;
                        selected_manager = "MV";
                      });
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      show_manager_filter(
                        "مدیر واحد",
                        is_manager,
                        () {
                          setState(() {
                            is_manager = true;
                            is_salon_manager = false;
                            selected_manager = "MV";
                          });
                        },
                      ),
                      show_manager_filter(
                        "مدیر سالن",
                        is_salon_manager,
                        () {
                          setState(() {
                            is_manager = false;
                            is_salon_manager = true;
                            selected_manager = "MS";
                          });
                        },
                      ),
                    ],
                  ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              create_food();
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

  Widget show_filter(String? title, bool? is_select, VoidCallback ontap) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: my_width * 0.22,
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
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal,
                fontSize: is_select ? 16.0 : 14.0),
          ),
        ),
      ),
    );
  }

  Widget show_manager_filter(
      String? title, bool? is_select, VoidCallback ontap) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: my_width * 0.4,
        height: my_height * 0.05,
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
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal,
                fontSize: is_select ? 18.0 : 16.0),
          ),
        ),
      ),
    );
  }

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

  Jalali? picked_to_selected = Jalali.now();
  String? formattedStartTime = "";
  String? food_description = "";
  TextEditingController controllerfooddescription = TextEditingController();
  Future create_food() async {
    // زمان فعلی به میلادی
    var now = DateTime.now();

    // زمان 12:30 را تنظیم کنید
    var cutoffTime = DateTime(now.year, now.month, now.day, 12, 10);
    // بررسی اینکه زمان فعلی از 12:30 گذشته باشد
    if (now.isAfter(cutoffTime)) {
      MyMessageError.mySnackbarMessage(
          context,
          "بعد از ساعت ${12.toString().toPersianDigit()}:${30.toString().toPersianDigit()} امکان ارسال درخواست غدا وجود ندارد",
          5);
      return; // اجرای کد متوقف می‌شود
    }

    // ایجاد تاریخ جلالی برای ارسال
    if (pickedDate == null) {
      MyMessage.mySnackbarMessage(context, "تاریخ انتخاب نشده است", 1);
      return;
    }
    var jalaliDate = pickedDate!.formatter.yyyy +
        '-' +
        pickedDate!.formatter.mm +
        '-' +
        pickedDate!.formatter.dd +
        ' ' +
        "00:00";
    var body = jsonEncode({
      "user": id_user,
      "lunch_select": selected_lunch,
      "manager_select": selected_manager,
      "is_accept": false,
      "food_date": jalaliDate,
      "manager_accept": false,
      "salon_accept": false,
      "description": controllerfooddescription.text
    });
    String infourl = Helper.url.toString() + 'food/create_food';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      setState(() {
        controllerfooddescription.clear();
      });

      MyMessage.mySnackbarMessage(context, "فرم با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
