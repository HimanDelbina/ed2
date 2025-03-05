import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/components/get_all_user_service.dart';
import 'package:ed/models/shift/shift_model.dart';
import 'package:ed/static/helper_page.dart';

class ChangeShiftPage extends StatefulWidget {
  const ChangeShiftPage({super.key});

  @override
  State<ChangeShiftPage> createState() => _ChangeShiftPageState();
}

class _ChangeShiftPageState extends State<ChangeShiftPage> {
  List<ShiftModel>? data = [];
  bool? isGetData = false;
  final userService = UserService();
  String? formattedDate;
  @override
  void initState() {
    super.initState();
    pickedDate = Jalali.now();
    formattedDate =
        "${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}";
    _getShiftDateUsers();
    get_user_data();
  }


  int?user_id;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefsUser.getInt("id") ?? 0;
    });
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

  Jalali? pickedDate;
  String? date_select = "";
  List<ShiftModel> selectedUsers = [];

  void toggleSelection(ShiftModel user) {
    setState(() {
      if (selectedUsers.any((u) => u.user!.id == user.user!.id)) {
        selectedUsers
            .removeWhere((u) => u.user!.id == user.user!.id); // حذف کاربر
      } else if (selectedUsers.length < 2) {
        selectedUsers.add(user); // اضافه کردن
      } else {
        // جایگزینی کاربر جدید
        selectedUsers[0] = selectedUsers[1];
        selectedUsers[1] = user;
      }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  userBox(selectedUsers.isNotEmpty ? selectedUsers[0] : null,
                      "کاربر اول"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Icon(Icons.swap_horiz_rounded, color: Colors.blue),
                  ),
                  userBox(selectedUsers.length > 1 ? selectedUsers[1] : null,
                      "کاربر دوم"),
                ],
              ),
              const Divider(),
              Expanded(
                child: isGetData!
                    ? ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          ShiftModel user = data![index];
                          bool isSelected = selectedUsers
                              .any((u) => u.user!.id == user.user!.id);
                          return GestureDetector(
                            onTap: () => toggleSelection(user),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          ? const Icon(Icons.check,
                                              color: Colors.green, size: 20.0)
                                          : const SizedBox()
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
                  swapShift();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.blue),
                  child: const Center(
                    child: Text(
                      "تایید",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

  Widget userBox(ShiftModel? user, String defaultText) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsetsDirectional.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Text(user != null
          ? "${user.user!.firstName} ${user.user!.lastName}"
          : defaultText),
    );
  }

  Future swapShift() async {
    var body = jsonEncode({
      "user1": selectedUsers[0].user!.id,
      "user2": selectedUsers[1].user!.id,
      "sender": user_id,
      "shift_date": formattedDate
    });
    String infourl = Helper.url.toString() + 'shift/shift_swap';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 200) {
      _getShiftDateUsers();
      MyMessage.mySnackbarMessage(context, "شیفت با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 400) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
