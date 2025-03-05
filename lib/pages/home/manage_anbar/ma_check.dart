import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ed/pages/home/manage_anbar/cartex/cartex_firstpage.dart';
import 'package:ed/pages/home/manage_anbar/clothes/clothe_firstpage.dart';
import 'package:ed/pages/home/manage_anbar/export_com/ma_export_firstpage.dart';
import 'package:ed/pages/home/manage_anbar/import_com/ma_import_firstpage.dart';
import 'package:ed/pages/home/manage_anbar/personel/ma_personel_firstpage.dart';
import 'package:ed/pages/home/manage_anbar/report/ma_report_firstpage.dart';
import 'package:ed/pages/home/manage_anbar/request/request_firstpage.dart';
import 'package:flutter/material.dart';
import '../../../components/count_widget.dart';
import '../../../models/anbar/count_anbar_all_model.dart';
import '../../../models/fund/count_fund_model.dart';
import '../../../static/helper_page.dart';
import '../Shopping/shop_firstpage.dart';

class ManagerAnbarCheck extends StatefulWidget {
  const ManagerAnbarCheck({super.key});

  @override
  State<ManagerAnbarCheck> createState() => _ManagerAnbarCheckState();
}

class _ManagerAnbarCheckState extends State<ManagerAnbarCheck> {
  List? data = [
    {"id": 0, "title": "درخواست ها", "icon": "assets/image/request.png"},
    {"id": 1, "title": "کارتکس", "icon": "assets/image/list.png"},
    {"id": 2, "title": "لباس کار", "icon": "assets/image/clothe.png"},
    {"id": 3, "title": "ورود کالا", "icon": "assets/image/import.png"},
    {"id": 4, "title": "خروج کالا", "icon": "assets/image/export.png"},
    {"id": 5, "title": "گزارشات", "icon": "assets/image/report.png"},
    {"id": 6, "title": "کارمندان", "icon": "assets/image/team.png"},
    {"id": 7, "title": "خرید", "icon": "assets/image/shop.png"},
  ];
  @override
  void initState() {
    super.initState();
    get_all_count_request_anbar();
    timer = Timer.periodic(
        const Duration(minutes: 1), (Timer t) => get_all_count_request_anbar());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: data!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (data![index]['title'] == "درخواست ها") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManagerAnbarRequest(),
                    ));
              } else if (data![index]['title'] == "کارتکس") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManagerAnbarCartex(),
                    ));
              } else if (data![index]['title'] == "لباس کار") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManagerAnbarClothe(),
                    ));
              } else if (data![index]['title'] == "ورود کالا") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManagerAnbarImportFirstpage(),
                    ));
              } else if (data![index]['title'] == "خروج کالا") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ManagerAcceptExportFirstPage(),
                    ));
              } else if (data![index]['title'] == "گزارشات") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ManageraAnbarReportFirstpage(),
                    ));
              } else if (data![index]['title'] == "کارمندان") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ManagerAnbarPersonelFirstPage(),
                    ));
              } else if (data![index]['title'] == "خرید") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ShopFirstPage(),
                    ));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(data![index]['icon'], height: 35.0),
                        Text(
                          data![index]['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  data![index]['id'] == 0
                      ? count_anbar == 0
                          ? const SizedBox()
                          : BadgeWidget(
                              child: Icon(Icons.notifications, size: 20),
                              value: count_anbar!)
                      : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Timer? timer;
  int? count_anbar = 0;
  bool? count_get = false;
  Future<void> get_all_count_request_anbar() async {
    String infourl =
        Helper.url.toString() + 'all_data/get_all_count_request_anbar';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      CountAnbarAllModel recive_data =
          CountAnbarAllModel.fromJson(json.decode(x));
      setState(() {
        count_anbar = recive_data.anbarCount;
        count_get = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
