import 'dart:async';
import 'dart:convert';
import 'package:ed/models/fund/all_fund_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';

class KargoziniRequestPage extends StatefulWidget {
  const KargoziniRequestPage({super.key});

  @override
  State<KargoziniRequestPage> createState() => _KargoziniRequestPageState();
}

class _KargoziniRequestPageState extends State<KargoziniRequestPage> {
  @override
  void initState() {
    super.initState();
    get_all_fund();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: data!.isNotEmpty
              ? ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    String dateTimeString = data![index].createAt!.toString();
                    String onlyDate = dateTimeString.split(' ')[0];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${data![index].user.firstName} ${data![index].user.lastName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "تاریخ درخواست : ${FormateDate.formatDate(onlyDate)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Text(
                                "درخواست تغییر مبلغ واریز به صندوق : ${data![index].money.toString().toPersianDigit().seRagham()} ریال"),
                            Text(
                                " به ریال : ${data![index].money.toString().toWord()} ریال"),
                            Text(
                                " به تومان : ${data![index].money.toString().beToman().toWord()} تومان"),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      box_id = data![index].id;
                                      user_id = data![index].user.id;
                                      is_accept = true;
                                      is_reject = false;
                                      money = data![index]
                                          .money
                                          .toString()
                                          .toEnglishDigit();
                                    });
                                    edit_fund();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: const Center(
                                      child: Text(
                                        "تایید",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      box_id = data![index].id;
                                      user_id = data![index].user.id;
                                      is_accept = false;
                                      is_reject = true;
                                      money = data![index]
                                          .money
                                          .toString()
                                          .toEnglishDigit();
                                    });
                                    edit_fund();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: const Center(
                                      child: Text(
                                        "لغو",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text("درخواستی وجود ندارد")),
        ),
      ),
    );
  }



  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;

  Future get_all_fund() async {
    String infourl = Helper.url.toString() + 'stipend/get_all_fund_request';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = allFundModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  bool? is_accept = false;
  bool? is_reject = false;
  String? money;
  int? box_id;
  int? user_id;
  Future edit_fund() async {
    var body = jsonEncode({
      "id": box_id,
      "user_id": user_id,
      "money": money,
      "is_read": true,
      "is_accept": is_accept,
      "is_reject": is_reject,
    });
    String infourl = Helper.url.toString() + 'stipend/edit_fund_money';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_fund();
      MyMessage.mySnackbarMessage(context, "صندوق با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
