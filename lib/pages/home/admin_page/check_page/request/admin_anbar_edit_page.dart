import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;
import '../../../../../../models/manager/manager_request_model.dart';
import '../../../../../../models/shop/shop_report_model.dart';
import 'request_first_page.dart';

class AdminAnbarEditPage extends StatefulWidget {
  List<dynamic>? data;
  int? anbar_id;
  AdminAnbarEditPage({super.key, this.data, this.anbar_id});

  @override
  State<AdminAnbarEditPage> createState() => _ManagerShopState();
}

class _ManagerShopState extends State<AdminAnbarEditPage> {
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // ایجاد کنترلرهای متن برای هر کالا
    _controllers.addAll(widget.data!
        .map((item) => TextEditingController(text: item.count))
        .toList());
  }

  @override
  void dispose() {
    // آزادسازی حافظه کنترلرها
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateItem(int index) {
    setState(() {
      widget.data![index].count = _controllers[index].text;
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.data!.removeAt(index);
      _controllers.removeAt(index);
    });
  }

  List<ShopData>? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('ویرایش کالاها')),
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    // اطمینان از نوع داده ورودی
                    itemCount: widget.data!.length,
                    itemBuilder: (context, index) {
                      Commodity item =
                          widget.data![index]; // گرفتن یک نمونه از کلاس

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${(index + 1).toString().toPersianDigit()} : ${item.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "تعداد : ${item.count.toString().toPersianDigit()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                children: [
                                  Text("تغییر تعداد کالا "),
                                  Expanded(child: Divider())
                                ],
                              ),
                            ),
                            TextFormField(
                              initialValue: item.count,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  item.count = value;
                                });
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(children: [
                                Text("حذف کالا "),
                                Expanded(child: Divider())
                              ]),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.data!.removeAt(index);
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Center(
                                  child: Text(
                                    "حذف این آیتم",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () {
                  edit_anbar();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding:
                      const EdgeInsetsDirectional.symmetric(vertical: 10.0),
                  child: const Center(
                    child: Text(
                      "ثبت تغییرات",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future edit_anbar() async {
    List<Map<String, dynamic>> shopDataList =
        widget.data!.map((item) => (item as Commodity).toJson()).toList();

    var body = jsonEncode({"commodities": shopDataList});

    String infourl =
        Helper.url.toString() + 'anbar/edit_anbar_admin/${widget.anbar_id}/';
    var response = await http.patch(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    if (response.statusCode == 200) {
      MyMessage.mySnackbarMessage(context, "درخواست شما با موفقیت ثبت شد", 1);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ManagerRequestFirstPage(),
        ),
      );
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
