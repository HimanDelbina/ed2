import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/all_check/all_data_model.dart';
import '../../../../static/helper_page.dart';

class SalonManagerRequestUserPage extends StatefulWidget {
  const SalonManagerRequestUserPage({super.key});

  @override
  State<SalonManagerRequestUserPage> createState() =>
      _SalonManagerRequestUserPageState();
}

class _SalonManagerRequestUserPageState
    extends State<SalonManagerRequestUserPage> {
  int? id_user = 0;
  int? unit_id = 0;
  bool? is_manager;
  bool? is_salon_manager;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      unit_id = prefsUser.getInt("unit_id") ?? 0;
      is_manager = prefsUser.getBool("is_manager") ?? false;
      is_salon_manager = prefsUser.getBool("is_salon_manager") ?? false;
    });
    get_all_data();
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
      child: get_data!
          ? ListView.builder(
              itemCount: overtime_data!.length +
                  leave_data!.length +
                  food_data!.length +
                  anbar_data!.length,
              itemBuilder: (context, index) {
                if (index < overtime_data!.length) {
                  return _buildOvertimeItem(overtime_data![index]);
                } else if (index < overtime_data!.length + leave_data!.length) {
                  return _buildLeaveItem(
                      leave_data![index - overtime_data!.length]);
                } else if (index <
                    overtime_data!.length +
                        leave_data!.length +
                        food_data!.length) {
                  return _buildFoodItem(food_data![
                      index - (overtime_data!.length + leave_data!.length)]);
                } else {
                  return _buildAnbarItem(anbar_data![index -
                      (overtime_data!.length +
                          leave_data!.length +
                          food_data!.length)]);
                }
              },
            )
          : overtime_data!.isEmpty ||
                  leave_data!.isEmpty ||
                  food_data!.isEmpty ||
                  anbar_data!.isEmpty
              ? const Center(child: Text("درخواستی وجود ندارد"))
              : Center(
                  child:
                      Lottie.asset("assets/lottie/loading.json", height: 40.0)),
    );
  }

  // ویجت نمایش هر آیتم Overtime
  Widget _buildOvertimeItem(Overtime overtime) {
    String dateTimeString = overtime.createAt!;
    String overtimeDate = overtime.overtimeDate!;
    String onlyDate = dateTimeString.split(' ')[0];
    String onlyDateOvertime = overtimeDate.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${overtime.user!.firstName} ${overtime.user!.lastName} ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                overtime.select! == "EZ"
                    ? "اضافه کاری"
                    : overtime.select! == "TA"
                        ? "تعطیل کاری"
                        : overtime.select! == "GO"
                            ? "جمعه کاری"
                            : overtime.select! == "MA"
                                ? "ماموریت"
                                : "",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                onlyDate.toPersianDigit(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              )
            ],
          ),
          const Divider(),
          Text(
            " تاریخ درخواست ${overtime.select! == "EZ" ? "اضافه کاری" : overtime.select! == "TA" ? "تعطیل کاری" : overtime.select! == "GO" ? "جمعه کاری" : overtime.select! == "MA" ? "ماموریت" : ""} : ${FormateDateCreateChange.formatDate(overtimeDate)}",
          ),
          Text(
              "از ساعت ${overtime.startTime.toString().toPersianDigit()} تا ساعت ${overtime.endTime.toString().toPersianDigit()}"),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    overtime_id = overtime.id;
                  });
                  accept_overtime();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "تایید",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    overtime_id = overtime.id;
                  });
                  reject_overtime();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "لغو",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ویجت نمایش هر آیتم Leave
  Widget _buildLeaveItem(Leave leave) {
    String dateTimeString = leave.createAt!;
    String onlyDate = dateTimeString.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${leave.user!.firstName} ${leave.user!.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "مرخصی ${leave.isClock! ? "ساعتی" : "روزانه"}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              Text(
                onlyDate.toPersianDigit(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
          const Divider(),
          leave.clockLeaveDate == null
              ? const SizedBox()
              : Text(
                  "تاریخ درخواست مرخصی : ${FormateDateCreateChange.formatDate(leave.clockLeaveDate!)}"),
          Text(leave.isClock!
              ? 'از ساعت ${leave.clockStartTime!.toPersianDigit()} تا ساعت ${leave.clockEndTime!.toPersianDigit()}'
              : 'از تاریخ ${leave.daysStartDate!.toPersianDigit()} تا تاریخ ${leave.daysEndDate!.toPersianDigit()}'),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    leave_id = leave.id;
                  });
                  accept_leave();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "تایید",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    leave_id = leave.id;
                  });
                  reject_leave();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "لغو",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ویجت نمایش هر آیتم Food
  Widget _buildFoodItem(Food food) {
    String dateTimeString = food.createAt!;
    String onlyDate = dateTimeString.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${food.user!.firstName} ${food.user!.lastName}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("تاریخ درخواست : ${onlyDate.toPersianDigit()}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Text(
            "درخواست وعده غذایی : ${food.lunchSelect! == "SO" ? "صبحانه" : food.lunchSelect! == "NA" ? "نهار" : food.lunchSelect! == "SH" ? "شام" : ""}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    food_id = food.id;
                  });
                  accept_food();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "تایید",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    food_id = food.id;
                  });
                  reject_food();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "لغو",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ویجت نمایش هر آیتم Anbar
  Widget _buildAnbarItem(Anbar anbar) {
    String dateTimeString = anbar.createAt!;
    String onlyDate = dateTimeString.split(' ')[0];
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${anbar.user!.firstName} ${anbar.user!.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "کالا",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              Text(
                onlyDate.toPersianDigit(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
          const Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text("درخواست ها ")),
              Expanded(child: Divider()),
            ],
          ),
          ListView.builder(
            itemCount: anbar.commodities!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('${(index + 1).toString().toPersianDigit()} - '),
                        Text(anbar.commodities![index].name.toString()),
                      ],
                    ),
                    Text(
                        ' تعداد : ${anbar.commodities![index].count.toString().toPersianDigit()} ${anbar.commodities![index].unit}'),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    anbar_id = anbar.id;
                  });
                  accept_anbar();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "تایید",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    anbar_id = anbar.id;
                  });
                  reject_anbar();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Center(
                    child: Text(
                      "لغو",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int? overtime_id;
  int? leave_id;
  int? food_id;
  int? anbar_id;

  var leaveData;
  List? data_clock = [];
  List? overtime_data = [];
  List? leave_data = [];
  List? food_data = [];
  List? anbar_data = [];
  bool? get_data = false;
  String manager_select = "MS";

  Future get_all_data() async {
    String infourl = Helper.url.toString() +
        'all_data/combined_data_by_salonManager/?manager_select=${manager_select}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      AllDataModel leaveData = AllDataModel.fromJson(jsonResponse);
      setState(() {
        overtime_data = leaveData.overtime;
        leave_data = leaveData.leave;
        food_data = leaveData.food;
        anbar_data = leaveData.anbar;
        get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future accept_leave() async {
    var body = jsonEncode({
      "id": leave_id,
      "is_accept": true,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
      "final_accept": false,
    });
    String infourl = Helper.url.toString() + 'leave/edit_leave_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت ثبت شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_leave() async {
    var body = jsonEncode({
      "id": leave_id,
      "is_accept": false,
      "is_reject": true,
      "final_accept": false,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
    });
    String infourl = Helper.url.toString() + 'leave/edit_leave_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت حذف شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future accept_overtime() async {
    var body = jsonEncode({
      "id": overtime_id,
      "is_accept": true,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
    });
    String infourl =
        Helper.url.toString() + 'overtime/edit_overtime_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت ثبت شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_overtime() async {
    var body = jsonEncode({
      "id": overtime_id,
      "is_accept": false,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
    });
    String infourl =
        Helper.url.toString() + 'overtime/edit_overtime_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت حذف شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future accept_food() async {
    var body = jsonEncode({
      "id": food_id,
      "is_accept": true,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
    });
    String infourl = Helper.url.toString() + 'food/edit_food_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت ثبت شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_food() async {
    var body = jsonEncode({
      "id": food_id,
      "is_accept": false,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
    });
    String infourl = Helper.url.toString() + 'food/edit_food_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت حذف شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali? date_now = Jalali.now();
  DateTime timeNow = DateTime.now();

  String? formattedStartTime = '';
  Future accept_anbar() async {
    String jalaliDateTime = "${timeNow.hour}:${timeNow.minute}";
    formattedStartTime = DateFormat.Hm().format(timeNow);
    var jalaliStartDate = date_now!.formatter.yyyy +
        '-' +
        date_now!.formatter.mm +
        '-' +
        date_now!.formatter.dd +
        ' ' +
        formattedStartTime!;
    var body = jsonEncode({
      "id": anbar_id,
      "is_accept": true,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
      "accept_date": jalaliStartDate,
      "anbar_date": null,
    });
    String infourl = Helper.url.toString() + 'anbar/edit_anbar_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت ثبت شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_anbar() async {
    String jalaliDateTime = "${timeNow.hour}:${timeNow.minute}";
    formattedStartTime = DateFormat.Hm().format(timeNow);
    var jalaliStartDate = date_now!.formatter.yyyy +
        '-' +
        date_now!.formatter.mm +
        '-' +
        date_now!.formatter.dd +
        ' ' +
        formattedStartTime!;
    var body = jsonEncode({
      "id": anbar_id,
      "is_accept": false,
      "manager_accept": is_manager,
      "salon_accept": is_salon_manager,
      "accept_date": jalaliStartDate,
      "anbar_date": null,
    });
    String infourl = Helper.url.toString() + 'anbar/edit_anbar_with_manager';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "با موفقیت حذف شد", 1);
      get_all_data();
      setState(() {});
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
