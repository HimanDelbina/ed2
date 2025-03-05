import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../models/cartex/cartex_model.dart';
import '../../../../static/helper_page.dart';

class CartexSelecttablePage extends StatefulWidget {
  int? user_id;
  CartexSelecttablePage({super.key, this.user_id});

  @override
  State<CartexSelecttablePage> createState() => _CartexSelecttablePageState();
}

class _CartexSelecttablePageState extends State<CartexSelecttablePage> {
  @override
  void initState() {
    super.initState();
    get_cartex_by_user_id();
  }

  int? selectCartex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cartex_count == null
              ? const Text("")
              : Text(
                  "تعداد کالاهای در تحویل : ${cartex_count.toString().toPersianDigit()}"),
          const Divider(),
          Expanded(
            child: is_get_data! == false
                ? Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0))
                : data!.isEmpty
                    ? const Center(child: Text("داده ای وجود ندارد"))
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            border:
                                TableBorder.all(color: Colors.grey, width: 1),
                            columns: const [
                              DataColumn(
                                  label: Text("ردیف",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text("نام",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text("تاریخ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text("حذف",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: data!.asMap().entries.map(
                              (entry) {
                                int index = entry.key;
                                var item = entry.value;
                                String endDateString = item.createAt.toString();
                                String onlyDate = endDateString.split(' ')[0];

                                return DataRow(
                                  cells: [
                                    DataCell(Text((index + 1)
                                        .toString()
                                        .toPersianDigit())), // ردیف
                                    DataCell(Text(item.name.toString())), // نام
                                    DataCell(Text(
                                        onlyDate.toPersianDigit())), // تاریخ
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          setState(() {
                                            selectCartex = item.id;
                                          });
                                          delete_cartex_by_id();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  int? cartex_count;
  Future get_cartex_by_user_id() async {
    String infourl = Helper.url.toString() +
        'anbar/get_cartex_by_user_id/' +
        widget.user_id.toString();
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = cartexGetModelFromJson(x);
      setState(() {
        data = recive_data.data;
        cartex_count = recive_data.count;
        is_get_data = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  int? select_cartex;
  Future delete_cartex_by_id() async {
    String infourl = Helper.url.toString() +
        'anbar/delete_cartex_by_id/${selectCartex.toString()}';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      get_cartex_by_user_id();
      MyMessage.mySnackbarMessage(context, "کارتکس با موفقیت حذف شد", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
