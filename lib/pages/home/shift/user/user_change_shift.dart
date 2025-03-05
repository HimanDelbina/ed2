import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/models/shift/shift_model.dart';
import '../../../../static/helper_page.dart';

class UserChangeShiftPage extends StatefulWidget {
  const UserChangeShiftPage({super.key});

  @override
  State<UserChangeShiftPage> createState() => _UserChangeShiftPageState();
}

class _UserChangeShiftPageState extends State<UserChangeShiftPage> {
  int? userID;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      userID = prefsUser.getInt("id") ?? 0;
    });
    get_shift_by_user_id();
  }

  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: PagePadding.page_padding,
            child: is_get_data!
                ? ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "شیفت : ${_getShiftName(data![index].daysSelect)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "تاریخ : ${FormateDateCreateChange.formatDate(data![index].shiftDate.toString())}",
                                  style: const TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                      "شما می‌توانید درخواست تعویض شیفت بدهید، و در صورت تأیید مدیر، شیفت شما تغییر خواهد کرد."),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      shiftID = data![index].id;
                                    });
                                    _showTimeDialog();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.only(right: 5.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        border: Border.all(color: Colors.grey)),
                                    child: const Icon(IconlyBold.edit,
                                        color: Colors.grey, size: 20.0),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0))),
      ),
    );
  }

  void _showTimeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // dialogContext برای بستن دیالوگ اصلی
        return AlertDialog(
          title: const Text("انتخاب شیفت جدید"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              ListTile(
                title: const Text("صبح"),
                onTap: () => _handleSelection(dialogContext, "SO"),
              ),
              ListTile(
                title: const Text("عصر"),
                onTap: () => _handleSelection(dialogContext, "AS"),
              ),
              ListTile(
                title: const Text("شب"),
                onTap: () => _handleSelection(dialogContext, "SH"),
              ),
            ],
          ),
        );
      },
    );
  }

// تابع مدیریت انتخاب
  Future<void> _handleSelection(
      BuildContext dialogContext, String selectedValue) async {
    // ذخیره مقدار انتخاب‌شده
    setState(() {
      selectedTime = selectedValue; // ذخیره مقدار انتخاب‌شده
    });

    // نمایش دیالوگ تایید
    bool shouldChangeShift = await _showConfirmationDialog(context);

    // اجرای changeShift() در صورت تایید
    if (shouldChangeShift) {
      changeShift();
    }

    // بستن دیالوگ اصلی
    Navigator.pop(dialogContext); // بستن دیالوگ اصلی
  }

// دیالوگ تایید
  Future<bool> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("تایید تغییر شیفت"),
          content: const Text(
              "آیا مطمئن هستید که می‌خواهید شیфт خود را تغییر دهید؟"),
          actions: <Widget>[
            TextButton(
              child: const Text("لغو"),
              onPressed: () =>
                  Navigator.pop(context, false), // بازگشت بدون تایید
            ),
            TextButton(
              child: const Text("بله"),
              onPressed: () => Navigator.pop(context, true), // تایید
            ),
          ],
        );
      },
    ).then((value) =>
        value ?? false); // اگر دیالوگ بسته شود، false برگردانده می‌شود
  }

  String _getShiftName(String? shiftCode) {
    switch (shiftCode) {
      case "SH":
        return "شب";
      case "AS":
        return "عصر";
      case "SO":
        return "صبح";
      default:
        return "نامشخص";
    }
  }

  List? data = [];
  bool? is_get_data = false;
  String? infourl;
  Future get_shift_by_user_id() async {
    infourl = Helper.url.toString() + 'shift/get_shift_by_user_id/${userID}/';

    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(infourl);
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = shiftModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? shiftID;
  String? selectedTime;

  Future changeShift() async {
    var body = jsonEncode({"shift": shiftID, "days_select": selectedTime});
    String infourl = Helper.url.toString() + 'shift/request_change_shift';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      // _getShiftDateUsers();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 400) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
