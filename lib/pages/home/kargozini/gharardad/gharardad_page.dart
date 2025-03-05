import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:ed/models/gharardad/gharardad_small_model.dart';
import 'package:ed/pages/home/kargozini/gharardad/gharardad_edit_page.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'gharardad_create_page.dart';

class GharardadPage extends StatefulWidget {
  const GharardadPage({super.key});

  @override
  State<GharardadPage> createState() => _GharardadPageState();
}

class _GharardadPageState extends State<GharardadPage> {
  @override
  void initState() {
    super.initState();
    get_all_gharardad_small();
  }

  var show_data_Search = [];

  bool? is_all = true;
  bool? is_gharardad = false;
  bool? is_not_gharardad = false;

  TextEditingController user_search_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            children: [
              Container(
                width: my_width,
                child: TextFormField(
                  controller: user_search_controller,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        data = SearcUserGharardad.search(
                            show_data_Search, value, "userName");
                      });
                    });
                  },
                  keyboardType: TextInputType.name,
                  cursorColor: Colors.blue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "جستجو",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(IconlyBold.search),
                    suffixIconColor: Colors.grey,
                  ),
                ),
              ),
              const Divider(),
              Row(
                children: [
                  show_filter(
                    "همه",
                    is_all,
                    () {
                      setState(() {
                        is_all = true;
                        is_gharardad = false;
                        is_not_gharardad = false;
                      });
                      get_all_gharardad_small();
                    },
                  ),
                  show_filter(
                    "قرارداد دارد",
                    is_gharardad,
                    () {
                      setState(() {
                        is_all = false;
                        is_gharardad = true;
                        is_not_gharardad = false;
                      });
                      get_all_gharardad_small();
                    },
                  ),
                  show_filter(
                    "قرارداد ندارد",
                    is_not_gharardad,
                    () {
                      setState(() {
                        is_all = false;
                        is_gharardad = false;
                        is_not_gharardad = true;
                      });
                      get_all_gharardad_small();
                    },
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: is_get_data! == false
                    ? Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 40.0))
                    : data!.isEmpty
                        ? const Center(
                            child: Text("داده ای وجود ندارد"),
                          )
                        : ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              user_search_controller.text == ""
                                  ? data = data_show
                                  : data = data;
                              show_data_Search = data_show!;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GharadadEditPage(
                                                  data: data![index]),
                                        ));
                                  },
                                  child: Container(
                                    width: my_width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data![index].isFinish
                                                  ? "قرارداد ندارد"
                                                  : "قرارداد دارد",
                                              style: TextStyle(
                                                  color: data![index].isFinish
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "تاریخ اتمام قرارداد : ${FormateDateCreateChange.formatDate(data![index].endDate.toString())}",
                                              style: const TextStyle(
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                            color: data![index].isFinish
                                                ? Colors.red
                                                : Colors.green),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data![index].userName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                "مانده قرارداد : ${data![index].remainingDays.toString().toPersianDigit()} روز")
                                          ],
                                        ),
                                        Text(
                                            "مبلغ پایه قرارداد : ${data![index].money.toString().toPersianDigit().seRagham()} ریال"),
                                        data![index].isFinish
                                            ? const Text(
                                                textAlign: TextAlign.justify,
                                                "قرارداد این پرسنل به پایان رسیده است. در صورت خروج کامل از شرکت، می‌توانید با کلیک روی دکمه 'پایان کار' عملیات را تکمیل کنید.")
                                            : const SizedBox(),
                                        data![index].isFinish
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    gharardad_id =
                                                        data![index].id;
                                                  });
                                                  edit_gharardad();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  margin:
                                                      const EdgeInsetsDirectional
                                                          .symmetric(
                                                          vertical: 5.0),
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 5.0),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0),
                                                        child: Text(
                                                          "پایان کار",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Icon(Icons.exit_to_app,
                                                          size: 15.0,
                                                          color: Colors.white)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Center(
            child: Icon(Icons.add, color: Colors.white, size: 30.0)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const GharardadCreatePage()));
        },
      ),
    );
  }

  int? gharardad_id;
  Future edit_gharardad() async {
    var body = jsonEncode({"is_finish_work": true});
    String infourl = Helper.url.toString() +
        'gharardad/edit_gharardad_finish/${gharardad_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_all_gharardad_small();
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;
  String? infourl;
  Future get_all_gharardad_small() async {
    is_all!
        ? infourl = Helper.url.toString() +
            'gharardad/get_all_gharardad_small/?is_finish_work=0'
        : is_gharardad!
            ? infourl = Helper.url.toString() +
                'gharardad/get_all_gharardad_small/?is_finish_work=0&has_contract=1'
            : is_not_gharardad!
                ? infourl = Helper.url.toString() +
                    'gharardad/get_all_gharardad_small/?is_finish_work=0&has_contract=0'
                : infourl = Helper.url.toString() +
                    'gharardad/get_all_gharardad_small/?is_finish_work=0';
    var response = await http.get(Uri.parse(infourl!), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = gharardadSmallModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Widget show_filter(String? title, bool? is_select, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 10.0),
        margin: const EdgeInsets.symmetric(horizontal: 7.0),
        decoration: BoxDecoration(
          color: is_select! ? Colors.blue : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
                color: is_select ? Colors.white : Colors.black,
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
