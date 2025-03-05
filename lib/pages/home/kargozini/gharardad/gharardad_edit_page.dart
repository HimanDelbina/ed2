import 'dart:convert';

import 'package:ed/pages/home/kargozini/gharardad/gharardad_page.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:http/http.dart' as http;

class GharadadEditPage extends StatefulWidget {
  var data;
  GharadadEditPage({super.key, this.data});

  @override
  State<GharadadEditPage> createState() => _GharadadEditPageState();
}

class _GharadadEditPageState extends State<GharadadEditPage> {
  Jalali? pickedDateStart;
  Jalali? pickedDateEnd;
  String? date_select_start = "";
  String? date_select_end = "";

  @override
  void initState() {
    super.initState();
    pickedDateStart = convertStringToJalali(widget.data.startDate.toString());
    pickedDateEnd = convertStringToJalali(widget.data.endDate.toString());
    controllerMoney.text = widget.data.money.toString();
    money = widget.data.money.toString();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: my_height * 0.06,
                width: my_width,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0)),
                child: ListTile(
                  onTap: () async {
                    pickedDateStart = await showModalBottomSheet<Jalali>(
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

                    if (pickedDateStart != null) {
                      setState(() {
                        date_select_start = '${pickedDateStart!.toDateTime()}';
                      });
                    }
                  },
                  title: const Text(
                    "تاریخ شروع قرارداد",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    pickedDateStart!
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
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  height: my_height * 0.06,
                  width: my_width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: ListTile(
                    onTap: () async {
                      pickedDateEnd = await showModalBottomSheet<Jalali>(
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

                      if (pickedDateEnd != null) {
                        setState(() {
                          date_select_end = '${pickedDateEnd!.toDateTime()}';
                        });
                      }
                    },
                    title: const Text(
                      "تاریخ پایان قرارداد",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      pickedDateEnd!
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
              ),
              my_form(controllerMoney, money, "حقوق پایه", false,
                  Icons.attach_money, TextInputType.number),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "${controllerMoney.text.toString().beToman().toPersianDigit().seRagham()} تومان"),
                  Text(
                      "${controllerMoney.text.toString().toPersianDigit().seRagham()} ریال"),
                ],
              ),
              Text("${controllerMoney.text.toString().toWord()} ریال"),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  edit_user();
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
                      "تایید",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
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

  String? money = "";
  TextEditingController controllerMoney = TextEditingController();
  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        onChanged: (value) {
          setState(() {
            controller.text = value;
          });
        },
        keyboardType: type,
        obscureText: is_show,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
        ),
      ),
    );
  }

  Jalali convertStringToJalali(String dateStr) {
    // تقسیم تاریخ و زمان
    List<String> parts = dateStr.split(" ");
    String datePart = parts[0]; // تاریخ بدون زمان

    // تقسیم روز، ماه و سال
    List<String> dateComponents = datePart.split("-");
    int year = int.parse(dateComponents[0]);
    int month = int.parse(dateComponents[1]);
    int day = int.parse(dateComponents[2]);

    // ایجاد شیء Jalali
    return Jalali(year, month, day);
  }

  Future edit_user() async {
    var jalaliStartDate = pickedDateStart!.formatter.yyyy +
        '-' +
        pickedDateStart!.formatter.mm +
        '-' +
        pickedDateStart!.formatter.dd +
        ' ' +
        '00:00';
    var jalaliEndDate = pickedDateEnd!.formatter.yyyy +
        '-' +
        pickedDateEnd!.formatter.mm +
        '-' +
        pickedDateEnd!.formatter.dd +
        ' ' +
        '00:00';
    var body = jsonEncode({
      "id": widget.data.id,
      "start_date": jalaliStartDate,
      "end_date": jalaliEndDate,
      "money": controllerMoney.text
    });
    String infourl = Helper.url.toString() + 'gharardad/edit_gharardad';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GharardadPage(),
          ));

      MyMessage.mySnackbarMessage(context, "کاربر با موفقیت تغییر شد", 1);
    } else if (response.statusCode == 226) {
      MyMessage.mySnackbarMessage(context, "شماره موبایل تکراری است", 1);
    } else if (response.statusCode == 208) {
      MyMessage.mySnackbarMessage(context, "کد پرسنلی تکراری است", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
