import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../models/fund/fund_model.dart';
import '../../../../static/helper_page.dart';

class KargoziniMoneyData extends StatefulWidget {
  const KargoziniMoneyData({super.key});

  @override
  State<KargoziniMoneyData> createState() => _KargoziniMoneyDataState();
}

class _KargoziniMoneyDataState extends State<KargoziniMoneyData> {
  @override
  void initState() {
    super.initState();
    get_all_fund();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // برای اسکرول افقی جدول
          child: DataTable(
            border: TableBorder.all(color: Colors.grey, width: 1),
            columnSpacing: 20.0,
            columns: const [
              DataColumn(label: Text('نام')),
              DataColumn(label: Text('واحد')),
              DataColumn(label: Text('وضعیت')),
              DataColumn(label: Text('کل ذخیره صندوق')),
              DataColumn(label: Text('مبلغ برداشتی ماهانه')),
              DataColumn(label: Text('عملیات')),
            ],
            rows: data!.map((item) {
              return DataRow(cells: [
                DataCell(Text("${item.user.firstName} ${item.user.lastName}")),
                DataCell(Text("واحد : ${item.user.unit.name}")),
                DataCell(Text(
                  item.user.isActive ? "فعال" : "غیر فعال",
                  style: TextStyle(
                      color: item.user.isActive ? Colors.green : Colors.red),
                )),
                DataCell(Text(
                    "${item.allMoney.toString().toPersianDigit().seRagham()} ریال")),
                DataCell(Text(
                    "${item.money.toString().toPersianDigit().seRagham()} ریال")),
                DataCell(
                  GestureDetector(
                    onTap: () {
                      // عملیات تغییر مبلغ
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("تغییر مبلغ صندوق"),
                            content: TextField(
                              controller: controllerMoney,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "مبلغ جدید را وارد کنید"),
                              onChanged: (value) {
                                controllerMoney.text = value;
                              },
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    box_id = item.id;
                                  });
                                  edit_fund();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("ذخیره"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("لغو"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text("تغییر مبلغ",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]);
            }).toList(),
          ),
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

  TextEditingController controllerMoney = TextEditingController();
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
