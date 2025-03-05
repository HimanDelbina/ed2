import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;
import '../../../models/salary/salary_model.dart';
import 'package:iconly/iconly.dart';

class FishPage extends StatefulWidget {
  const FishPage({super.key});

  @override
  State<FishPage> createState() => _FishPageState();
}

class _FishPageState extends State<FishPage> {
  String? melli_code;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      melli_code = prefsUser.getString("melli_code") ?? "";
    });
    if (melli_code != "") {
      get_salary_by_melliCode();
    }
  }

  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  String safeParse(String? value) {
    if (value == null || value.isEmpty) {
      return '0';
    }
    return value.split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        margin: const EdgeInsets.all(10),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(hours: 1),
                        // duration: const Duration(
                        //     days: 365),
                        content: Container(
                            // height: myHeight * 0.7,
                            width: myWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "خالص پرداختی : ${safeParse(data![index].khalesPardakhti.toString().toPersianDigit().seRagham())} ریال",
                                      style:
                                          const TextStyle(color: Colors.amber),
                                    ),
                                    const Divider(),
                                    Container(
                                      width: myWidth,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.green),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(" پرداخت ها ( ریال )",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green)),
                                          Divider(
                                              color: Colors.green
                                                  .withOpacity(0.3)),
                                          Text(
                                              "حقوق پایه : ${safeParse(data![index].hoghoghPaie.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "حق مسکن : ${safeParse(data![index].haghMaskan.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "حق غذا : ${safeParse(data![index].haghGhaza.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "حق بن : ${safeParse(data![index].haghBon.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "پاداش حق جذب : ${safeParse(data![index].padashHaghJazb.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "جمعه کاری : ${safeParse(data![index].jomeKari.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "حق تاهل : ${safeParse(data![index].haghTahaol.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "جمع حقوق و مزایای ناخالص : ${safeParse(data![index].nakhalesPardakhti.toString().toPersianDigit().seRagham())} ریال"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: myWidth,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(" کسورات  ( ریال )",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red)),
                                          Divider(
                                              color:
                                                  Colors.red.withOpacity(0.3)),
                                          Text(
                                              "بیمه سهم کارمند : ${safeParse(data![index].bimeSahmKarmand.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "ذخیره صندوق : ${safeParse(data![index].zakhireSandogh.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "مالیات : ${safeParse(data![index].maliat.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "بیمه تکمیلی درمان : ${safeParse(data![index].bimeTakmiliDarman.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "حق عضویت صندوق : ${safeParse(data![index].haghOzviatSandogh.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "خرید فروشگاه : ${safeParse(data![index].kharidForoshgah.toString().toPersianDigit().seRagham())} ریال"),
                                          Text(
                                              "جمع کسورات : ${safeParse(data![index].jameKosorat.toString().toPersianDigit().seRagham())} ریال"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: myWidth,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("	سایر اطلاعات",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue)),
                                          Divider(
                                              color:
                                                  Colors.blue.withOpacity(0.3)),
                                          Text(
                                              "ساعات کارکرد : ${data![index].satKarkard.toString().toPersianDigit()} ساعت"),
                                          Text(
                                              "مرخصی استحقاقی : ${data![index].morkhasiEstehghaghi.toString().toPersianDigit()} ساعت"),
                                          Text(
                                              "مانده مرخصی : ${data![index].mandeMorkhasi.toString().toPersianDigit()} ساعت"),
                                          Text(
                                              "ساعت جمعه کاری : ${data![index].satJomekari.toString().toPersianDigit()} ساعت"),
                                          Text(
                                              "نرخ حقوق روزانه : ${safeParse(data![index].nerkhHoghoghRozane.toString().toPersianDigit().seRagham())} ریال"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  },
                                  child: Container(
                                      width: myWidth,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                          // color: Colors.grey
                                          //     .withOpacity(0.1),
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child: const Center(child: Text("بستن"))),
                                )
                              ],
                            ))),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
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
                            "فیش حقوقی ${data![index].month.toString().toPersianDigit()} - ${data![index].year.toString().toPersianDigit()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                MyMessage.mySnackbarMessage(context,
                                    "این گزینه در آینده فعال میشود", 2);
                              },
                              child: const Icon(
                                IconlyBold.download,
                                color: Colors.blue,
                              ))
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "خالص پرداختی : ${safeParse(data![index].khalesPardakhti.toString().toPersianDigit().seRagham())} ریال",
                          ),
                          const Text(
                            "جزییات",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List? data = [];
  bool? is_get = false;
  Future get_salary_by_melliCode() async {
    String infourl =
        Helper.url.toString() + 'salary/get_salary_by_melliCode/${melli_code}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = salaryModelFromJson(x);
      setState(() {
        data = recive_data;
        is_get = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
