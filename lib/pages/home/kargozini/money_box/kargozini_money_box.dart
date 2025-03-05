import 'dart:convert';

import 'package:ed/models/fund/fund_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../static/helper_page.dart';

class KargoziniMoneyBoxPage extends StatefulWidget {
  const KargoziniMoneyBoxPage({super.key});

  @override
  State<KargoziniMoneyBoxPage> createState() => _KargoziniMoneyBoxPageState();
}

class _KargoziniMoneyBoxPageState extends State<KargoziniMoneyBoxPage> {
  @override
  void initState() {
    get_all_fund();
    super.initState();
  }

  var show_data_Search = [];
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
                        data = SearcUser.search(
                            show_data_Search, value, "firstName");
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
              Expanded(
                  child: is_get_data!
                      ? ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            user_search_controller.text == ""
                                ? data = data_show
                                : data = data;
                            show_data_Search = data_show!;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(5.0)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${data![index].user.firstName} ${data![index].user.lastName}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "واحد : ${data![index].user.unit.name}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.blue),
                                        ),
                                        Text(
                                          data![index].user.isActive
                                              ? "فعال"
                                              : "غیر فعال",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: data![index].user.isActive
                                                  ? Colors.green
                                                  : Colors.red),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                                "کل ذخیره صندوق : ${data![index].allMoney.toString().toPersianDigit().seRagham()} ریال"),
                                            Text(
                                                "مبلغ برداشتی هر ماه : ${data![index].money.toString().toPersianDigit().seRagham()} ریال"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "تغییر مبلغ صندوق",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          Expanded(child: Divider()),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: my_form(
                                                controllerMoney,
                                                money,
                                                'مبلغ',
                                                false,
                                                Icons.attach_money,
                                                TextInputType.number)),
                                        GestureDetector(
                                          onTap: () {
                                            if (controllerMoney.text == "") {
                                              MyMessage.mySnackbarMessage(
                                                  context,
                                                  "لطفا مبلغ را انتخاب کنید",
                                                  2);
                                            } else if (int.parse(
                                                    controllerMoney.text) <=
                                                2000000) {
                                              MyMessage.mySnackbarMessage(
                                                  context,
                                                  "مبلغ باید کمتر از ${2000000.toString().toPersianDigit()} ریال نباشد",
                                                  2);
                                            } else {
                                              setState(() {
                                                box_id = data![index].id;
                                              });
                                              edit_fund();
                                            }
                                          },
                                          child: Container(
                                            height: my_height * 0.06,
                                            width: my_width * 0.25,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            margin: const EdgeInsets.only(
                                                right: 10.0),
                                            child: const Center(
                                              child: Text(
                                                "تغییر مبلغ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    controllerMoney.text.isEmpty
                                        ? const SizedBox()
                                        : Text(
                                            "${controllerMoney.text.toString().toWord()} ریال"),
                                    controllerMoney.text.isEmpty
                                        ? const SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${controllerMoney.text.toString().toPersianDigit().seRagham()} ریال"),
                                              Text(
                                                  "${controllerMoney.text.toString().beToman().toPersianDigit().seRagham()} تومان"),
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Lottie.asset("assets/lottie/loading.json",
                              height: 40.0))),
            ],
          ),
        ),
      ),
    );
  }

  String? money = "";
  TextEditingController controllerMoney = TextEditingController();
  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        onChanged: (value) {
          setState(() {
            controller.text = value;
          });
        },
        keyboardType: type,
        obscureText: is_show,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
        ),
      ),
    );
  }

  List? data = [];
  List? data_show = [];
  bool? is_get_data = false;
  Future get_all_fund() async {
    String infourl = Helper.url.toString() + 'stipend/get_all_fund';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = fundModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? box_id;
  Future edit_fund() async {
    var body = jsonEncode(
        {"id": box_id, "money": controllerMoney.text.toEnglishDigit()});
    String infourl = Helper.url.toString() + 'stipend/edit_fund';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      setState(() {
        controllerMoney.clear();
      });
      get_all_fund();
      MyMessage.mySnackbarMessage(context, "صندوق با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
