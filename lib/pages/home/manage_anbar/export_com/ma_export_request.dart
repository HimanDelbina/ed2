import 'dart:convert';
import 'package:ed/components/count_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/static/helper_page.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ManagerAnbarExportRequest extends StatefulWidget {
  const ManagerAnbarExportRequest({super.key});

  @override
  State<ManagerAnbarExportRequest> createState() => _ImportCommodityPageState();
}

class _ImportCommodityPageState extends State<ManagerAnbarExportRequest> {
  bool? is_sadaf = false;
  bool? is_mahtab = true;
  bool? is_mavad = false;
  bool? is_kala = true;

  int? id_user = 0;
  int? id_unit = 0;
  int? company = 0;
  int? company_select = 1;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
      company = prefsUser.getInt("company") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  String? exportSelect = "";
  int? exportIdSelect;
  TextEditingController carController = TextEditingController();
  List<ExportData> exportData = [
    ExportData(id: 1, name: "امانی", tag: "A"),
    ExportData(id: 2, name: "برگشت امانی", tag: "B"),
    ExportData(id: 3, name: "تعمیر کاری", tag: "T"),
    ExportData(id: 4, name: "فروش", tag: "F"),
    ExportData(id: 5, name: "ضایعات", tag: "Z"),
  ];

  List<Map> map_parts = [];
  int kala_id = 0;
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           is_mahtab = true;
          //           is_sadaf = false;
          //           company_select = 1;
          //         });
          //       },
          //       child: Container(
          //         height: my_height * 0.06,
          //         width: my_width * 0.42,
          //         decoration: BoxDecoration(
          //           color:
          //               is_mahtab! ? Colors.blue : Colors.grey.withOpacity(0.1),
          //           borderRadius: BorderRadius.circular(5.0),
          //         ),
          //         child: Center(
          //           child: Text(
          //             "مهتاب",
          //             style: TextStyle(
          //                 fontWeight:
          //                     is_mahtab! ? FontWeight.bold : FontWeight.normal,
          //                 fontSize: 18.0,
          //                 color: is_mahtab! ? Colors.white : Colors.black),
          //           ),
          //         ),
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           is_mahtab = false;
          //           is_sadaf = true;
          //           company_select = 2;
          //         });
          //       },
          //       child: Container(
          //         height: my_height * 0.06,
          //         width: my_width * 0.42,
          //         decoration: BoxDecoration(
          //           color:
          //               is_sadaf! ? Colors.blue : Colors.grey.withOpacity(0.1),
          //           borderRadius: BorderRadius.circular(5.0),
          //         ),
          //         child: Center(
          //           child: Text(
          //             "صدف",
          //             style: TextStyle(
          //                 fontWeight:
          //                     is_sadaf! ? FontWeight.bold : FontWeight.normal,
          //                 fontSize: 18.0,
          //                 color: is_sadaf! ? Colors.white : Colors.black),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text("نوع خروجی : "),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(),
                  ),
                  child: TypeAheadField<String>(
                    itemBuilder: (context, String suggestion) {
                      // نمایش پیشنهادات
                      final selectedData = exportData.firstWhere(
                          (data) => data.name == suggestion,
                          orElse: () => ExportData(id: 0, name: "", tag: ""));
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    controller: carController,
                    onSelected: (String suggestion) {
                      carController.text = suggestion;

                      // پیدا کردن آیتم انتخاب شده
                      final selectedData = exportData.firstWhere(
                          (data) => data.name == suggestion,
                          orElse: () => ExportData(id: 0, name: "", tag: ""));

                      setState(() {
                        exportIdSelect = selectedData.id;
                        exportSelect = selectedData.tag;
                      });

                      print("ID: $exportIdSelect");
                      print("Tag: $exportSelect");
                    },
                    suggestionsCallback: (String pattern) async {
                      return exportData
                          .where((data) => data.name
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .map((data) => data.name)
                          .toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          my_form(controllerName, name, "نام کالا", false, Icons.description,
              TextInputType.text, 1),
          Row(
            children: [
              Expanded(
                child: my_form(controllerCount, count, "تعداد کالا", false,
                    Icons.height, TextInputType.number, 1),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    kala_id++;
                    map_parts.add({
                      "id": kala_id,
                      "name": controllerName.text,
                      "count": controllerCount.text,
                    });
                    controllerName.clear();
                    controllerCount.clear();
                  });
                  print(map_parts);
                },
                child: Container(
                  padding: const EdgeInsets.all(13.0),
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          my_form(controllerWeight, weight, "وزن بار", false, Icons.height,
              TextInputType.number, 1),
          exportSelect == "T"
              ? my_form(controllerRepair, repair, "نام تعمیرکار", false,
                  Icons.person, TextInputType.text, 1)
              : const SizedBox(),
          exportSelect == "F"
              ? my_form(controllerBuyer, buyer, "خریدار", false, Icons.person,
                  TextInputType.text, 1)
              : const SizedBox(),
          exportSelect != "F" && exportSelect != "T"
              ? my_form(controllerReciver, reciver, "دریافت کننده", false,
                  Icons.person, TextInputType.text, 1)
              : const SizedBox(),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("پلاک خودرو"),
              ),
              Expanded(child: Divider())
            ],
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: TextFormField(
                      controller: controllerFirst,
                      focusNode: _focusNode4,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      cursorColor: Colors.blue,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "چهارم",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )),
              Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: TextFormField(
                      controller: controllerSecond,
                      focusNode: _focusNode3,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      cursorColor: Colors.blue,
                      onChanged: (value) {
                        if (value.length == 3 && _focusNode4 != null) {
                          _focusNode3.unfocus();
                          FocusScope.of(context).requestFocus(_focusNode4);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "سوم",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: TextFormField(
                      controller: controllerThree,
                      focusNode: _focusNode2,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      cursorColor: Colors.blue,
                      onChanged: (value) {
                        if (value.length == 1 && _focusNode3 != null) {
                          _focusNode2.unfocus();
                          FocusScope.of(context).requestFocus(_focusNode3);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "دوم",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 5.0),
                    child: TextFormField(
                      controller: controllerFour,
                      focusNode: _focusNode1,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      cursorColor: Colors.blue,
                      onChanged: (value) {
                        if (value.length == 2 && _focusNode2 != null) {
                          _focusNode1.unfocus();
                          FocusScope.of(context).requestFocus(_focusNode2);
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "اول",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )),
            ],
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text("کالاها"),
              ),
              Expanded(child: Divider())
            ],
          ),
          Expanded(
              child: ListView.builder(
            itemCount: map_parts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("نام : ${map_parts[index]['name']}"),
                      Text(
                          "تعداد : ${map_parts[index]['count'].toString().toPersianDigit()}"),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              map_parts.removeAt(index);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Icon(IconlyBold.delete,
                                color: Colors.red, size: 20.0),
                          ))
                    ],
                  ),
                ),
              );
            },
          )),
          const Divider(),
          GestureDetector(
            onTap: () {
              setState(() {
                car_plate_select = controllerFour.text +
                    controllerThree.text +
                    controllerSecond.text +
                    controllerFirst.text;
              });
              create_exportcommodity();
            },
            child: Container(
              height: my_height * 0.06,
              width: my_width,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Center(
                child: Text(
                  "تایید",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future create_exportcommodity() async {
    var body = jsonEncode({
      "user": id_user,
      "company": company,
      "select": exportSelect,
      "name": controllerName.text,
      "count": controllerCount.text,
      "weight": controllerWeight.text,
      "buyer": controllerBuyer.text,
      "repair_man": controllerRepair.text,
      "recipient": controllerReciver.text,
      "car_plate": car_plate_select,
      "is_anbar": true,
      "is_guard": false,
      "is_admin": false,
      "is_back_guard": false,
      "is_print": false,
      "is_back": false,
      "guard_date": null,
      "admin_date": null,
      "back_date": null,
      "guard_back_date": null
    });
    print(body);
    String infourl = Helper.url.toString() + 'guard/create_export_commodity';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      MyMessage.mySnackbarMessage(context, "فرم با موفقیت ثبت شد", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? car_plate_select;
  String? weight = "";
  TextEditingController controllerWeight = TextEditingController();
  String? count = "";
  TextEditingController controllerCount = TextEditingController();
  String? name = "";
  TextEditingController controllerName = TextEditingController();
  String? repair = "";
  TextEditingController controllerRepair = TextEditingController();
  String? reciver = "";
  TextEditingController controllerReciver = TextEditingController();
  String? buyer = "";
  TextEditingController controllerBuyer = TextEditingController();
  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
    int? maxLine,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        keyboardType: type,
        obscureText: is_show,
        maxLines: maxLine,
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

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  String? plate_first = "";
  TextEditingController controllerFirst = TextEditingController();
  String? plate_second = "";
  TextEditingController controllerSecond = TextEditingController();
  String? plate_three = "";
  TextEditingController controllerThree = TextEditingController();
  String? plate_four = "";
  TextEditingController controllerFour = TextEditingController();
  Widget my_formPlate(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: TextFormField(
        controller: controller,
        onSaved: (value) => save = value,
        keyboardType: type,
        obscureText: is_show,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: lable,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class ExportData {
  final int id;
  final String name;
  final String tag;

  ExportData({required this.id, required this.name, required this.tag});
}
