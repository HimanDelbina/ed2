import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/loan/loan_model.dart';
import '../../../static/helper_page.dart';

class LoanReportPage extends StatefulWidget {
  const LoanReportPage({super.key});

  @override
  State<LoanReportPage> createState() => _LoanReportPageState();
}

class _LoanReportPageState extends State<LoanReportPage> {
  int? id_user = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
    });
    get_loan_by_user_id();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data!
          ? ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                String date = data![index].createAt.toString();
                String? onlyDate = date.split(' ')[0];
                String kar_date = data![index].createAt.toString();
                String? karDateOnlyDate = kar_date.split(' ')[0];
                String manager_date = data![index].createAt.toString();
                String? managerOnlyDate = manager_date.split(' ')[0];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    // color: data![index].isKargoziniAccept &&
                    //         data![index].isManagerAccept == false
                    //     ? Colors.amber.withOpacity(0.1)
                    //     : data![index].isKargoziniAccept &&
                    //             data![index].isManagerAccept
                    //         ? Colors.green.withOpacity(0.1)
                    //         : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${data![index].user.firstName} ${data![index].user.lastName}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "تاریخ درخواست : ${FormateDate.formatDate(onlyDate)}",
                            style: const TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                      const Divider(),
                      Text(
                          "درخواست شما ارسال شده و در حال بررسی میباشد . تاییدیه شما شامل ${2.toString().toPersianDigit()} مرحله است . لطفا تا تایید نهایی منتظر باشید"),
                      const Divider(),
                      Text(
                        data![index].isKargozini &&
                                data![index].isKargoziniAccept
                            ? "مرحله ${1.toString().toPersianDigit()} : درخواست شما در ${FormateDate.formatDate(karDateOnlyDate)} توسط کاگزینی تایید شد"
                            : data![index].isKargozini &&
                                    data![index].isKargoziniAccept == false
                                ? "مرحله ${1.toString().toPersianDigit()} : درخواست شما در ${FormateDate.formatDate(karDateOnlyDate)} توسط کاگزینی رد شد"
                                : "مرحله ${1.toString().toPersianDigit()} : درخواست شما در حال بررسی توسط کارگزینی میباشد",
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: data![index].isKargozini &&
                                    data![index].isKargoziniAccept
                                ? const Icon(Icons.check, size: 15.0)
                                : const Icon(Icons.clear, size: 15.0),
                          ),
                          Text(
                            "تاییدیه کارگزینی : ${data![index].isKargozini && data![index].isKargoziniAccept ? "تایید شد" : data![index].isKargozini && data![index].isKargoziniAccept == false ? "رد شد" : "هنوز تایید نشده"} ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: data![index].isKargozini &&
                                        data![index].isKargoziniAccept
                                    ? Colors.green
                                    : data![index].isKargozini &&
                                            data![index].isKargoziniAccept ==
                                                false
                                        ? Colors.red
                                        : Colors.blue),
                          ),
                        ],
                      ),
                      data![index].isKargozini &&
                              data![index].isKargoziniAccept == false
                          ? Text(
                              "مرحله ${2.toString().toPersianDigit()} : درخواست شما در ${FormateDate.formatDate(managerOnlyDate)} توسط مدیریت رد شد")
                          : Text(
                              data![index].isManager &&
                                      data![index].isManagerAccept
                                  ? "مرحله ${2.toString().toPersianDigit()} : درخواست شما در ${FormateDate.formatDate(managerOnlyDate)} توسط مدیریت تایید شد"
                                  : data![index].isManager &&
                                          data![index].isManagerAccept == false
                                      ? "مرحله ${2.toString().toPersianDigit()} : درخواست شما در ${FormateDate.formatDate(managerOnlyDate)} توسط مدیریت رد شد"
                                      : "مرحله ${2.toString().toPersianDigit()} : درخواست شما در حال بررسی توسط مدیریت میباشد",
                            ),
                      data![index].isKargozini &&
                              data![index].isKargoziniAccept == false
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: data![index].isManager &&
                                          data![index].isManagerAccept
                                      ? const Icon(Icons.check, size: 15.0)
                                      : const Icon(Icons.clear, size: 15.0),
                                ),
                                const Text(
                                  "تاییدیه مدیریت : رد شد",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: data![index].isManager &&
                                          data![index].isManagerAccept
                                      ? const Icon(Icons.check, size: 15.0)
                                      : const Icon(Icons.clear, size: 15.0),
                                ),
                                Text(
                                  "تاییدیه مدیریت : ${data![index].isManager && data![index].isManagerAccept ? "تایید شد" : data![index].isManager && data![index].isManagerAccept == false ? "رد شد" : "هنوز تایید نشده"} ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: data![index].isManager &&
                                              data![index].isManagerAccept
                                          ? Colors.green
                                          : data![index].isManager &&
                                                  data![index]
                                                          .isManagerAccept ==
                                                      false
                                              ? Colors.red
                                              : Colors.blue),
                                ),
                              ],
                            ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0),
            ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_loan_by_user_id() async {
    String infourl = Helper.url.toString() +
        'loan/get_loan_by_user_id/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = loanModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
