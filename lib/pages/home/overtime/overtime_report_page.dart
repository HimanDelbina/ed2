import 'package:lottie/lottie.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';

import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/overtime/overtime_model.dart';

class OvertimeReportPage extends StatefulWidget {
  const OvertimeReportPage({super.key});

  @override
  State<OvertimeReportPage> createState() => _OvertimeReportPageState();
}

class _OvertimeReportPageState extends State<OvertimeReportPage> {
  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    get_all_overtime_by_user_id_filter();
  }

  bool? is_today = true;
  bool? is_month = false;
  bool? is_all = false;
  bool? is_accept = false;
  bool? is_reject = false;
  bool? filter_all = true;
  bool? filter_ezafe = false;
  bool? filter_gome = false;
  bool? filter_tatil = false;
  bool? filter_maoriat = false;
  String? select_noe = "all";
  String? filterType = "all";
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Container(
            width: my_width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: show_filter("همه", filter_all, () {
                    setState(() {
                      filter_all = true;
                      filter_ezafe = false;
                      filter_gome = false;
                      filter_tatil = false;
                      filter_maoriat = false;
                      select_noe = 'all';
                    });
                    if (is_today!) {
                      get_all_overtime_by_user_id_filter();
                    } else if (is_month!) {
                      get_all_overtime_by_user_id_filter();
                    } else if (is_all!) {
                      get_all_overtime_by_user_id_filter();
                    } else if (is_accept!) {
                      get_all_overtime_by_user_id_filter();
                    } else if (is_reject!) {
                      get_all_overtime_by_user_id_filter();
                    }
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    show_filter("اضافه کاری", filter_ezafe, () {
                      setState(() {
                        filter_all = false;
                        filter_ezafe = true;
                        filter_gome = false;
                        filter_tatil = false;
                        filter_maoriat = false;
                        select_noe = 'EZ';
                      });
                      if (is_today!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_month!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_all!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_accept!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_reject!) {
                        get_all_overtime_by_user_id_filter();
                      }
                    }),
                    show_filter("تعطیل کاری", filter_tatil, () {
                      setState(() {
                        filter_all = false;
                        filter_ezafe = false;
                        filter_gome = false;
                        filter_tatil = true;
                        filter_maoriat = false;
                        select_noe = 'TA';
                      });
                      if (is_today!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_month!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_all!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_accept!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_reject!) {
                        get_all_overtime_by_user_id_filter();
                      }
                    }),
                    show_filter("جمعه کاری", filter_gome, () {
                      setState(() {
                        filter_all = false;
                        filter_ezafe = false;
                        filter_gome = true;
                        filter_tatil = false;
                        filter_maoriat = false;
                        select_noe = 'GO';
                      });
                      if (is_today!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_month!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_all!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_accept!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_reject!) {
                        get_all_overtime_by_user_id_filter();
                      }
                    }),
                    show_filter("ماموریت", filter_maoriat, () {
                      setState(() {
                        filter_all = false;
                        filter_ezafe = false;
                        filter_gome = false;
                        filter_tatil = false;
                        filter_maoriat = true;
                        select_noe = 'MA';
                      });
                      if (is_today!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_month!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_all!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_accept!) {
                        get_all_overtime_by_user_id_filter();
                      } else if (is_reject!) {
                        get_all_overtime_by_user_id_filter();
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            width: my_width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                show_filter("امروز", is_today, () {
                  setState(() {
                    is_today = true;
                    is_month = false;
                    is_all = false;
                    is_accept = false;
                    is_reject = false;
                    filterType = "today";
                  });
                  get_all_overtime_by_user_id_filter();
                }),
                show_filter("این ماه", is_month, () {
                  setState(() {
                    is_today = false;
                    is_month = true;
                    is_all = false;
                    is_accept = false;
                    is_reject = false;
                    filterType = "this_monthay";
                  });
                  get_all_overtime_by_user_id_filter();
                }),
                show_filter("همه", is_all, () {
                  setState(() {
                    is_today = false;
                    is_month = false;
                    is_all = true;
                    is_accept = false;
                    is_reject = false;
                    filterType = "all";
                  });
                  get_all_overtime_by_user_id_filter();
                }),
                show_filter("تایید شده", is_accept, () {
                  setState(() {
                    is_today = false;
                    is_month = false;
                    is_all = false;
                    is_accept = true;
                    is_reject = false;
                    filterType = "accepted";
                  });
                  get_all_overtime_by_user_id_filter();
                }),
                show_filter("تایید نشده", is_reject, () {
                  setState(() {
                    is_today = false;
                    is_month = false;
                    is_all = false;
                    is_accept = false;
                    is_reject = true;
                    filterType = "not_accepted";
                  });
                  get_all_overtime_by_user_id_filter();
                }),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: is_get_data != true
                ? Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0))
                : ListView.builder(
                    itemCount: data.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        margin: const EdgeInsetsDirectional.symmetric(
                            vertical: 5.0),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[index].select == "EZ"
                                      ? "اضافه کاری"
                                      : data[index].select == "GO"
                                          ? "جمعه کاری"
                                          : data[index].select == "TA"
                                              ? "تعطیل کاری"
                                              : data[index].select == "MA"
                                                  ? "ماموریت"
                                                  : "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                    "تاریخ : ${FormateDateCreateChange.formatDate(data[index].overtimeDate.toString())}"),
                              ],
                            ),
                            Divider(
                              color: data[index].select == "EZ"
                                  ? Colors.blue
                                  : data[index].select == "GO"
                                      ? Colors.purple
                                      : data[index].select == "TA"
                                          ? Colors.orange
                                          : data[index].select == "MA"
                                              ? Colors.green
                                              : Colors.blue,
                            ),
                            Row(
                              children: [
                                Text(
                                  data[index].isAccept!
                                      ? "تایید شده"
                                      : "تایید نشده",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: data[index].isAccept!
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                Text(
                                  data[index].managerAccept!
                                      ? " : توسط مدیر واحد"
                                      : " : توسط مدیر سالن",
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "ساعت شروع : ${data[index].startTime.toString().toPersianDigit()}"),
                                Text(
                                    "ساعت پایان : ${data[index].endTime.toString().toPersianDigit()}"),
                              ],
                            ),
                            data[index].isAccept!
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        overtime_id = data[index].id;
                                      });
                                      delete_overtime_by_id();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 5.0, horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: const <TextSpan>[
                                            TextSpan(
                                                text:
                                                    "شما تا قبل از تایید میتوانید درخواست خود را لغو کنید : ",
                                                style:
                                                    TextStyle(fontSize: 14.0)),
                                            TextSpan(
                                              text: 'حذف درخواست',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          Container(
            width: my_width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "ساعات اضافه کاری ها : ${sumEZ.toString().toPersianDigit()} ساعت"),
                Text(
                    "ساعات تعطیل کاری ها : ${sumTA.toString().toPersianDigit()} ساعت"),
                Text(
                    "ساعات جمعه کاری ها : ${sumGO.toString().toPersianDigit()} ساعت"),
                Text(
                    "ساعات ماموریت ها : ${sumMA.toString().toPersianDigit()} ساعت"),
                Text(
                    "مجموع ساعات کل همه اضافه کاری های شما : ${sumData.toString().toPersianDigit()} ساعت"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget show_filter(String? title, bool? is_select, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 7.0),
        decoration: BoxDecoration(
          color: is_select! ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
                color: is_select ? Colors.white : Colors.black,
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  List<Ez> data = [];
  bool? is_get_data = false;
  double? sumData, sumEZ, sumGO, sumTA, sumMA;

  Future<void> get_all_overtime_by_user_id_filter() async {
    String infourl = Helper.url.toString() +
        'overtime/get_all_overtime_by_user_id_filter/${id_user.toString()}?select=${select_noe.toString()}&filter_type=${filterType.toString()}';
    print(infourl);

    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = overtimeModelFromJson(x);

      setState(() {
        // استخراج و ترکیب تمام دسته‌ها در یک لیست
        data = [
          ...(recive_data.leaveEntriesBySelect?.ez ?? []),
          ...(recive_data.leaveEntriesBySelect?.go ?? []),
          ...(recive_data.leaveEntriesBySelect?.ta ?? []),
          ...(recive_data.leaveEntriesBySelect?.ma ?? []),
        ];
        sumEZ = recive_data.sumDataBySelect?.ez ?? 0;
        sumGO = recive_data.sumDataBySelect?.go ?? 0;
        sumTA = recive_data.sumDataBySelect?.ta ?? 0;
        sumMA = recive_data.sumDataBySelect?.ma ?? 0;
        // محاسبه مجموع تمام دسته‌ها
        sumData = [
          recive_data.sumDataBySelect?.ez ?? 0,
          recive_data.sumDataBySelect?.go ?? 0,
          recive_data.sumDataBySelect?.ta ?? 0,
          recive_data.sumDataBySelect?.ma ?? 0,
        ].reduce((a, b) => a + b);

        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? overtime_id;
  Future delete_overtime_by_id() async {
    String infourl = Helper.url.toString() +
        'overtime/delete_overtime_by_id/${overtime_id.toString()}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "درخواست شما حذف شد", 1);
      if (is_all!) {
        get_all_overtime_by_user_id_filter();
      } else if (is_today!) {
        get_all_overtime_by_user_id_filter();
      } else if (is_month!) {
        get_all_overtime_by_user_id_filter();
      }
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
