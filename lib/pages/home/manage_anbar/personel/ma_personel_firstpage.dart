import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../models/users/user_shift_model.dart';
import '../../../../static/helper_page.dart';

class ManagerAnbarPersonelFirstPage extends StatefulWidget {
  const ManagerAnbarPersonelFirstPage({super.key});

  @override
  State<ManagerAnbarPersonelFirstPage> createState() =>
      _ManagerAnbarPersonelFirstPageState();
}

class _ManagerAnbarPersonelFirstPageState
    extends State<ManagerAnbarPersonelFirstPage> {
  int? unit_id = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      unit_id = prefsUser.getInt("unit_id") ?? 0;
    });
    get_user_by_unit_id(unit_id!);
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
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
              : data!.isEmpty
                  ? const Center(child: Text("داده ای وجود ندارد"))
                  : ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              id_select = data![index].shifts[0].id;
                            });
                            showCustomDialog(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${data![index].firstName} ${data![index].lastName}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      data![index].isActive
                                          ? "فعال"
                                          : "غیر فعال",
                                      style: TextStyle(
                                        color: data![index].isActive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                                data![index].shifts.isEmpty
                                    ? const Text("برای کاربر شیفت تعیین نشده")
                                    : Text(
                                        "شیفت امروز : ${data![index].shifts[0].daysSelect == "SO" ? "صبح" : data![index].shifts[0].daysSelect == "AS" ? "عصر" : data![index].shifts[0].daysSelect == "SH" ? "شب" : ""} -- تاریخ : ${FormateDateCreateChange.formatDate(data![index].shifts[0].shiftDate.toString())}")
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_user_by_unit_id(int id) async {
    String infourl = Helper.url.toString() + 'user/get_user_by_unit_id/${id}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = userShiftModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  bool? is_so = false;
  bool? is_as = false;
  bool? is_sh = false;
  String? days_select = '';
  int? id_select;
  Future edit_shift(int pk) async {
    var body = jsonEncode({"days_select": days_select});
    String infourl = Helper.url.toString() + 'shift/edit_shift_data/${pk}';
    print(infourl);
    print(body);
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
      get_user_by_unit_id(unit_id!);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  void showCustomDialog(BuildContext context) {
    String? selectedShift; // متغیر موقتی برای ذخیره انتخاب

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // برای مدیریت تغییرات در داخل دیالوگ
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text("تغییر شیفت کاری"),
              content: const Text("لطفاً یکی از شیفت‌ها را انتخاب کنید."),
              actions: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedShift = "SO";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: selectedShift == "SO"
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Text("شیفت صبح"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedShift = "AS";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: selectedShift == "AS"
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Text("شیفت عصر"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedShift = "SH";
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: selectedShift == "SH"
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Text("شیفت شب"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        if (selectedShift != null) {
                          // مقدار انتخاب‌شده را به متغیر اصلی منتقل کنید
                          setState(() {
                            days_select = selectedShift!;
                            is_so = selectedShift == "SO";
                            is_as = selectedShift == "AS";
                            is_sh = selectedShift == "SH";
                          });
                          Navigator.of(context).pop();
                          edit_shift(id_select!);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: const Center(
                          child: Text(
                            "تایید",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}
