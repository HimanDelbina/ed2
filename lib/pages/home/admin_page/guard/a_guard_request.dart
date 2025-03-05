import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/guard/client/client_request_admin_model.dart';
import '../../../../static/helper_page.dart';

class AdminGuardRequestPage extends StatefulWidget {
  const AdminGuardRequestPage({super.key});

  @override
  State<AdminGuardRequestPage> createState() => _AdminGuardRequestPageState();
}

class _AdminGuardRequestPageState extends State<AdminGuardRequestPage> {
  @override
  void initState() {
    super.initState();
    get_all_request_client();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data! == false
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
          : data!.isEmpty
              ? const Center(child: Text("داده ای وجود ندارد"))
              : ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: my_width,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      margin:
                          const EdgeInsetsDirectional.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "درخواست ورود به شرکت برای ${data![index].name} در تاریخ ${FormateDateCreateLeft.formatDate(data![index].createAt.toString())} در ساعت ${FormatTimeCreate.formatTime(data![index].createAt.toString().toPersianDigit())} ارسال شده لطفا پیگیری فرمایید ."),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "مراجعه کننده : ${data![index].name}",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                FormateDateCreate.formatDate(
                                    data![index].createAt.toString()),
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "واحد مراجعه : ${data![index].unit == "E" ? "اداری" : data![index].unit == "T" ? "تولید" : data![index].unit == "F" ? "فنی" : ""}"),
                              Text(
                                  "نوع کار : ${data![index].typeWork == "P" ? "پیمان کار" : data![index].typeWork == "N" ? "نصاب" : data![index].typeWork == "K" ? "خدماتی" : data![index].typeWork == "G" ? "غیره" : ""}"),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              accept("تایید", Icons.check, Colors.green, () {
                                setState(() {
                                  select_request = data![index].id;
                                  is_accept = true;
                                  is_reject = false;
                                });
                                edit_client();
                              }),
                              accept("عدم تایید", Icons.clear, Colors.red, () {
                                setState(() {
                                  select_request = data![index].id;
                                  is_accept = false;
                                  is_reject = true;
                                });
                                edit_client();
                              }),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget accept(String title, IconData icon, Color color, VoidCallback ontab) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ontab,
      child: Container(
        height: my_height * 0.04,
        width: my_width * 0.2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 10.0, vertical: 5.0),
        margin: const EdgeInsetsDirectional.symmetric(vertical: 5.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, size: 15.0, color: Colors.white),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  Future get_all_request_client() async {
    String infourl =
        Helper.url.toString() + 'guard/get_request_client_forAdmin';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = clientRequestAdminMidelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  int? select_request;
  bool? is_accept = false;
  bool? is_reject = false;
  Future edit_client() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "admin_accept": is_accept,
      "admin_reject": is_reject,
      "client_login": dateTimeString
    });
    String infourl =
        Helper.url.toString() + 'guard/edit_client/${select_request}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
      get_all_request_client();
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
