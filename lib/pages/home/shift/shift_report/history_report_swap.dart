import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/shift/history_report_swap_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;

class HistoryReportSwapShiftPage extends StatefulWidget {
  const HistoryReportSwapShiftPage({super.key});

  @override
  State<HistoryReportSwapShiftPage> createState() =>
      _HistoryReportSwapShiftPageState();
}

class _HistoryReportSwapShiftPageState
    extends State<HistoryReportSwapShiftPage> {
  @override
  void initState() {
    get_history_swap();
    super.initState();
  }

  bool isAllData = true;
  bool isDateData = false;
  Jalali? pickedDate = Jalali.now();
  String? date_select = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isAllData = true;
                        isDateData = false;
                        is_get_data = false;
                      });
                      get_history_swap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: isAllData
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.1),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Center(
                        child: Text(
                          "همه",
                          style: TextStyle(
                              color: isAllData ? Colors.white : Colors.black,
                              fontWeight: isAllData
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
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

                    if (pickedDate != null) {
                      setState(() {
                        date_select = '${pickedDate!.toDateTime().toString()}';
                      });
                    }
                    setState(() {
                      isAllData = false;
                      isDateData = true;
                      is_get_data = false;
                    });
                    get_history_swap();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: isDateData
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        pickedDate!
                            .toGregorian()
                            .toDateTime()
                            .toIso8601String()
                            .toPersianDate(),
                        style: TextStyle(
                            color: isDateData ? Colors.white : Colors.black,
                            fontWeight: isDateData
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
            Expanded(
              child: is_get_data!
                  ? data!.isEmpty
                      ? const Center(child: Text("داده ای وجود ندارد"))
                      : ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              margin: const EdgeInsetsDirectional.symmetric(
                                  vertical: 5.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "مدیر انجام دهنده : ${data![index].sender.firstName} ${data![index].sender.lastName}"),
                                  Text(
                                    data![index].tag.tag == "MO"
                                        ? "نوع تعویض شیفت : مستقیم از طریق مدیر"
                                        : "نوع تعویض شیفت : تعویض با همکار از طریق مدیر",
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${data![index].user.firstName} ${data![index].user.lastName}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "تاریخ تعویض شیفت : ${FormateDateCreateChange.formatDate(data![index].swappedAt)}"),
                                    ],
                                  ),
                                  const Divider(),
                                  Text(
                                    data![index].previousShift != null &&
                                            data![index]
                                                    .previousShift!
                                                    .daysSelect !=
                                                null
                                        ? "شیفت ${_getShiftName(data![index].previousShift?.daysSelect)} در تاریخ ${FormateDateCreateChange.formatDate(data![index].previousShift!.shiftDate)} به شیفت ${_getShiftName(data![index].newShift?.daysSelect)} تغییر یافت و تاریخ انجام این جابجایی ${FormateDateCreateChange.formatDate(data![index].swappedAt)} بود."
                                        : "اطلاعات نامعتبر",
                                  )
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
      )),
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

  List? data_show = [];
  List? data = [];
  bool? is_get_data = false;
  Future get_history_swap() async {
    try {
      var jalaliDate =
          "${pickedDate!.year}-${pickedDate!.month}-${pickedDate!.day}";
      String infourl = isAllData
          ? "${Helper.url}shift/ShiftSwapHistoryView/"
          : "${Helper.url}shift/ShiftSwapHistoryView/?date=$jalaliDate";

      var response = await http.get(Uri.parse(infourl), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      if (response.statusCode == 200) {
        var recive_data = historyReportSwapMpdelFromJson(response.body);
        setState(() {
          data = recive_data;
          data_show = recive_data;
          is_get_data = true;
        });
        print(data);
      } else {
        throw Exception("خطایی رخ داده");
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "مشکلی پیش آمد: ${e.toString()}", 1);
    }
  }
}
