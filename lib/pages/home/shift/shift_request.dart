import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../models/shift/change_shift_request_model.dart';
import '../../../models/shift/get_change_shift_model.dart';
import '../../../static/helper_page.dart';

class ShiftRequestPage extends StatefulWidget {
  const ShiftRequestPage({super.key});

  @override
  State<ShiftRequestPage> createState() => _ShiftRequestPageState();
}

class _ShiftRequestPageState extends State<ShiftRequestPage> {
  int? userID;
  int? unitID;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      userID = prefsUser.getInt("id") ?? 0;
      unitID = prefsUser.getInt("unit_id") ?? 0;
    });
    get_change_shift_report();
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
              ? status == "404"
                  ? const Center(child: Text("داده ای وجود ندارد"))
                  : ListView.builder(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "درخواست کننده : ${data![index].shift.user.firstName} ${data![index].shift.user.lastName}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(FormateDateCreate.formatDate(
                                      data![index].shift.shiftDate.toString()))
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "شیفت فعلی : ${_getShiftName(data![index].shift.daysSelect)}"),
                                  Text(
                                      "شیفت جدید : ${_getShiftName(data![index].daysSelect)}"),
                                ],
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      changeShift(data![index].id, "approve");
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 5.0),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: const Text(
                                          "تایید",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      changeShift(data![index].id, "reject");
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 5.0),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: const Text(
                                        "لغو",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
              : Center(
                  child:
                      Lottie.asset("assets/lottie/loading.json", height: 40.0)),
        ),
      ),
    );
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

  String _getStatusName(String? status) {
    switch (status) {
      case "pending":
        return "در انتظار تایید";
      case "approved":
        return "تایید شده";
      case "rejected":
        return "رد شده";
      default:
        return "نامشخص";
    }
  }

  String? status = "";
  List? data = [];
  bool? is_get_data = false;
  String? infourl;
  Future get_change_shift_report() async {
    infourl = Helper.url.toString() +
        'shift/get_changeshift_for_unitID/?unit=${unitID}';

    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(infourl);
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = changeShiftRequestModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else if (response.statusCode == 404) {
      setState(() {
        is_get_data = true;
        status = response.statusCode.toString();
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future changeShift(int? shiftID, String? data) async {
    var body = jsonEncode({"action": data});
    String infourl = Helper.url.toString() +
        'shift/approve_or_reject_shift_request/${shiftID}';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 200) {
      get_change_shift_report();
      MyMessage.mySnackbarMessage(
          context, "درخواست شما با موفقیت ${_getStatusName(data)}", 1);
    } else if (response.statusCode == 400) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
