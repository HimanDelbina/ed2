import 'package:ed/models/report/report_all_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';
import 'package:lottie/lottie.dart';

class AdminAllReportPage extends StatefulWidget {
  const AdminAllReportPage({super.key});

  @override
  State<AdminAllReportPage> createState() => _AdminAllReportPageState();
}

class _AdminAllReportPageState extends State<AdminAllReportPage> {
  @override
  void initState() {
    get_all_report();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: is_get_data!
          ? ListView(
              children: [
                Text(
                  "تعداد کل درخواست ها : ${data.sumCount.toString().toPersianDigit()} درخواست",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    "تعداد کل درخواست های خرید : ${data.shopCount.toString().toPersianDigit()} درخواست"),
                Text(
                    "تعداد کل درخواست های وام : ${data.loanCount.toString().toPersianDigit()} درخواست"),
                Text(
                    "تعداد کل درخواست های کاربران : ${data.userCount.toString().toPersianDigit()} درخواست"),
                const Divider(),
                // نمایش جزئیات درخواست‌های وام
                if (data.loanDetails!.isNotEmpty) ...[
                  const Text(
                    "جزئیات درخواست‌های وام:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...data.loanDetails!.map((loan) => loan_item(loan)).toList(),
                  const Divider(),
                  // نمایش جزئیات درخواست‌های خرید
                  if (data.shopDetails!.isNotEmpty) ...[
                    const Text(
                      "جزئیات درخواست‌های خرید:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...data.shopDetails!
                        .map((shop) => shop_item(shop))
                        .toList(),

                    // نمایش جزئیات درخواست‌های کاربران
                    if (data.userDetails!.isNotEmpty) ...[
                      Text(
                        "جزئیات درخواست‌های کاربران:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ...data.userDetails!
                          .map((user) => ListTile(
                                title: Text(
                                    "شناسه: ${user.id.toString().toPersianDigit()}"),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "نام: ${user.user!.firstName} ${user.user!.lastName}"),
                                    Text("تاریخ ثبت: ${user.createAt}"),
                                  ],
                                ),
                              ))
                          .toList(),
                    ],
                  ],
                ],
              ],
            )
          : Center(
              child: Lottie.asset("assets/lottie/loading.json", height: 40.0),
            ),
    );
  }

  ReportAllModel data = ReportAllModel();
  bool? is_get_data = false;
  Future get_all_report() async {
    String infourl = Helper.url.toString() + 'report/get_all_report';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = reportAllModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Widget loan_item(var loan) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.grey.withOpacity(0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  "درخواست وام ${loan.user!.firstName} ${loan.user!.lastName}"),
              Text(
                  "تاریخ : ${FormateDateCreateChange.formatDate(loan.createAt.toString())}")
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("تاییدیه کارگزینی : "),
                  Icon(loan.isKargoziniAccept! ? Icons.check : Icons.clear,
                      size: 15.0,
                      color:
                          loan.isKargoziniAccept! ? Colors.green : Colors.red),
                ],
              ),
              Text(
                  "تاریخ : ${loan.kargoziniDate == null ? "بررسی نشده" : FormateDateCreateChange.formatDate(loan.kargoziniDate.toString())}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("تاییدیه مدیریت : "),
                  Icon(loan.isManagerAccept! ? Icons.check : Icons.clear,
                      size: 15.0,
                      color: loan.isManagerAccept! ? Colors.green : Colors.red),
                ],
              ),
              Text(
                  "تاریخ : ${loan.managerDate == null ? "بررسی نشده" : FormateDateCreateChange.formatDate(loan.managerDate.toString())}")
            ],
          ),
        ],
      ),
    );
  }

  Widget shop_item(var shop) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Colors.grey.withOpacity(0.5))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("درخواست خرید"),
              Text(
                  "تاریخ : ${shop.createAt == null ? "بررسی نشده" : FormateDateCreateChange.formatDate(shop.createAt.toString())}")
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("تاییدیه مدیریت : "),
                  Icon(shop.managerAccept! ? Icons.check : Icons.clear,
                      size: 15.0,
                      color: shop.managerAccept! ? Colors.green : Colors.red),
                ],
              ),
              Text(
                  "تاریخ : ${shop.managerDate == null ? "بررسی نشده" : FormateDateCreateChange.formatDate(shop.managerDate.toString() ?? "بررسی نشده")}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("تاییدیه بازرگانی : "),
                  Icon(shop.bazarganiAccept! ? Icons.check : Icons.clear,
                      size: 15.0,
                      color: shop.bazarganiAccept! ? Colors.green : Colors.red),
                ],
              ),
              Text(
                  "تاریخ :  ${shop.bazarganiDate == null ? "بررسی نشده" : FormateDateCreateChange.formatDate(shop.bazarganiDate.toString())}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("تاییدیه مدیریت : "),
                  Icon(shop.managerAccept! ? Icons.check : Icons.clear,
                      size: 15.0,
                      color: shop.managerAccept! ? Colors.green : Colors.red),
                ],
              ),
              Text(
                  "تاریخ : ${FormateDateCreateChange.formatDate(shop.managerDate.toString() ?? "بررسی نشده")}")
            ],
          ),
        ],
      ),
    );
  }
}
