import 'dart:convert';
import 'package:ed/models/leave/two_leave_all_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';
import 'package:lottie/lottie.dart';

class GuardReportFirstPage extends StatefulWidget {
  const GuardReportFirstPage({super.key});

  @override
  State<GuardReportFirstPage> createState() => _GuardReportFirstPageState();
}

class _GuardReportFirstPageState extends State<GuardReportFirstPage> {
  @override
  void initState() {
    super.initState();
    get_two_leave_today_all();
  }

  @override
  Widget build(BuildContext context) {
    return get_data == false
        ? Center(
            child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
        : data_days!.isEmpty && data_clock!.isEmpty
            ? const Center(child: Text("داده ای وجود ندارد"))
            : Padding(
                padding: PagePadding.page_padding,
                child: ListView.builder(
                  itemCount: data_days!.length + data_clock!.length,
                  itemBuilder: (context, index) {
                    var leaveEntry;
                    if (index < data_days!.length) {
                      leaveEntry = data_days![index];
                    } else {
                      leaveEntry = data_clock![index - data_days!.length];
                    }
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                leaveEntry.isClock
                                    ? "مرخصی ساعتی"
                                    : "مرخصی روزانه",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                leaveEntry.isAccept
                                    ? "تایید شده"
                                    : "تایید نشده",
                                style: TextStyle(
                                    color: leaveEntry.isAccept
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${leaveEntry.user.firstName} ${leaveEntry.user.lastName}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(leaveEntry.isClock
                                  ? "تاریخ درخواست : ${FormateDateCreateChange.formatDate(leaveEntry.clockLeaveDate.toString())}"
                                  : "تاریخ درخواست : ${FormateDateCreateChange.formatDate(leaveEntry.createAt.toString())}"),
                            ],
                          ),
                          Text(
                            leaveEntry.isClock
                                ? "از ساعت : ${leaveEntry.clockStartTime.toString().toPersianDigit()} تا ساعت : ${leaveEntry.clockEndTime.toString().toPersianDigit()}"
                                : "از تاریخ ${FormateDateCreateChange.formatDate(leaveEntry.daysStartDate.toString())} تا تاریخ ${FormateDateCreateChange.formatDate(leaveEntry.daysEndDate.toString())}",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  leaveEntry.salonAccept ||
                                          leaveEntry.managerAccept
                                      ? Icons.check
                                      : Icons.clear,
                                  size: 15.0,
                                  color: leaveEntry.salonAccept ||
                                          leaveEntry.managerAccept
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                "تاییدیه مدیر : ${leaveEntry.salonAccept || leaveEntry.managerAccept ? "تایید شد" : "منتظر تایید"}",
                                style: TextStyle(
                                    color: leaveEntry.salonAccept ||
                                            leaveEntry.managerAccept
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(
                                  leaveEntry.isAccept
                                      ? Icons.check
                                      : Icons.clear,
                                  size: 15.0,
                                  color: leaveEntry.isAccept
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                "تاییدیه مدیر اصلی : ${leaveEntry.isAccept ? "تایید شد" : "منتظر تایید"}",
                                style: TextStyle(
                                    color: leaveEntry.isAccept
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
  }

  var leaveData;
  List? data = [];
  List? data_days = [];
  List? data_clock = [];
  bool? get_data = false;

  Future get_two_leave_today_all() async {
    String infourl = Helper.url.toString() + 'leave/get_two_leave_today_all';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      TwoLeaveAllModel leaveData = TwoLeaveAllModel.fromJson(jsonResponse);
      setState(() {
        data_days = leaveData.leaveEntries;
        data_clock = leaveData.leaveDataClock;
        get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
