import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/models/shift/get_change_shift_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;

class UserChangeShiftReportPage extends StatefulWidget {
  const UserChangeShiftReportPage({super.key});

  @override
  State<UserChangeShiftReportPage> createState() =>
      _UserChangeShiftReportPageState();
}

class _UserChangeShiftReportPageState extends State<UserChangeShiftReportPage> {
  int? userID;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      userID = prefsUser.getInt("id") ?? 0;
    });
    get_change_shift_report();
  }

  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  bool? isAll = false;
  bool? isPending = true;
  bool? isReject = false;
  bool? isAccept = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              filterItem(
                "همه",
                isAll,
                () {
                  setState(() {
                    isAll = true;
                    isPending = false;
                    isReject = false;
                    isAccept = false;
                    is_get_data = false;
                    status = "";
                  });
                  get_change_shift_report();
                },
              ),
              filterItem(
                "در انتظار تایید",
                isPending,
                () {
                  setState(() {
                    isAll = false;
                    isPending = true;
                    isReject = false;
                    isAccept = false;
                    is_get_data = false;
                    status = "";
                  });
                  get_change_shift_report();
                },
              ),
              filterItem(
                "تایید شده",
                isAccept,
                () {
                  setState(() {
                    isAll = false;
                    isPending = false;
                    isReject = false;
                    isAccept = true;
                    is_get_data = false;
                    status = "";
                  });
                  get_change_shift_report();
                },
              ),
              filterItem(
                "رد شده",
                isReject,
                () {
                  setState(() {
                    isAll = false;
                    isPending = false;
                    isReject = true;
                    isAccept = false;
                    is_get_data = false;
                    status = "";
                  });
                  get_change_shift_report();
                },
              ),
            ],
          ),
          const Divider(),
          Expanded(
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
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getStatusName(
                                          data![index].approvalStatus),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: data![index].approvalStatus ==
                                                "approved"
                                            ? Colors.green
                                            : data![index].approvalStatus ==
                                                    "rejected"
                                                ? Colors.red
                                                : data![index].approvalStatus ==
                                                        "pending"
                                                    ? Colors.blue
                                                    : Colors.black,
                                      ),
                                    ),
                                    Text(
                                        "تاریخ ارسال : ${FormateDateCreateChange.formatDate(data![index].createAt.toString())}")
                                  ],
                                ),
                                const Divider(),
                                Text(
                                    "درخواست تغییر شیفت از شیفت ${_getShiftName(data![index].daysSelect)} به شیفت ${_getShiftName(data![index].shift.daysSelect)} در تاریخ ${FormateDateCreateChange.formatDate(data![index].shift.shiftDate.toString())} ثبت شده لطفا منتظر تاییدیه مدیریت باشید ."),
                              ],
                            ),
                          );
                        },
                      )
                : Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0)),
          ),
        ],
      ),
    );
  }

  Widget filterItem(String? title, bool? is_select, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
          color: is_select! ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Text(
          title!,
          style: TextStyle(
              color: is_select ? Colors.white : Colors.black,
              fontWeight: is_select ? FontWeight.bold : FontWeight.normal),
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

  List? data = [];
  bool? is_get_data = false;
  String? status = "";
  String? infourl;
  Future get_change_shift_report() async {
    isAll!
        ? infourl =
            Helper.url.toString() + 'shift/get_changeshift/?user=${userID}'
        : isPending!
            ? infourl = Helper.url.toString() +
                'shift/get_changeshift/?user=${userID}&status=pending'
            : isReject!
                ? infourl = Helper.url.toString() +
                    'shift/get_changeshift/?user=${userID}&status=rejected'
                : isAccept!
                    ? infourl = Helper.url.toString() +
                        'shift/get_changeshift/?user=${userID}&status=approved'
                    : infourl = Helper.url.toString() +
                        'shift/get_changeshift/?user=${userID}';

    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(infourl);
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = getChangeShiftModelFromJson(x);
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
}
