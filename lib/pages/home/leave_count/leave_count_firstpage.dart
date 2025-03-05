import 'dart:convert';

import 'package:ed/components/count_widget.dart';
import 'package:ed/models/leave_count/leave_count_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../static/helper_page.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:iconly/iconly.dart';

class LeaveCountFirstPage extends StatefulWidget {
  const LeaveCountFirstPage({super.key});

  @override
  State<LeaveCountFirstPage> createState() => _LeaveCountFirstPageState();
}

class _LeaveCountFirstPageState extends State<LeaveCountFirstPage> {
  @override
  void initState() {
    get_leave_count();
    super.initState();
  }

  var show_data_Search = [];
  TextEditingController user_search_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            children: [
              Container(
                width: my_width,
                child: TextFormField(
                  controller: user_search_controller,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        data = SearcUserGuard.search(
                            show_data_Search, value, "firstName");
                      });
                    });
                  },
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.blue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "جستجو",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(IconlyBold.search),
                    suffixIconColor: Colors.grey,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: data!.isNotEmpty
                    ? ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          user_search_controller.text == ""
                              ? data = data_show
                              : data = data;
                          show_data_Search = data_show!;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${data![index].user.firstName} ${data![index].user.lastName}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 5.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Text(
                                        "${data![index].days.toString().toPersianDigit()} روز",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          leaveID = data![index].id;
                                          daysController.clear();
                                        });
                                        showEditDialog();
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          margin: const EdgeInsets.only(
                                              right: 15.0),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5)),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: const Icon(IconlyBold.edit,
                                              size: 20.0, color: Colors.blue)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List? data = [];
  List? data_show = [];
  bool is_get_data = false;
  Future<void> get_leave_count() async {
    try {
      String infourl = Helper.url.toString() + 'leave/get_all_leave_count';
      var response = await http.get(Uri.parse(infourl), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        var recive_data = leaveCountModelFromJson(response.body);
        setState(() {
          data = recive_data;
          data_show = recive_data;
          is_get_data = true;
        });
      } else {
        throw Exception("خطا در دریافت اطلاعات");
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده: ${e.toString()}", 1);
    }
  }

  int? leaveID;
  TextEditingController daysController = TextEditingController();
  Future edit_shop() async {
    var body = jsonEncode({"days": daysController.text});

    String infourl =
        Helper.url.toString() + 'leave/edit_leave_count/${leaveID}';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      get_leave_count();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  // نمایش Dialog برای وارد کردن تعداد روزهای جدید
  void showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ویرایش تعداد روزها"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: daysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "تعداد روزها",
                  hintText: "تعداد روزهای مرخصی را وارد کنید",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // بستن دیالوگ
              },
              child: const Text(
                "لغو",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                if (daysController.text.isEmpty) {
                  MyMessage.mySnackbarMessage(
                      context, "لطفاً تعداد روزها را وارد کنید", 1);
                } else {
                  edit_shop(); // فراخوانی تابع ویرایش
                  Navigator.of(context).pop(); // بستن دیالوگ پس از ارسال
                }
              },
              child: const Text(
                "تایید",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }
}
