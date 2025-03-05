import 'dart:convert';
import 'package:ed/models/anbar/anbar_request_all.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../static/helper_page.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class ManagerAnbarRequest extends StatefulWidget {
  const ManagerAnbarRequest({super.key});

  @override
  State<ManagerAnbarRequest> createState() => _ManagerAnbarRequestState();
}

class _ManagerAnbarRequestState extends State<ManagerAnbarRequest> {
  @override
  void initState() {
    get_all_anbar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: is_get_data
            ? combinedData.isNotEmpty
                ? ListView.builder(
                    itemCount: combinedData.length,
                    itemBuilder: (context, index) {
                      final item = combinedData[index];

                      if (item is AnbarDatum) {
                        return _buildAnbarItem(item);
                      } else if (item is ShoppingDatum) {
                        return const SizedBox();
                      } else {
                        return const ListTile(title: Text('Unknown Item'));
                      }
                    },
                  )
                : const Center(child: Text("درخواستی وجود ندارد"))
            : Center(
                child:
                    Lottie.asset("assets/lottie/loading.json", height: 40.0)),
      )),
    );
  }

  Widget button(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: color,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildAnbarItem(AnbarDatum anbar) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "درخواست کالا",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "تاریخ ${FormateDateCreateChange.formatDate(anbar.createAt.toString())}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: anbar.commodities!.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${(index + 1).toString().toPersianDigit()} : ${anbar.commodities![index].name.toString()}"),
                    Text(
                        "تعداد : ${anbar.commodities![index].count.toString().toPersianDigit()} ${anbar.commodities![index].unit}")
                  ],
                );
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(
                  anbar.managerAccept == true || anbar.salonAccept == true
                      ? Icons.check
                      : Icons.clear,
                  color:
                      anbar.managerAccept == true || anbar.salonAccept == true
                          ? Colors.green
                          : Colors.red,
                  size: 15.0,
                ),
              ),
              Text(
                  "تاییدیه مدیر واحد : ${anbar.managerAccept == true || anbar.salonAccept == true ? "تایید شده" : "منتظر تایید"}"),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(
                  anbar.isAccept == true || anbar.isAccept == true
                      ? Icons.check
                      : Icons.clear,
                  color:
                      anbar.managerAccept == true || anbar.salonAccept == true
                          ? Colors.green
                          : Colors.red,
                  size: 15.0,
                ),
              ),
              Text(
                  "تاییدیه مدیر اصلی : ${anbar.isAccept == true || anbar.isAccept == true ? "تایید شده" : "منتظر تایید"}"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: button("تایید", Colors.green, () {
                      setState(() {
                        isSelect = true;
                        anbarID = anbar.id;
                      });
                      edit_anbar();
                    }),
                  ),
                  button("لغو", Colors.red, () {
                    setState(() {
                      isSelect = false;
                      anbarID = anbar.id;
                      ;
                    });
                    edit_anbar();
                  }),
                ],
              ),
              button("ویرایش", Colors.blue, () {
                setState(() {
                  // is_select_export = true;
                  anbarID = anbar.id;
                });
                // acceptExport();
              }),
            ],
          )
        ],
      ),
    );
  }

  // Widget _buildShopItem(ShoppingDatum shop) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
  //     margin: const EdgeInsets.symmetric(vertical: 5.0),
  //     decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey.withOpacity(0.5)),
  //         color: Colors.grey.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(5.0)),
  //     child: Column(
  //       children: [],
  //     ),
  //   );
  // }

  bool is_get_data = false;
  List<dynamic> combinedData = [];
  List<dynamic> shop_data = [];
  List<dynamic> anbar_data = [];
  Future get_all_anbar() async {
    String infourl = Helper.url.toString() + 'anbar/get_combined_data';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      AnbarRequestAllModel recive_data =
          AnbarRequestAllModel.fromJson(json.decode(x));
      setState(() {
        shop_data = recive_data.shoppingData ?? [];
        anbar_data = recive_data.anbarData ?? [];
        is_get_data = true;
        combinedData = [
          ...shop_data,
          ...anbar_data,
        ];
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? anbarID;
  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  bool isSelect = false;
  Future edit_anbar() async {
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "anbar_accept": isSelect ? true : false,
      "anbar_date": dateTimeString
    });
    String infourl = Helper.url.toString() + 'anbar/edit_anbar/${anbarID}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_anbar();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
