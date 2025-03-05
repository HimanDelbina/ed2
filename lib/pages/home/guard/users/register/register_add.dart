import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;

class RegisterAddPage extends StatefulWidget {
  const RegisterAddPage({super.key});

  @override
  State<RegisterAddPage> createState() => _RegisterFirstpageState();
}

class _RegisterFirstpageState extends State<RegisterAddPage> {
  int? id_user = 0;
  int? id_unit = 0;
  int? company_select = 1;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
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
    ExportData(id: 1, name: "اداری", tag: "E"),
    ExportData(id: 2, name: "تولید", tag: "T"),
    ExportData(id: 3, name: "فنی", tag: "F"),
  ];
  String? workSelect = "";
  int? workIdSelect;
  TextEditingController workController = TextEditingController();
  List<ExportData> workData = [
    ExportData(id: 1, name: "پیمان کار", tag: "P"),
    ExportData(id: 2, name: "نصاب", tag: "N"),
    ExportData(id: 3, name: "خدماتی", tag: "K"),
    ExportData(id: 3, name: "غیره", tag: "G"),
  ];
  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text("انتخاب واحد : "),
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
                              orElse: () =>
                                  ExportData(id: 0, name: "", tag: ""));
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
                              orElse: () =>
                                  ExportData(id: 0, name: "", tag: ""));

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
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text("نوع کار : "),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(),
                      ),
                      child: TypeAheadField<String>(
                        itemBuilder: (context, String suggestion) {
                          // نمایش پیشنهادات
                          final selectedData = workData.firstWhere(
                              (data) => data.name == suggestion,
                              orElse: () =>
                                  ExportData(id: 0, name: "", tag: ""));
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        controller: workController,
                        onSelected: (String suggestion) {
                          workController.text = suggestion;

                          // پیدا کردن آیتم انتخاب شده
                          final selectedData = workData.firstWhere(
                              (data) => data.name == suggestion,
                              orElse: () =>
                                  ExportData(id: 0, name: "", tag: ""));

                          setState(() {
                            workIdSelect = selectedData.id;
                            workSelect = selectedData.tag;
                          });

                          print("ID: $workIdSelect");
                          print("Tag: $workSelect");
                        },
                        suggestionsCallback: (String pattern) async {
                          return workData
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
              my_form(controllerName, name, "نام مراجعه کننده", false,
                  IconlyBold.profile, TextInputType.text, 1),
              my_form(controllerPhone, phone, "شماره موبایل", false,
                  IconlyBold.call, TextInputType.number, 1),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    car_all_select = controllerFour.text +
                        "," +
                        controllerThree.text +
                        "," +
                        controllerSecond.text +
                        "," +
                        controllerFirst.text;
                  });
                  create_client();
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
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white),
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

  Jalali nowDate = Jalali.now();
  DateTime nowTime = DateTime.now();
  Future create_client() async {
    // تبدیل تاریخ شمسی به رشته قابل ارسال
    String formattedDate =
        "${nowDate.year}-${nowDate.month.toString().padLeft(2, '0')}-${nowDate.day.toString().padLeft(2, '0')}";

    // تبدیل ساعت به رشته قابل ارسال
    String formattedTime =
        "${nowTime.hour.toString().padLeft(2, '0')}:${nowTime.minute.toString().padLeft(2, '0')}:${nowTime.second.toString().padLeft(2, '0')}";

    // ترکیب تاریخ و ساعت
    String dateTimeString = "$formattedDate $formattedTime";
    var body = jsonEncode({
      "user": id_user,
      "type_work": workSelect,
      "unit": exportSelect,
      "car_plate": car_all_select,
      "phone_number": controllerPhone.text,
      "name": controllerName.text,
      "admin_accept": false,
      "client_login": formattedDate,
      "client_exit": null
    });
    print(body);
    String infourl = Helper.url.toString() + 'guard/create_client';
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

  String? phone = "";
  TextEditingController controllerPhone = TextEditingController();
  String? name = "";
  TextEditingController controllerName = TextEditingController();
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
  String? car_all_select;
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
