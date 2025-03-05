import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/guard/import/import_commodity_model.dart';
import 'package:ed/pages/home/guard/users/commodity/import/import_report.dart';
import 'package:ed/services/car_plate_display.dart';
import '../../../../static/helper_page.dart';

class ManagerAnbarImportReportData extends StatefulWidget {
  const ManagerAnbarImportReportData({super.key});

  @override
  State<ManagerAnbarImportReportData> createState() =>
      _ManagerAnbarImportReportDataState();
}

class _ManagerAnbarImportReportDataState
    extends State<ManagerAnbarImportReportData> {
  @override
  void initState() {
    super.initState();
    get_all_commodity();
    current_month = date_now!.month.toString();
    current_year = date_now!.year.toString();
    filter_month = current_month;
    filter_year = current_year;
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    show_filter(
                      "همه",
                      is_leave_all,
                      () {
                        setState(() {
                          is_leave_all = true;
                          is_leave_month = false;
                          is_all_filter = true;
                          is_start_date = false;
                          is_end_date = false;
                        });
                        get_all_commodity();
                      },
                    ),
                    show_filter(
                      "این ماه",
                      is_leave_month,
                      () {
                        setState(() {
                          is_leave_all = false;
                          is_leave_month = true;
                          is_all_filter = false;
                          current_month = date_now!.month.toString();
                          current_year = date_now!.year.toString();
                          is_start_date = false;
                          is_end_date = false;
                        });
                        get_all_commodity();
                      },
                    ),
                  ],
                ),
                month_select()
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("از تاریخ : "),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        is_leave_all = false;
                        is_leave_month = false;
                        is_all_filter = false;
                        is_start_date = true;
                      });
                      pickedStartDate = await showModalBottomSheet<Jalali>(
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

                      if (pickedStartDate != null) {
                        setState(() {
                          date_start_select =
                              '${pickedStartDate!.toDateTime()}';
                          start_date = pickedStartDate!
                              .toGregorian()
                              .toDateTime()
                              .toIso8601String()
                              .toPersianDate()
                              .toEnglishDigit();
                        });
                        print(start_date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 10.0),
                      margin: const EdgeInsets.symmetric(horizontal: 7.0),
                      decoration: BoxDecoration(
                        color: is_start_date!
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          date_start_select == ""
                              ? "انتخاب تاریخ"
                              : pickedStartDate!
                                  .toGregorian()
                                  .toDateTime()
                                  .toIso8601String()
                                  .toPersianDate(),
                          style: TextStyle(
                            color: is_start_date! ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text("تا تاریخ : "),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        is_leave_all = false;
                        is_leave_month = false;
                        is_all_filter = false;
                        is_end_date = true;
                      });
                      pickedEndDate = await showModalBottomSheet<Jalali>(
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

                      if (pickedEndDate != null) {
                        setState(() {
                          date_end_select = '${pickedEndDate!.toDateTime()}';
                          end_date = pickedEndDate!
                              .toGregorian()
                              .toDateTime()
                              .toIso8601String()
                              .toPersianDate()
                              .toEnglishDigit();
                        });
                        print(end_date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 10.0),
                      margin: const EdgeInsets.symmetric(horizontal: 7.0),
                      decoration: BoxDecoration(
                        color: is_end_date!
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          date_end_select == ""
                              ? "انتخاب تاریخ"
                              : pickedEndDate!
                                  .toGregorian()
                                  .toDateTime()
                                  .toIso8601String()
                                  .toPersianDate(),
                          style: TextStyle(
                            color: is_end_date! ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    if (is_start_date! && is_end_date!) {
                      get_all_commodity();
                    } else if (is_start_date!) {
                      MyMessage.mySnackbarMessage(
                          context, "لطفا اول تاریخ پایان را انتخاب کنید", 1);
                    } else if (is_end_date!) {
                      MyMessage.mySnackbarMessage(
                          context, "لطفا اول تاریخ شروع را انتخاب کنید", 1);
                    } else {
                      MyMessage.mySnackbarMessage(
                          context, "لطفا اول تاریخ ها را انتخاب کنید", 1);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(horizontal: 7.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Center(
                      child: Text(
                        "تایید",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))
            ],
          ),
          const Divider(),
          Expanded(
            child: is_get_data! == false
                ? Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0))
                : data!.isEmpty
                    ? const Center(child: Text("داده ای وجود ندارد"))
                    : ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            margin: const EdgeInsetsDirectional.symmetric(
                                vertical: 5.0),
                            padding: const EdgeInsetsDirectional.symmetric(
                                vertical: 5.0, horizontal: 15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          data![index].company.name.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                        const Text(" -- "),
                                        Text(
                                          data![index].select == "M"
                                              ? "مواد اولیه"
                                              : "کالا",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "تاریخ درخواست : ${FormateDateCreateChange.formatDate(data![index].createAt.toString())}"),
                                  ],
                                ),
                                Divider(
                                    color: data![index].select == "M"
                                        ? Colors.amber
                                        : Colors.blue),
                                Text(data![index].weightCommodity != null
                                    ? "${data![index].name} -- به وزن : ${data![index].weightCommodity.toString().toPersianDigit()}"
                                    : "${data![index].name} -- به تعداد : ${data![index].countCommodity.toString().toPersianDigit()}"),
                                Text(data![index].anbarDate == null
                                    ? "تاریخ تایید انبار : انبار هنوز تایید نکرده"
                                    : "تاریخ تایید انبار : ${FormateDateCreateChange.formatDate(data![index].anbarDate.toString())}"),
                                const Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text("مشخصات راننده "),
                                    ),
                                    Expanded(child: Divider())
                                  ],
                                ),
                                Text("نوع خودرو : ${data![index].car.name}"),
                                Text(
                                    "شماره تماس راننده : ${data![index].carPhone.toString().toPersianDigit()}"),
                                CarPlateDisplay(
                                    carPlate: data![index].carPlate),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  List? data_user = [];
  String? infourl;
  Future get_all_commodity() async {
    is_all_filter!
        ? infourl = Helper.url.toString() + 'guard/get_all_commodity'
        : is_start_date!
            ? infourl = Helper.url.toString() +
                'guard/get_all_commodity' +
                '?start_date=' +
                start_date.toString() +
                "&end_date=" +
                end_date.toString()
            : infourl = Helper.url.toString() +
                'guard/get_all_commodity' +
                '?month=' +
                filter_month.toString() +
                "&year=" +
                filter_year.toString();
    // String infourl = Helper.url.toString() + 'guard/get_all_commodity';
    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = importCommodityModelFromJson(x);
      setState(() {
        data = recive_data;
        data_user = data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  bool? is_ez_all = true;
  String? select_ez = "all";
  bool? is_ez = false;
  bool? is_go = false;
  bool? is_ta = false;
  bool? is_ma = false;
  Jalali? pickedStartDate = Jalali.now();
  String? date_start_select = "";
  Jalali? pickedEndDate = Jalali.now();
  String? date_end_select = "";

  Jalali now = Jalali.now();
  Jalali? date_now = Jalali.now();
  String? current_month;
  String? current_year;
  bool? is_leave_month = false;
  bool? is_leave_all = true;

  int? shamsi_month_select = 0;
  int? select_month_data;
  bool? is_all_filter = true;
  String? all_filter = "all";
  String? filter_month;
  String? filter_year;
  String? start_date;
  String? end_date;
  bool? is_start_date = false;
  bool? is_end_date = false;

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

  Widget month_select() {
    return Row(
      children: [
        Text(
          shamsi_month_select == 0
              ? "انتخاب ماه"
              : shamsi_month_select == 1
                  ? "فروردین"
                  : shamsi_month_select == 2
                      ? "اردیبهشت"
                      : shamsi_month_select == 3
                          ? "خرداد"
                          : shamsi_month_select == 4
                              ? "تیر"
                              : shamsi_month_select == 5
                                  ? "مرداد"
                                  : shamsi_month_select == 6
                                      ? "شهریور"
                                      : shamsi_month_select == 7
                                          ? "مهر"
                                          : shamsi_month_select == 8
                                              ? "آبان"
                                              : shamsi_month_select == 9
                                                  ? "آذر"
                                                  : shamsi_month_select == 10
                                                      ? "دی"
                                                      : shamsi_month_select ==
                                                              11
                                                          ? "بهمن"
                                                          : shamsi_month_select ==
                                                                  12
                                                              ? "اسفند"
                                                              : "انتخاب ماه",
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        PopupMenuButton(
          itemBuilder: (context) => const [
            PopupMenuItem(
              child: Text("فروردین"),
              value: 1,
            ),
            PopupMenuItem(
              child: Text("اردیبهشت"),
              value: 2,
            ),
            PopupMenuItem(
              child: Text("خرداد"),
              value: 3,
            ),
            PopupMenuItem(
              child: Text("تیر"),
              value: 4,
            ),
            PopupMenuItem(
              child: Text("مرداد"),
              value: 5,
            ),
            PopupMenuItem(
              child: Text("شهریور"),
              value: 6,
            ),
            PopupMenuItem(
              child: Text("مهر"),
              value: 7,
            ),
            PopupMenuItem(
              child: Text("آبان"),
              value: 8,
            ),
            PopupMenuItem(
              child: Text("آذر"),
              value: 9,
            ),
            PopupMenuItem(
              child: Text("دی"),
              value: 10,
            ),
            PopupMenuItem(
              child: Text("بهمن"),
              value: 11,
            ),
            PopupMenuItem(
              child: Text("اسفند"),
              value: 12,
            ),
          ],
          onSelected: (value) {
            setState(() {
              shamsi_month_select = value;
              select_month_data = shamsi_month_select!;
              is_leave_all = false;
              is_leave_month = false;
              is_all_filter = false;
              filter_month = shamsi_month_select.toString();
              filter_year = current_year;
              is_start_date = false;
              is_end_date = false;
            });
            get_all_commodity();
          },
        ),
      ],
    );
  }
}
