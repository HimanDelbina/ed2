import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/models/guard/import/import_commodity_model.dart';
import '../../../../services/car_plate_display.dart';
import '../../../../static/helper_page.dart';

class ManagerAnbarImportComRequest extends StatefulWidget {
  const ManagerAnbarImportComRequest({super.key});

  @override
  State<ManagerAnbarImportComRequest> createState() =>
      _ManagerAnbarImportComFirstpageState();
}

class _ManagerAnbarImportComFirstpageState
    extends State<ManagerAnbarImportComRequest> {
  @override
  void initState() {
    super.initState();
    get_commodity_isanbar();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: PagePadding.page_padding,
        child: is_get_data == false
            ? Center(
                child: Lottie.asset("assets/lottie/loading.json", height: 40.0))
            : data!.isEmpty
                ? const Center(child: Text("داده ای وجود ندارد"))
                : ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "درخواست ورود ${data![index].select == "M" ? "مواد اولیه" : "کالا"}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    FormateDateCreate.formatDate(
                                        data![index].createAt.toString()),
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("کالا : ${data![index].name} "),
                                Text(
                                    "تعداد : ${data![index].countCommodity == null ? 0.toString().toPersianDigit() : data![index].countCommodity.toString().toPersianDigit()} "),
                                Text(
                                    "وزن : ${data![index].weightCommodity == null ? 0.toString().toPersianDigit() : data![index].weightCommodity.toString().toPersianDigit()} "),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CarPlateDisplay(
                                    carPlate: data![index].carPlate),
                                Text("نوع خودرو : ${data![index].car.name}")
                              ],
                            ),
                            Text(
                                "شماره تماس راننده : ${data![index].carPhone.toString().toPersianDigit()}"),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        is_edit = false;
                                        is_anbar = true;
                                        id_select = data![index].id;
                                      });
                                      edit_com();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.green),
                                      padding:
                                          const EdgeInsetsDirectional.symmetric(
                                              horizontal: 15.0, vertical: 5.0),
                                      margin:
                                          const EdgeInsetsDirectional.symmetric(
                                              vertical: 5.0),
                                      child: const Center(
                                        child: Text(
                                          "تایید",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      is_edit = true;
                                      is_anbar = false;
                                      id_select = data![index].id;
                                    });
                                    edit_com();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.red),
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                    margin:
                                        const EdgeInsetsDirectional.symmetric(
                                            vertical: 5.0),
                                    child: const Center(
                                      child: Text(
                                        "اصلاح",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
      )),
    );
  }

  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;
  Future get_commodity_isanbar() async {
    String infourl = Helper.url.toString() + 'guard/get_commodity_isanbar';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = importCommodityModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Jalali? date_now = Jalali.now();
  DateTime timeNow = DateTime.now();

  String? formattedTime = '';
  bool? is_edit = false;
  bool? is_anbar = false;
  int? id_select;
  Future edit_com() async {
    String jalaliDateTime = "${timeNow.hour}:${timeNow.minute}";
    formattedTime = DateFormat.Hm().format(timeNow);
    var jalaliDate = date_now!.formatter.yyyy +
        '-' +
        date_now!.formatter.mm +
        '-' +
        date_now!.formatter.dd +
        ' ' +
        formattedTime!;
    var body = is_anbar!
        ? jsonEncode({
            "is_anbar": is_anbar,
            "is_edit": is_edit,
            "anbar_date": jalaliDate
          })
        : jsonEncode({"is_anbar": is_anbar, "is_edit": is_edit});
    print(body);
    String infourl =
        Helper.url.toString() + 'guard/edit_commodity/${id_select}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
      get_commodity_isanbar();
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
