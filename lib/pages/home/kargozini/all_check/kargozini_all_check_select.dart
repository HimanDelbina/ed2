import 'package:ed/models/all_check/all_check_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';

class KargoziniAllCheckSelect extends StatefulWidget {
  int? user_id;
  KargoziniAllCheckSelect({super.key, this.user_id});

  @override
  State<KargoziniAllCheckSelect> createState() =>
      _KargoziniAllCheckSelectState();
}

class _KargoziniAllCheckSelectState extends State<KargoziniAllCheckSelect> {
  @override
  void initState() {
    super.initState();
    get_all_check_by_user_id();
    current_month = date_now!.month.toString();
    current_year = date_now!.year.toString();
    filter_month = current_month;
    filter_year = current_year;
  }

  Jalali? date_now = Jalali.now();
  String? current_month;
  String? current_year;
  bool? is_leave_month = false;
  bool? is_leave_all = true;

  String? start_date;
  String? end_date;
  bool? is_start_date = false;
  bool? is_end_date = false;

  Jalali? pickedStartDate = Jalali.now();
  String? date_start_select = "";
  Jalali? pickedEndDate = Jalali.now();
  String? date_end_select = "";
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: allCheckModel == null
            ? Center(
                child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
            : Padding(
                padding: PagePadding.page_padding,
                child: Container(
                  width: my_width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                    get_all_check_by_user_id();
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
                                      current_month =
                                          date_now!.month.toString();
                                      current_year = date_now!.year.toString();
                                      is_start_date = false;
                                      is_end_date = false;
                                    });
                                    get_all_check_by_user_id();
                                  },
                                ),
                              ],
                            ),
                            select_month(),
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
                                  pickedStartDate =
                                      await showModalBottomSheet<Jalali>(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'لغو',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'تایید',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                          tempPickedDate ??
                                                              Jalali.now());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                                height: 0, thickness: 1),
                                            Expanded(
                                              child: Container(
                                                child: PCupertinoDatePicker(
                                                  mode: PCupertinoDatePickerMode
                                                      .date,
                                                  onDateTimeChanged:
                                                      (Jalali dateTime) {
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 7.0),
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
                                        color: is_start_date!
                                            ? Colors.white
                                            : Colors.black,
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
                                  pickedEndDate =
                                      await showModalBottomSheet<Jalali>(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'لغو',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  CupertinoButton(
                                                    child: const Text(
                                                      'تایید',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                          tempPickedDate ??
                                                              Jalali.now());
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                                height: 0, thickness: 1),
                                            Expanded(
                                              child: Container(
                                                child: PCupertinoDatePicker(
                                                  mode: PCupertinoDatePickerMode
                                                      .date,
                                                  onDateTimeChanged:
                                                      (Jalali dateTime) {
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
                                      date_end_select =
                                          '${pickedEndDate!.toDateTime()}';
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 7.0),
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
                                        color: is_end_date!
                                            ? Colors.white
                                            : Colors.black,
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
                                  get_all_check_by_user_id();
                                } else if (is_start_date!) {
                                  MyMessage.mySnackbarMessage(context,
                                      "لطفا اول تاریخ پایان را انتخاب کنید", 1);
                                } else if (is_end_date!) {
                                  MyMessage.mySnackbarMessage(context,
                                      "لطفا اول تاریخ شروع را انتخاب کنید", 1);
                                } else {
                                  MyMessage.mySnackbarMessage(context,
                                      "لطفا اول تاریخ ها را انتخاب کنید", 1);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7.0, horizontal: 10.0),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 7.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Center(
                                  child: Text(
                                    "تایید",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ))
                        ],
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text("مرخصی ها ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue))),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'جمع کل مرخصی های روزانه : ${allCheckModel!.totalDaysSum.toString().toPersianDigit() ?? 0} روز'),
                          Text(
                              'تبدیل به ساعت : ${allCheckModel!.dayToClock.toString().toPersianDigit() ?? 0.0} ساعت'),
                        ],
                      ),
                      const Divider(color: Colors.blue),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'جمع کل مرخصی های ساعتی : ${allCheckModel!.sumData.toString().toPersianDigit() ?? 0} ساعت'),
                          Text(
                              'تبدیل به روز : ${allCheckModel!.clockToDay.toString().toPersianDigit() ?? 0.0} روز'),
                        ],
                      ),
                      const Divider(color: Colors.blue),
                      Text(
                          'مجموع کل مرخصی ها (روزانه و ساعتی) به ساعت : ${allCheckModel!.sumAllClock.toString().toPersianDigit() ?? 0.0} ساعت'),
                      Text(
                          'مجموع کل مرخصی ها (روزانه و ساعتی) به روز : ${allCheckModel!.sumAllDay.toString().toPersianDigit() ?? 0.0} روز'),
                      Text(
                        'مانده مرخصی  تا این ماه (به روز): ${allCheckModel!.sumMonthDay.toString().toPersianDigit() ?? 0.0} روز',
                        style: TextStyle(
                            color: allCheckModel!.sumMonthDay! <= 0
                                ? Colors.red
                                : Colors.green),
                      ),
                      Text(
                        'مانده مرخصی تا این ماه (به ساعت) : ${allCheckModel!.sumMonthClock.toString().toPersianDigit() ?? 0.0} ساعت',
                        style: TextStyle(
                            color: allCheckModel!.sumMonthDay! <= 0
                                ? Colors.red
                                : Colors.green),
                      ),
                      Text(
                        'مانده مرخصی  تا پایان سال (به روز): ${allCheckModel!.remainingDaysLeave.toString().toPersianDigit() ?? 0.0} روز',
                        style: TextStyle(
                            color: allCheckModel!.sumMonthDay! <= 0
                                ? Colors.red
                                : Colors.green),
                      ),
                      Text(
                        'مانده مرخصی تا پایان سال (به ساعت) : ${allCheckModel!.remainingHours.toString().toPersianDigit() ?? 0.0} ساعت',
                        style: TextStyle(
                            color: allCheckModel!.sumMonthDay! <= 0
                                ? Colors.red
                                : Colors.green),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text("اضافه کاری ها ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue))),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      Text(
                          'مجموع جمعه کاری ها : ${allCheckModel!.sumDataBySelect?.go == null ? 0.toString().toPersianDigit() : allCheckModel!.sumDataBySelect?.go.toString().toPersianDigit()} ساعت'),
                      Text(
                          'مجموع اضافه کاری ها : ${allCheckModel!.sumDataBySelect?.ez == null ? 0.toString().toPersianDigit() : allCheckModel!.sumDataBySelect?.ez.toString().toPersianDigit()} ساعت'),
                      Text(
                          'مجموع تعطیل کاری ها : ${allCheckModel!.sumDataBySelect?.ta == null ? 0.toString().toPersianDigit() : allCheckModel!.sumDataBySelect?.ta.toString().toPersianDigit() ?? 0.0} ساعت'),
                      Text(
                          'مجموع ماموریت ها : ${allCheckModel!.sumDataBySelect?.ma == null ? 0.toString().toPersianDigit() : allCheckModel!.sumDataBySelect?.ma.toString().toPersianDigit() ?? 0.0} ساعت'),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0, top: 20.0),
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text("قرارداد",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue))),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      startDate == ''
                          ? const Text("متاسفانه هنوز قرارداد تنظیم نشده")
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'تاریخ شروع قرارداد: ${FormateDate.formatDate(startDate!)}'),
                                Text(
                                    'تاریخ پایان قرارداد: ${FormateDate.formatDate(endDate!)}'),
                              ],
                            ),
                      const Divider(color: Colors.blue),
                      Text(
                          'کل روزهای قرارداد : ${allCheckModel!.gharardadDaysBetween.toString().toPersianDigit() ?? 0} روز'),
                      Text(
                          'روزهای باقی‌ مانده قرارداد : ${allCheckModel!.gharardadRemainingDays.toString().toPersianDigit() ?? 0} روز'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  int? shamsi_month_select = 0;
  int? select_month_data;
  bool? is_all_filter = true;
  String? all_filter = "all";
  String? filter_month;
  String? filter_year;
  AllCheckModel? allCheckModel;
  String? startDate = '';
  String? endDate = '';
  String? infourl;
  Future<void> get_all_check_by_user_id() async {
    is_all_filter!
        ? infourl = Helper.url.toString() +
            'all_data/get_all_check/' +
            widget.user_id.toString() +
            '?' +
            all_filter.toString()
        : is_start_date!
            ? infourl = Helper.url.toString() +
                'all_data/get_all_check/' +
                widget.user_id.toString() +
                '?start_date=' +
                start_date.toString() +
                "&end_date=" +
                end_date.toString()
            : infourl = Helper.url.toString() +
                'all_data/get_all_check/' +
                widget.user_id.toString() +
                '?month=' +
                filter_month.toString() +
                "&year=" +
                filter_year.toString();

    try {
      var response = await http.get(Uri.parse(infourl!), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        allCheckModel = allCheckModelFromJson(jsonResponse);
        setState(() {
          if (allCheckModel!.gharardadStartGh != null) {
            String startDateString = allCheckModel!.gharardadStartGh.toString();
            startDate = startDateString.split(' ')[0];
          }
          if (allCheckModel!.gharardadEndGh != null) {
            String endDateString = allCheckModel!.gharardadEndGh.toString();
            endDate = endDateString.split(' ')[0];
          }
        });
      } else if (response.statusCode == 204) {
        MyMessage.mySnackbarMessage(context, "هیچ داده‌ای یافت نشد", 1);
      } else {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(
          context, "مشکلی در دریافت داده رخ داده است", 1);
    }
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

  Widget select_month() {
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
            get_all_check_by_user_id();
          },
        ),
      ],
    );
  }
}
