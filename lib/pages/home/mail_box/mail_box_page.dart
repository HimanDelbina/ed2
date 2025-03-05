import 'dart:convert';

import 'package:ed/models/message/message_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MailBoxPage extends StatefulWidget {
  const MailBoxPage({super.key});

  @override
  State<MailBoxPage> createState() => _MailBoxPageState();
}

class _MailBoxPageState extends State<MailBoxPage> {
  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    get_message_by_user_id();
  }

  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: PagePadding.page_padding,
        child: is_get_data!
            ? data!.isNotEmpty
                ? ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      String dateTimeString =
                          data![index].timestamp!.toString();
                      String onlyDate = dateTimeString.split(' ')[0];
                      String onlyTime =
                          dateTimeString.split(' ')[1].substring(0, 5);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    " ارسال کننده : ${data![index].sender.firstName} ${data![index].sender.lastName}"),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      id = data![index].id;
                                    });
                                    edit_message();
                                  },
                                  child: const Text(
                                    "خوانده شد",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text(" پیام ارسالی "),
                                      ),
                                      Expanded(child: Divider()),
                                    ],
                                  ),
                                  Text(data![index].content),
                                ],
                              ),
                            ),
                            // const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  onlyDate.toString().toPersianDigit(),
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                Text(
                                  onlyTime.toString().toPersianDigit(),
                                  style: const TextStyle(color: Colors.blue),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: Text("پیامی وجود ندارد"))
            : Center(
                child:
                    Lottie.asset("assets/lottie/loading.json", height: 40.0)),
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  Future get_message_by_user_id() async {
    String infourl = Helper.url.toString() +
        'message/get_message_by_user_id/' +
        id_user.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = messageModelFromJson(x);
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

  int? id;
  Future edit_message() async {
    var body = jsonEncode({"id": id, "is_read": true});
    print(body);
    String infourl = Helper.url.toString() + 'message/edit_message';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_message_by_user_id();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
