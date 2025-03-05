import 'dart:async';
import 'dart:convert';

import 'package:ed/pages/home/kargozini/request/kargozini_loan_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../models/fund/count_fund_model.dart';
import '../../../../static/helper_page.dart';
import 'kargozini_all_request_page.dart';
import 'kargozini_request_page.dart';

class RequestFirstPage extends StatefulWidget {
  const RequestFirstPage({super.key});

  @override
  State<RequestFirstPage> createState() => _RequestFirstPageState();
}

class _RequestFirstPageState extends State<RequestFirstPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  Timer? timer;
  int? count_fund;
  int? count_loan;
  int? count_all;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    get_count_fund();
    timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => get_count_fund());
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Tab> topTabs = <Tab>[
      Tab(
        text: "همه",
        icon: count_all == 0
            ? const SizedBox()
            : Text(
                count_all?.toString().toPersianDigit() ??
                    0.toString().toPersianDigit(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      Tab(
        text: "صندوق",
        icon: count_fund == 0
            ? const SizedBox()
            : Text(
                count_fund?.toString().toPersianDigit() ??
                    0.toString().toPersianDigit(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      Tab(
        text: "وام",
        icon: count_loan == 0
            ? const SizedBox()
            : Text(
                count_loan?.toString().toPersianDigit() ??
                    0.toString().toPersianDigit(),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 10,
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.blueGrey,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "Vazir"),
            tabs: topTabs,
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            KargoziniAllRequestPage(),
            KargoziniRequestPage(),
            KargoziniLoanRequestPage(),
          ],
        ),
      ),
    );
  }

  bool? is_get_count = false;
  Future<void> get_count_fund() async {
    String infourl = Helper.url.toString() + 'loan/get_all_count_request';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      var x = response.body;
      CountFundModel recive_data = CountFundModel.fromJson(json.decode(x));

      // بررسی mounted قبل از فراخوانی setState
      if (mounted) {
        setState(() {
          count_loan = recive_data.loanCount;
          count_fund = recive_data.fundCount;
          count_all = recive_data.sumCount;
          is_get_count = true;
        });
      }
      print(count_fund);
    } else if (response.statusCode == 204) {
      if (mounted) {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } else {
      if (mounted) {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    }
  }
}
