import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/loan/loan_model.dart';
import '../../../../../../static/helper_page.dart';

class AdminLoanPage extends StatefulWidget {
  const AdminLoanPage({super.key});

  @override
  State<AdminLoanPage> createState() => _AdminLoanPageState();
}

class _AdminLoanPageState extends State<AdminLoanPage> {
  @override
  void initState() {
    get_loan_admin();
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
                    return loan_show(data![index]);
                  },
                )
              : const Center(child: Text("داده ای وجود ندارد"))
          : Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0)),
    );
  }

  Widget loan_show(var data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "درخواست وام",
                style: TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'درخواست کننده : ${data.user.firstName} ${data.user.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    "${FormateDateCreate.formatDate(data.createAt!.toString())}",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.blue)),
              ],
            ),
            const Divider(),
            Text(
                " مبلغ درخواستی وام : ${data.moneyRequest.toString().toPersianDigit().seRagham()} ریال"),
            Text(" به ریال : ${data.moneyRequest.toString().toWord()} ریال"),
            Text(
                " به تومان : ${data.moneyRequest.toString().beToman().toWord()} تومان"),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        loan_id = data!.id;
                      });
                      accept_loan();
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
                        loan_id = data!.id;
                      });
                      reject_loan();
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
      ),
    );
  }

  List? data = [];
  bool is_get_data = false;
  Future get_loan_admin() async {
    String infourl = Helper.url.toString() + 'loan/get_admin_loan';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = loanModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
      print(data);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  int? loan_id;
  Future accept_loan() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body = jsonEncode({"is_manager": true, "manager_date": dateTimeString});
    String infourl = Helper.url.toString() + 'loan/edit_loan_admin/${loan_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_loan_admin();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future reject_loan() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";

    var body =
        jsonEncode({"is_manager": false, "manager_date": dateTimeString});
    String infourl = Helper.url.toString() + 'loan/edit_loan_admin/${loan_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_loan_admin();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
