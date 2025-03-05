import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../models/loan_fund_model.dart';
import '../../../../static/helper_page.dart';

class KargoziniAllRequestPage extends StatefulWidget {
  const KargoziniAllRequestPage({super.key});

  @override
  State<KargoziniAllRequestPage> createState() =>
      _KargoziniAllRequestPageState();
}

class _KargoziniAllRequestPageState extends State<KargoziniAllRequestPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // double my_height = MediaQuery.of(context).size.height;
    // double my_width = MediaQuery.of(context).size.width;
    return combinedData.isNotEmpty
        ? Padding(
            padding: PagePadding.page_padding,
            child: ListView.builder(
              itemCount: combinedData.length,
              itemBuilder: (context, index) {
                if (combinedData[index] is Loan) {
                  Loan loan = combinedData[index];
                  return loan_show(loan);
                } else if (combinedData[index] is Fund) {
                  Fund fund = combinedData[index];
                  return fund_show(fund);
                }
                return const SizedBox.shrink();
              },
            ),
          )
        : const Center(child: Text("درخواستی وجود ندارد"));
  }

  List<dynamic> combinedData = [];
  Future<void> fetchData() async {
    String infourl = Helper.url.toString() + 'all_data/get_all_loan_and_fund';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Loan> loans = (jsonData['loan'] as List)
          .map((loan) => Loan.fromJson(loan))
          .toList();
      List<Fund> funds = (jsonData['fund'] as List)
          .map((fund) => Fund.fromJson(fund))
          .toList();

      setState(() {
        combinedData = [...loans, ...funds];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget fund_show(var data) {
    String dateTimeString = data.createAt!.toString();
    String onlyDate = dateTimeString.split(' ')[0];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.user.firstName} ${data.user.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("تاریخ درخواست : ${FormateDate.formatDate(onlyDate)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.blue)),
              ],
            ),
            const Divider(),
            const Text(
              "درخواست تغییر مبلغ صندوق",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            Text(
                "درخواست تغییر مبلغ واریز به صندوق : ${data.money.toString().toPersianDigit().seRagham()} ریال"),
            Text(" به ریال : ${data.money.toString().toWord()} ریال"),
            Text(
                " به تومان : ${data.money.toString().beToman().toWord()} تومان"),
          ],
        ),
      ),
    );
  }

  Widget loan_show(var data) {
    String dateTimeString = data.createAt!.toString();
    String onlyDate = dateTimeString.split(' ')[0];
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.user.firstName} ${data.user.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("تاریخ درخواست : ${FormateDate.formatDate(onlyDate)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.blue)),
              ],
            ),
            const Divider(),
            const Text(
              "درخواست وام",
              style:
                  TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
            ),
            Text(
                " مبلغ درخواستی وام : ${data.moneyRequest.toString().toPersianDigit().seRagham()} ریال"),
            Text(" به ریال : ${data.moneyRequest.toString().toWord()} ریال"),
            Text(
                " به تومان : ${data.moneyRequest.toString().beToman().toWord()} تومان"),
          ],
        ),
      ),
    );
  }
}
