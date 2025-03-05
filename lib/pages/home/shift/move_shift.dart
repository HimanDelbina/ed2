import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/get_all_user_service.dart';
import '../../../models/shift/shift_model.dart';
import '../../../static/helper_page.dart';

class MoveShiftPage extends StatefulWidget {
  const MoveShiftPage({super.key});

  @override
  State<MoveShiftPage> createState() => _MoveShiftPageState();
}

class _MoveShiftPageState extends State<MoveShiftPage> {
  List<ShiftModel>? data = [];
  bool? isGetData = false;
  final userService = UserService();
  String? formattedDate;

  Jalali? pickedDate;
  String? date_select = "";
  @override
  void initState() {
    super.initState();
    pickedDate = Jalali.now();
    formattedDate =
        "${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}";
    _getShiftDateUsers();
    get_user_data();
  }

  Future<void> _getShiftDateUsers() async {
    try {
      var users = await userService.getUserShiftByDate(formattedDate!);
      setState(() {
        data = users;
        isGetData = true;
      });
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? user_id;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefsUser.getInt("id") ?? 0;
    });
  }

  ShiftModel? selectedUser; // متغیری برای ذخیره کاربر انتخاب‌شده

  void selectUser(ShiftModel user) {
    setState(() {
      selectedUser = user; // فقط یک کاربر انتخاب شود
    });
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
              GestureDetector(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CupertinoButton(
                                    child: const Text('لغو',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoButton(
                                    child: const Text('تایید',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(tempPickedDate ?? Jalali.now());
                                      setState(() {
                                        formattedDate =
                                            "${tempPickedDate!.year}-${tempPickedDate!.month.toString().padLeft(2, '0')}-${tempPickedDate!.day.toString().padLeft(2, '0')}";
                                      });
                                      _getShiftDateUsers();
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
                child: Container(
                  width: my_width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("انتخاب تاریخ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
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
                    ],
                  ),
                ),
              ),
              const Divider(),
              Text(selectedTime == ""
                  ? "لطفا کاربر را برای ویرایش شیفت انتخاب کنید"
                  : "شما شیفت جدید ${selectedTime.toString()} را برای ${name} کردید در صورت درست بودن انتخاب برای ثبت دکمه تایید را انتخاب کنید"),
              const Divider(),
              Expanded(
                child: isGetData!
                    ? ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedUser ==
                              data![index]; // بررسی انتخاب‌شدن کاربر
                          return GestureDetector(
                            onTap: () {
                              selectUser(
                                  data![index]); // انتخاب کاربر هنگام کلیک
                              setState(() {
                                name =
                                    "${data![index].user!.firstName} ${data![index].user!.lastName}";
                                id = data![index].id;
                                shifts = data![index].daysSelect;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.withOpacity(0.1)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.withOpacity(0.5))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${data![index].user!.firstName} ${data![index].user!.lastName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          "تاریخ شیفت : ${FormateDateCreateChange.formatDate(data![index].shiftDate.toString())}")
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "شیفت این تاریخ کاربر : ${data![index].daysSelect == "SH" ? "شب" : data![index].daysSelect == "AS" ? "عصر" : data![index].daysSelect == "SO" ? "صبح" : ""}"),
                                      isSelected
                                          ? GestureDetector(
                                              onTap: _showTimeDialog,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5))),
                                                child: const Icon(
                                                    IconlyBold.edit,
                                                    color: Colors.black,
                                                    size: 20.0),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0)),
              ),
              GestureDetector(
                onTap: () {
                  changeShift();
                },
                child: Container(
                  padding:
                      const EdgeInsetsDirectional.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
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
        ),
      ),
    );
  }

  int? id;
  String? name = "";
  String? selectedTime = "";
  String? finalSelectedTime = "";
  String? shifts = "";

  void _showTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("انتخاب شیفت جدید"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              ListTile(
                title: const Text("صبح"),
                onTap: () {
                  Navigator.pop(context, "صبح");
                },
              ),
              ListTile(
                title: const Text("عصر"),
                onTap: () {
                  Navigator.pop(context, "عصر");
                },
              ),
              ListTile(
                title: const Text("شب"),
                onTap: () {
                  Navigator.pop(context, "شب");
                },
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedTime = value; // ذخیره مقدار انتخاب‌شده
        });
      }
    });
  }

  void change() {
    final timeMap = {"صبح": "SO", "عصر": "AS", "شب": "SH"};
    setState(() {
      finalSelectedTime = timeMap[selectedTime] ?? finalSelectedTime;
    });
  }

  Future changeShift() async {
    change();
    var body = jsonEncode({
      "shift": id,
      "days_select": finalSelectedTime,
      "user": selectedUser!.user!.id,
      "sender": user_id
    });
    String infourl = Helper.url.toString() + 'shift/request_change_shift_admin';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      _getShiftDateUsers();
      MyMessage.mySnackbarMessage(context, "شیفت با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 400) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
