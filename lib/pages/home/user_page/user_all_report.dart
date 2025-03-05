import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../models/all_check/user_details_model.dart';
import '../../../static/helper_page.dart';
import 'package:intl/intl.dart';

class UserAllReport extends StatefulWidget {
  const UserAllReport({super.key});

  @override
  State<UserAllReport> createState() => _UserAllReportState();
}

class _UserAllReportState extends State<UserAllReport> {
  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    get_all_user_details();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "همکار گرامی این قسمت به دلیل دسترسی سریع و نمایش آخرین درخواست های شما شکل گرفته لطفا در صورت نیاز به دسترسی بیشتر داده ها به تب خانه مراجعه کنید . با تشکر",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
          ),
          const Divider(),
          Expanded(
              child: data != null
                  ? ListView(
                      children: [
                        data!.latestChangeshift != null
                            ? changeShift(data!)
                            : const SizedBox(),
                        data!.todayOvertime!.isNotEmpty
                            ? overtimeToday(data)
                            : const SizedBox(),
                        data!.todayLeave!.isNotEmpty
                            ? leaveToday(data)
                            : const SizedBox(),
                        data!.todayOvertime!.isNotEmpty
                            ? todayFood(data)
                            : const SizedBox(),
                        data?.salary != null
                            ? salaryLatest(data)
                            : const SizedBox(),
                        data?.contracts != null
                            ? gharardad(data)
                            : const SizedBox(),
                        data!.funds!.isNotEmpty
                            ? funds(data)
                            : const SizedBox(),
                        data!.shift!.isNotEmpty
                            ? shift(data)
                            : const SizedBox(),
                        data!.overtime != null
                            ? overtime(data)
                            : const SizedBox(),
                        data!.leave != null ? leave(data) : const SizedBox(),
                        data!.loan != null ? loan(data) : const SizedBox(),
                      ],
                    )
                  : Center(
                      child: Lottie.asset("assets/lottie/loading.json",
                          height: 40.0))),
        ],
      ),
    );
  }

  UserDetailsModel? data;
  List? data_show = [];
  bool? is_get_data = false;
  double? sumData;

  Future get_all_user_details() async {
    String infourl = Helper.url.toString() +
        'all_data/get_user_details/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = userDetailsModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String getShiftName(String daysSelect) {
    if (daysSelect == "SH") {
      return " شب ";
    } else if (daysSelect == "AS") {
      return " عصر ";
    } else if (daysSelect == "SO") {
      return " صبح ";
    } else {
      return " نامشخص ";
    }
  }

  String foodSelect(String daysSelect) {
    if (daysSelect == "SO") {
      return "صبحانه";
    } else if (daysSelect == "NA") {
      return "نهار";
    } else if (daysSelect == "SH") {
      return "شام";
    } else {
      return " نامشخص ";
    }
  }

  String todayOvertimeSelect(String select) {
    if (select == "TA") {
      return "تعطیل کاری";
    } else if (select == "EZ") {
      return "اضافه کاری";
    } else if (select == "GO") {
      return "جمعه کاری";
    } else if (select == "MA") {
      return "ماموریت";
    } else {
      return " نامشخص ";
    }
  }

  String todayOvertimeCheck(bool isAccept) {
    if (isAccept == true) {
      return "تایید شد";
    } else if (isAccept == false) {
      return "تایید نشد";
    } else {
      return " نامشخص ";
    }
  }

  String todayLeaveSelect(bool isDays) {
    if (isDays == true) {
      return "روزانه";
    } else if (isDays == false) {
      return "ساعتی";
    } else {
      return " نامشخص ";
    }
  }

  Widget changeShift(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "تعویض شیفت امروز شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "شیفت قبلی : ${getShiftName(data!.latestChangeshift!.previousShift!.daysSelect.toString())}"),
              Text(
                  "شیفت جدید : ${getShiftName(data.latestChangeshift!.newShift!.daysSelect.toString())}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget todayFood(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "درخواست غذا امروز شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data!.todayOvertime!.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.todayFood!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "درخواست ${foodSelect(data.todayFood![index].lunchSelect.toString())}"),
                            Text(
                              todayOvertimeCheck(
                                  data.todayFood![index].isAccept!),
                              style: TextStyle(
                                  color: data.todayFood![index].isAccept!
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    );
                  },
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget overtimeToday(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "درخواست اضافه کاری امروز شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data!.todayOvertime!.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.todayOvertime!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "درخواست ${todayOvertimeSelect(data.todayOvertime![index].select.toString())}"),
                            Text(
                              todayOvertimeCheck(
                                  data.todayOvertime![index].isAccept!),
                              style: TextStyle(
                                  color: data.todayOvertime![index].isAccept!
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    );
                  },
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget leaveToday(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "درخواست مرخصی امروز شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data!.todayLeave!.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.todayLeave!.length,
                  itemBuilder: (context, index) {
                    final leave = data.todayLeave![index];
                    final daysStartDate = leave.daysStartDate;
                    final daysEndDate = leave.daysEndDate;

                    // بررسی نوع و مقدار daysStartDate
                    String formattedDate = 'تاریخ نامشخص';
                    if (daysStartDate is String && daysStartDate.isNotEmpty) {
                      formattedDate = FormateDateCreateChange.formatDate(
                          daysStartDate); // استفاده از روش استاتیک
                    }
                    String formatteEnddDate = 'تاریخ نامشخص';
                    if (daysEndDate is String && daysEndDate.isNotEmpty) {
                      formatteEnddDate = FormateDateCreateChange.formatDate(
                          daysEndDate); // استفاده از روش استاتیک
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data.todayLeave![index].isDays!
                            ? Text(
                                "درخواست مرخصی ${todayLeaveSelect(data.todayLeave![index].isDays!)} از تاریخ ${formattedDate} تا تاریخ ${formatteEnddDate}")
                            : Text(
                                "درخواست مرخصی ${todayLeaveSelect(data.todayLeave![index].isDays!)} از ساعت ${data.todayLeave![index].clockStartTime.toString().toPersianDigit()} تا ساعت ${data.todayLeave![index].clockEndTime.toString().toPersianDigit()}"),
                        Text(
                          todayOvertimeCheck(data.todayLeave![index].isAccept!),
                          style: TextStyle(
                              color: data.todayLeave![index].isAccept!
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    );
                  },
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget gharardad(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "مشخصات قرارداد شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data?.contracts == null // بررسی آیا contracts وجود دارد یا خیر
              ? const Text(
                  "برای شما قرارداد تنظیم نشده است. لطفاً به کارگزینی مراجعه کنید.")
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "تاریخ شروع : ${FormateDateCreateChange.formatDate(data!.contracts!.startDate.toString())}"),
                    Text(
                        "تاریخ پایان : ${FormateDateCreateChange.formatDate(data.contracts!.endDate.toString())}"),
                  ],
                ),
          Text(
              "مبلغ پایه قرارداد شما : ${data!.contracts!.money!.toPersianDigit().seRagham()} ریال"),
        ],
      ),
    );
  }

  Widget salaryLatest(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "آخرین دریافتی حقوق شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data?.salary == null // بررسی آیا contracts وجود دارد یا خیر
              ? const Text("هنوز فیش حقوقی شما صادر نشده")
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "خالص دریافتی : ${data!.salary!.khalesPardakhti.toString().toPersianDigit().seRagham()} ریال"),
                    Text(
                        "تاریخ : ${data.salary!.month.toString().toPersianDigit()} - ${data.salary!.year.toString().toPersianDigit()}"),
                  ],
                ),
        ],
      ),
    );
  }

  Widget funds(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "مشخصات صندوق ذخیره شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data!.funds!.isEmpty
              ? const Center(child: Text("داده ای وجود ندارد"))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.funds!.length,
                  itemBuilder: (context, index) {
                    final funds = data.funds![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "مبلغ ذخیره شده شما : ${funds.allMoney!.toPersianDigit().seRagham()} ریال"),
                        Text(
                            "مبلغ اضافه کردن هر ماه شما به صندوق : ${funds.money!.toPersianDigit().seRagham()} ریال")
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget shift(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "مشخصات شیفت امروز شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data!.shift!.isEmpty
              ? const Text("شیفت امروز شما تعیین نشده")
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.shift!.length,
                  itemBuilder: (context, index) {
                    final shift = data.shift![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "تعداد شیفت های کاری شما : ${shift.shiftCount!.toString().toPersianDigit()} شیفت"),
                        Text(
                            "شیفت امروز شما : ${shift.daysSelect == "SO" ? "صبح" : shift.daysSelect == "AS" ? "عصر" : shift.daysSelect == "SH" ? "شب" : ""}")
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget overtime(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "مشخصات اضافه کاری این ماه شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Text(
              "مجموع اضافه کاری: ${data!.overtime!.sumData!.total.toString().toPersianDigit()} ساعت"),
          Text(
              "اضافه کاری روزانه: ${data.overtime!.sumData!.ez.toString().toPersianDigit()}"),
          Text(
              "اضافه کاری شبانه: ${data.overtime!.sumData!.go.toString().toPersianDigit()}"),
          Text(
              "اضافه کاری تعطیلات: ${data.overtime!.sumData!.ta.toString().toPersianDigit()}"),
          Text(
              "اضافه کاری ماهانه: ${data.overtime!.sumData!.ma.toString().toPersianDigit()}"),
        ],
      ),
    );
  }

  Widget leave(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "مشخصات مرخصی های این ماه شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data!.leave!.leaveClock == 0 && data.leave!.leaveDays == 0
              ? const Text("مرخصی ثبت نشده است")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "ساعات مرخصی: ${data.leave!.leaveClock.toString().toPersianDigit()} ساعت"),
                    Text(
                        "روزهای مرخصی: ${data.leave!.leaveDays.toString().toPersianDigit()} روز"),
                  ],
                ),
        ],
      ),
    );
  }

  Widget loan(UserDetailsModel? data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "مشخصات وام شما",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          data!.loan == null
              ? const Text("شما وام فعالی ندارید")
              : Row(
                  children: [
                    Text(
                        "مبلغ وام شما : ${data.loan!.moneyRequest!.toPersianDigit().seRagham()} ریال")
                  ],
                )
        ],
      ),
    );
  }
}

class FormateDateCreateChangeStatic {
  static String formatDate(String date) {
    try {
      // جدا کردن تاریخ از زمان
      var datePart = date.split(" ")[0]; // فقط بخش تاریخ (قبل از فاصله)
      var parts = datePart.split("-");

      // تبدیل به تاریخ شمسی
      var jalaliDate = Jalali(
        int.parse(parts[0].toEnglishDigit()),
        int.parse(parts[1].toEnglishDigit()),
        int.parse(parts[2].toEnglishDigit()),
      );

      // تبدیل تاریخ شمسی به میلادی و فرمت‌بندی
      String formattedDate = DateFormat('dd-MM-yyyy')
          .format(DateTime(jalaliDate.year, jalaliDate.month, jalaliDate.day));

      return formattedDate.toPersianDigit();
    } catch (e) {
      // مدیریت خطا
      return "Invalid date format";
    }
  }
}
