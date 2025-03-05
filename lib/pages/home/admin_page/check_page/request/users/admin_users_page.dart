import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:ed/models/all_check/user_request_model.dart';
import '../../../../../../static/helper_page.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  @override
  void initState() {
    get_users_admin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data
          ? data != null && data!.isNotEmpty
              ? ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    return user_show(data![index]);
                  },
                )
              : const Center(child: Text("داده ای وجود ندارد"))
          : Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0)),
    );
  }

  String? req;
  Widget user_show(var data) {
    req = (data.isCheck ?? false) ? "غیر فعال سازی" : "فعال سازی";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Text(
                  req!,
                  style: TextStyle(
                      color: data.isCheck ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "درخواست کننده : ${data.sernder.firstName} ${data.sernder.lastName}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                FormateDateCreate.formatDate(data.createAt.toString()),
                style: const TextStyle(color: Colors.blue),
              )
            ],
          ),
          const Divider(),
          Text(
            " کارمند : ${data.user.firstName} ${data.user.lastName}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
              "${data.sernder.firstName} ${data.sernder.lastName} درخواست ${req} کاربری ${data.user.firstName} ${data.user.lastName} را دارد"),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      deactive_user_select = data.user.id ?? 0;
                      id = data.id ?? 0;
                      is_accept = true;
                      is_deactive = req == "فعال سازی" ? true : false;
                    });
                    edit_user_request();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "تایید",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      id = data.id;
                      is_accept = false;
                    });
                    edit_user_request();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 5.0),
                    child: const Center(
                      child: Text(
                        "لغو",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List? data = [];
  bool is_get_data = false;
  Future<void> get_users_admin() async {
    try {
      String infourl = Helper.url.toString() + 'user/get_users_request_admin';
      var response = await http.get(Uri.parse(infourl), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        var recive_data = userrequestModelFromJson(response.body);
        setState(() {
          data = recive_data;
          is_get_data = true;
        });
      } else {
        throw Exception("خطا در دریافت اطلاعات");
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده: ${e.toString()}", 1);
    }
  }

  int? deactive_user_select;
  bool is_deactive = false;
  Future accept_request() async {
    var body = jsonEncode(
        {"id": deactive_user_select ?? 0, "is_active": is_deactive ?? false});
    String infourl = Helper.url.toString() + 'user/deactive_user';
    try {
      var response = await http.post(
        Uri.parse(infourl), // آدرس API خود را جایگزین کن
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        get_users_admin();
        MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
      } else {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } catch (e) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali? pickedDate = Jalali.now();
  int? id;
  bool is_check = false;
  bool is_accept = false;
  Future edit_user_request() async {
    var jalaliDate = pickedDate!.formatter.yyyy +
        '-' +
        pickedDate!.formatter.mm +
        '-' +
        pickedDate!.formatter.dd +
        ' ' +
        "00:00";
    var body = jsonEncode({
      "id": id,
      "is_accept": is_accept,
      "is_read": true,
      "accept_date": jalaliDate
    });
    print(body);
    String infourl = Helper.url.toString() + 'user/edit_request_user';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      if (is_accept) {
        accept_request();
      } else {
        get_users_admin();
        MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
      }
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
