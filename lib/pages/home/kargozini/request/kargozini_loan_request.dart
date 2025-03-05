import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../models/loan/loan_model.dart';
import '../../../../static/helper_page.dart';

class KargoziniLoanRequestPage extends StatefulWidget {
  const KargoziniLoanRequestPage({super.key});

  @override
  State<KargoziniLoanRequestPage> createState() =>
      _KargoziniLoanRequestPageState();
}

class _KargoziniLoanRequestPageState extends State<KargoziniLoanRequestPage> {
  @override
  void initState() {
    super.initState();
    get_all_loan();
  }

  bool? is_save_money = false;
  bool? is_loan_normal = false;
  bool? is_loan_essential = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ListView.builder(
          itemCount: data!.length,
          itemBuilder: (context, index) {
            String dateTimeString = data![index].createAt!.toString();
            String onlyDate = dateTimeString.split(' ')[0];
            return GestureDetector(
              onTap: () {
                setState(() {
                  loan_id = data![index].id;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data![index].user.firstName} ${data![index].user.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        FormateDate.formatDate(onlyDate),
                        style: const TextStyle(color: Colors.blue),
                      )
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data![index].description == null
                          ? const SizedBox()
                          : Text(data![index].description),
                      const Divider(),
                      Text(
                          " مبلغ درخواستی وام : ${data![index].moneyRequest.toString().toPersianDigit().seRagham()} ریال"),
                      Text(
                          " به ریال : ${data![index].moneyRequest.toString().toWord()} ریال"),
                      Text(
                          " به تومان : ${data![index].moneyRequest.toString().beToman().toWord()} تومان"),
                    ],
                  ),
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: boolList![index]['is_box'],
                          onChanged: (value) {
                            setState(() {
                              boolList![index]['is_box'] = value!;
                              is_box = value;
                              controllerSaveMoney.clear();
                            });
                          },
                        ),
                        const Text("ذخیره صندوق "),
                      ],
                    ),
                    boolList![index]['is_box']!
                        ? my_form(
                            controllerSaveMoney,
                            save_money,
                            "ذخیره صندوق ",
                            false,
                            Icons.attach_money_outlined,
                            TextInputType.number)
                        : const SizedBox(),
                    controllerSaveMoney.text.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Text(
                                    "${controllerSaveMoney.text.toWord()} ریال"),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const Divider(),
                    Row(
                      children: [
                        Checkbox(
                          value: boolList![index]['is_loan_normal'],
                          onChanged: (value) {
                            setState(() {
                              boolList![index]['is_loan_normal'] = value!;
                              is_loan_ma = value;
                              controllerLoanNormal.clear();
                            });
                          },
                        ),
                        const Text("آیا وام صندوق دارد"),
                      ],
                    ),
                    boolList![index]['is_loan_normal']!
                        ? my_form(
                            controllerLoanNormal,
                            loan_normal,
                            "وام صندوق",
                            false,
                            Icons.attach_money_outlined,
                            TextInputType.number)
                        : const SizedBox(),
                    controllerLoanNormal.text.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Text(
                                    "${controllerLoanNormal.text.toWord()} ریال"),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const Divider(),
                    Row(
                      children: [
                        Checkbox(
                          value: boolList![index]['is_loan_ess'],
                          onChanged: (value) {
                            setState(() {
                              boolList![index]['is_loan_ess'] = value!;
                              is_loan_za = value;
                              controllerLoanEssential.clear();
                            });
                          },
                        ),
                        const Text("آیا وام ضروری دارد"),
                      ],
                    ),
                    boolList![index]['is_loan_ess']!
                        ? my_form(
                            controllerLoanEssential,
                            loan_essential,
                            "وام ضروری",
                            false,
                            Icons.attach_money_outlined,
                            TextInputType.number)
                        : const SizedBox(),
                    controllerLoanEssential.text.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Text(
                                    "${controllerLoanEssential.text.toWord()} ریال"),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  loan_id = data![index].id;
                                  is_kargozini = true;
                                  is_kargozini_accept = true;
                                  is_manager = false;
                                  is_manager_accept = false;
                                });
                                print("-----------------------");
                                print(loan_id);
                                edit_loan();
                              },
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                margin: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  loan_id = data![index].id;
                                  is_kargozini = true;
                                  is_kargozini_accept = true;
                                  is_manager = true;
                                  is_manager_accept = true;
                                });
                                print("-----------------------");
                                print(loan_id);
                                edit_loan();
                              },
                              child: Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                margin: const EdgeInsetsDirectional.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Center(
                                  child: Text(
                                    "تایید نهایی",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              loan_id = data![index].id;
                              is_kargozini = true;
                              is_kargozini_accept = false;
                              is_manager = false;
                              is_manager_accept = false;
                            });
                            print("-----------------------");
                            print(loan_id);
                            edit_loan();
                          },
                          child: Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            margin: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Center(
                              child: Text(
                                "لغو",
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
              ),
            );
          },
        ));
  }



  List? data = [];
  List? data_show = [];
  List<Map<String, bool>>? boolList;
  bool? is_get_data = false;

  Future get_all_loan() async {
    String infourl = Helper.url.toString() + 'loan/get_all_loan';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = loanModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;

        // ایجاد لیستی از mapها که شامل ۳ مقدار bool است
        boolList = data_show!
            .map((loan) {
              return {
                "is_box": false,
                "is_loan_normal": false,
                "is_loan_ess": false
              };
            })
            .cast<Map<String, bool>>()
            .toList();
        is_get_data = true;
      });
      print(boolList);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? save_money = "";
  String? loan_normal = "";
  String? loan_essential = "";
  TextEditingController controllerSaveMoney = TextEditingController();
  TextEditingController controllerLoanNormal = TextEditingController();
  TextEditingController controllerLoanEssential = TextEditingController();
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

  Jalali? pickedDateStart = Jalali.now();
  int? loan_id;
  bool? is_box = false;
  bool? is_loan_za = false;
  bool? is_loan_ma = false;
  bool? is_kargozini = false;
  bool? is_manager = false;
  bool? is_kargozini_accept = false;
  bool? is_manager_accept = false;
  Future edit_loan() async {
    var kargozini_date = pickedDateStart!.formatter.yyyy +
        '-' +
        pickedDateStart!.formatter.mm +
        '-' +
        pickedDateStart!.formatter.dd +
        ' ' +
        '00:00';
    var manager_date = pickedDateStart!.formatter.yyyy +
        '-' +
        pickedDateStart!.formatter.mm +
        '-' +
        pickedDateStart!.formatter.dd +
        ' ' +
        '00:00';
    var body = jsonEncode({
      "id": loan_id,
      "is_box": is_box,
      "box_money": controllerSaveMoney.text,
      "is_loan_za": is_loan_za,
      "loan_za_money": controllerLoanEssential.text,
      "is_loan_ma": is_loan_ma,
      "loan_ma_money": controllerLoanNormal.text,
      "is_kargozini": is_kargozini,
      "is_manager": is_manager,
      "is_kargozini_accept": is_kargozini_accept,
      "is_manager_accept": is_manager_accept,
      "is_read": true,
      "kargozini_date": kargozini_date,
      "manager_date": manager_date,
    });
    String infourl = Helper.url.toString() + 'loan/edit_loan';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 200) {
      get_all_loan();
      MyMessage.mySnackbarMessage(context, "وام با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
