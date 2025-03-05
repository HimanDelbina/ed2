import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../models/anbar/cloth_model.dart';
import '../../../../static/helper_page.dart';

class ClotheSelect extends StatefulWidget {
  int? user_id;
  ClotheSelect({super.key, this.user_id});

  @override
  State<ClotheSelect> createState() => _ClotheSelectState();
}

class _ClotheSelectState extends State<ClotheSelect> {
  @override
  void initState() {
    super.initState();
    get_clothe_by_user_id();
  }

  String? onlyDate;
  String? onlyclothDate;
  String? onlyshoesDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: PagePadding.page_padding,
            child: is_get_data == false
                ? Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0))
                : data!.isEmpty
                    ? const Center(child: Text("داده ای وجود ندارد"))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "تعداد کل دریافت لباس کار تا به امروز : ${cloth_count.toString().toPersianDigit()}"),
                          Text(
                              "تعداد کل دریافت کفش کار تا به امروز : ${shoes_count.toString().toPersianDigit()}"),
                          const Divider(color: Colors.blue),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              data_last_cloth == null
                                  ? const Text(
                                      "کاربر هنوز لباس کار دریافت نکرده")
                                  : Text(
                                      "کاربر در تاریخ ${FormateDateCreateChange.formatDate(data_last_cloth!.clothDate.toString())} آخرین لباس کار خود را دریافت کرده "),
                              data_last_cloth.daysLeftCloth <= 0
                                  ? const Text(
                                      "کاربر میتواند لباس کار دریافت کند",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      "لباس کار : ${data_last_cloth.daysLeftCloth.toString().toPersianDigit()} روز مانده "),
                              const Divider(),
                              data_last_shoes == null
                                  ? const Text(
                                      "کاربر هنوز کفش کار دریافت نکرده")
                                  : Text(
                                      "کاربر در تاریخ ${FormateDateCreateChange.formatDate(data_last_shoes!.shoesDate.toString())} آخرین کفش کار خود را دریافت کرده "),
                              data_last_shoes == null
                                  ? const SizedBox()
                                  : data_last_shoes.daysLeftCloth <= 0
                                      ? const Text(
                                          "کاربر میتواند کفش کار دریافت کند",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "کفش کار : ${data_last_shoes.daysLeftCloth.toString().toPersianDigit()} روز مانده ")
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Text("جزییات"),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              String endDateString =
                                  data![index].createAt.toString();
                              onlyDate = endDateString.split(' ')[0];
                              data_last_cloth == null
                                  ? clotheDateString = ''
                                  : clotheDateString =
                                      data![index].clothDate.toString();
                              data_last_cloth == null
                                  ? onlyclothDate = ''
                                  : onlyclothDate =
                                      clotheDateString!.split(' ')[0];
                              data_last_shoes == null
                                  ? shoesDateString = ""
                                  : shoesDateString =
                                      data![index].shoesDate.toString();
                              data_last_shoes == null
                                  ? onlyshoesDate = ''
                                  : onlyshoesDate =
                                      shoesDateString!.split(' ')[0];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                margin: const EdgeInsetsDirectional.symmetric(
                                    vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "تاریخ ثبت درخواست : ${FormateDate.formatDate(onlyDate!)}",
                                        style: const TextStyle(
                                            color: Colors.blue)),
                                    const Divider(),
                                    data![index].isCloth
                                        ? Text(
                                            "شما لباس کار خود را در تاریخ ${FormateDate.formatDate(onlyclothDate!)} تحویل گرفته اید .")
                                        : const SizedBox(),
                                    data![index].isCloth
                                        ? Row(
                                            children: [
                                              data![index].daysLeftCloth <= 0
                                                  ? const Text(
                                                      "شما میتوانید درخواست لباس کار جدبد بدید")
                                                  : Text(
                                                      data![index]
                                                          .daysLeftCloth
                                                          .toString()
                                                          .toPersianDigit(),
                                                      style: TextStyle(
                                                          color: data![index]
                                                                      .daysLeftCloth >
                                                                  0
                                                              ? Colors.red
                                                              : Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                              data![index].daysLeftCloth <= 0
                                                  ? const SizedBox()
                                                  : const Text(
                                                      " روز مانده برای درخواست لباس کار جدید")
                                            ],
                                          )
                                        : const SizedBox(),
                                    data![index].isShoes
                                        ? const Divider()
                                        : const SizedBox(),
                                    data![index].isShoes
                                        ? Text(
                                            "شما کفش کار خود را در تاریخ ${FormateDate.formatDate(onlyshoesDate!)} تحویل گرفته اید .")
                                        : const SizedBox(),
                                    data![index].isShoes
                                        ? Row(
                                            children: [
                                              data![index].daysLeftShoes <= 0
                                                  ? const Text(
                                                      "شما میتوانید درخواست کفش کار جدبد بدید")
                                                  : Text(
                                                      data![index]
                                                          .daysLeftShoes
                                                          .toString()
                                                          .toPersianDigit(),
                                                      style: TextStyle(
                                                          color: data![index]
                                                                      .daysLeftShoes >
                                                                  0
                                                              ? Colors.red
                                                              : Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                              data![index].daysLeftShoes <= 0
                                                  ? const SizedBox()
                                                  : const Text(
                                                      " روز مانده برای درخواست کفش کار جدید")
                                            ],
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              );
                            },
                          ))
                        ],
                      )),
      ),
    );
  }

  String? shoesDateString;
  String? clotheDateString;
  List? data = [];
  var data_last_cloth;
  var data_last_shoes;
  bool? is_get_data = false;
  int? shoes_count;
  int? cloth_count;
  double? sumData;
  Future get_clothe_by_user_id() async {
    String infourl = Helper.url.toString() +
        'anbar/get_cloth_by_user_id/' +
        widget.user_id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;

      var recive_data = clothModelFromJson(x);
      setState(() {
        data = recive_data.data;
        data_last_cloth = recive_data.lastIsCloth;
        data_last_shoes = recive_data.lastIsShoes;
        shoes_count = recive_data.totalIsShoes;
        cloth_count = recive_data.totalIsCloth;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
