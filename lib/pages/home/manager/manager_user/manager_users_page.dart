import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../models/users/users_model.dart';
import '../../../../static/helper_page.dart';

class ManagerUsersPage extends StatefulWidget {
  const ManagerUsersPage({super.key});

  @override
  State<ManagerUsersPage> createState() => _ManagerUsersPageState();
}

class _ManagerUsersPageState extends State<ManagerUsersPage> {
  int? unit_id = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      unit_id = prefsUser.getInt("unit_id") ?? 0;
      sender_id = prefsUser.getInt("id") ?? 0;
    });
    get_user_by_unit_id();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  int? select_user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: ListView.builder(
        itemCount: data!.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data![index].firstName} ${data![index].lastName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data![index].isActive ? "فعال" : "غیر فعال",
                      style: TextStyle(
                          color:
                              data![index].isActive ? Colors.green : Colors.red,
                          fontSize: 15.0),
                    ),
                  ],
                ),
                const Divider(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      user_id = data![index].id;
                    });
                    if (data![index].isActive) {
                      setState(() {
                        is_check = false;
                      });
                    } else {
                      setState(() {
                        is_check = true;
                      });
                    }
                    create_user_request();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5.0),
                    decoration: BoxDecoration(
                        color: data![index].isActive
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text(data![index].isActive
                        ? "میتوانید برای غیر فعالسازی درخواست ارسال کنید"
                        : "میتوانید برای فعالسازی درخواست ارسال کنید"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_user_by_unit_id() async {
    String infourl = Helper.url.toString() +
        'user/get_user_by_unit_id/' +
        unit_id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = usersModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali? pickedDate = Jalali.now();
  int? user_id;
  int? sender_id;
  bool? is_check = false;
  Future create_user_request() async {
    var jalaliDate = pickedDate!.formatter.yyyy +
        '-' +
        pickedDate!.formatter.mm +
        '-' +
        pickedDate!.formatter.dd +
        ' ' +
        "00:00";
    var body = jsonEncode({
      "user": user_id,
      "sernder": sender_id,
      "is_check": is_check,
      "is_accept": false,
      "is_read": false,
      "sender_date": jalaliDate,
      "accept_date": null
    });
    print(body);
    String infourl = Helper.url.toString() + 'user/create_request_user';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 201) {
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
