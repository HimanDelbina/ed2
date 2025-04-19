import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:ed/models/kala_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconly/iconly.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnbarHomePage extends StatefulWidget {
  const AnbarHomePage({super.key});

  @override
  State<AnbarHomePage> createState() => _AnbarHomePageState();
}

class _AnbarHomePageState extends State<AnbarHomePage> {
  Jalali? picked_to;
  String? formattedStartTime;
  String? start_time;

  @override
  void initState() {
    super.initState();
    get_user_data();
    get_kala();
    checkTime();
    picked_to = Jalali.now();
    start_time = picked_to!.toDateTime().toIso8601String();
    formattedStartTime = DateFormat.Hm().format(DateTime.parse(start_time!));
  }

  int? id_user = 0;
  int? id_unit = 0;
  String? group_name;
  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
      group_name = prefsUser.getString("group_name") ?? "";
    });
  }

  String? selected_manager = "MV";
  bool? is_manager = true;
  bool? is_salon_manager = false;
  Jalali? pickedDate = Jalali.now();
  String? date_select = "";

  List<Map> map_parts = [];

  void checkTime() {
    final now = DateTime.now();
    if (now.hour >= 14) {
      setState(() {
        is_manager = false;
        is_salon_manager = true;
      });
    }
  }

  bool? is_mahtab = true;
  bool? is_sadaf = false;
  String? anbar_select = "MA";

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              show_manager_filter(
                "انبار مهتاب",
                is_mahtab,
                () {
                  setState(() {
                    is_mahtab = true;
                    is_sadaf = false;
                    anbar_select = "MA";
                  });
                },
              ),
              show_manager_filter(
                "انبار صدف",
                is_sadaf,
                () {
                  setState(() {
                    is_mahtab = false;
                    is_sadaf = true;
                    anbar_select = "SA";
                  });
                },
              ),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: group_name == "کنترل کیفیت" ||
                    group_name == "اداری" ||
                    group_name == "نگهبانی"
                ? show_manager_filter(
                    "مدیر واحد",
                    is_manager,
                    () {
                      setState(() {
                        is_manager = true;
                        is_salon_manager = false;
                        selected_manager = "MV";
                      });
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      show_manager_filter(
                        "مدیر واحد",
                        is_manager,
                        () {
                          setState(() {
                            is_manager = true;
                            is_salon_manager = false;
                            selected_manager = "MV";
                          });
                        },
                      ),
                      show_manager_filter(
                        "مدیر سالن",
                        is_salon_manager,
                        () {
                          setState(() {
                            is_manager = false;
                            is_salon_manager = true;
                            selected_manager = "MS";
                          });
                        },
                      ),
                    ],
                  ),
          ),

          text_form("توضیحات", IconlyBold.paper, controlleranbardescription,
              anbar_description, false, 3, TextInputType.name),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              controller: kalaController,
              onSaved: (value) => kala = value,
              keyboardType: TextInputType.text,
              obscureText: false,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "نام کالا",
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(IconlyBold.paper),
                suffixIconColor: Colors.grey,
              ),
            ),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const Padding(
          //       padding: EdgeInsets.symmetric(vertical: 5.0),
          //       child: Text("انتخاب کالا : "),
          //     ),
          //     Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(5.0),
          //         border: Border.all(),
          //       ),
          //       child: TextFormField(
          //         controller: kalaController,
          //       ),
          //       // child: TypeAheadField<String>(
          //       //   itemBuilder: (context, String suggestion) {
          //       //     return ListTile(title: Text(suggestion));
          //       //   },
          //       //   controller: kalaController,
          //       //   onSelected: (String? suggestion) {
          //       //     kalaController.text = suggestion!;
          //       //     Text(suggestion);
          //       //     for (var i = 0; i < data_kala!.length; i++) {
          //       //       if (data_kala![i].name == suggestion) {
          //       //         setState(() {
          //       //           kala_id_select = data_kala![i].id;
          //       //           kala_select_name = data_kala![i].name;
          //       //           kala_select_code = data_kala![i].code;
          //       //           kala_select_unit = data_kala![i].unit;
          //       //         });
          //       //       }
          //       //     }
          //       //   },
          //       //   suggestionsCallback: (String pattern) async {
          //       //     return unit_items!
          //       //         .where((x) => x.contains(pattern))
          //       //         .toList();
          //       //   },
          //       // ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                text_form(count_lable!, Icons.numbers, controllercount, count,
                    false, 1, TextInputType.number),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          kala_select_name = kalaController.text;
                          kala_select_code = "";
                          kala_select_unit = "";
                          kala_id_select = 0;
                          kalaController.clear();
                          map_parts.add({
                            "id": kala_id_select,
                            "name": kala_select_name,
                            "code": kala_select_code,
                            "unit": kala_select_unit,
                            "count": controllercount.text,
                            "accept": false
                          });
                          controllercount.clear();
                        });
                        print(map_parts);
                      },
                      child: Container(
                        height: my_height * 0.06,
                        width: my_width * 0.12,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: const Center(
                            child: Icon(Icons.add,
                                color: Colors.white, size: 25.0)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: map_parts.isNotEmpty
                  ? ListView.builder(
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
                                Text(map_parts[index]['name']),
                                Row(
                                  children: [
                                    Text(map_parts[index]['count']),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Text(map_parts[index]['unit']),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        map_parts.removeAt(index);
                                      });
                                    },
                                    child: const Icon(
                                      IconlyBold.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("کالایی انتخاب نشده"))),
          GestureDetector(
            onTap: () {
              create_anbar();
            },
            child: Container(
              height: my_height * 0.06,
              width: my_width,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5.0)),
              child: const Center(
                child: Text(
                  "تایید",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget show_manager_filter(
      String? title, bool? is_select, VoidCallback ontap) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: my_width * 0.4,
        height: my_height * 0.05,
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
                fontWeight: is_select ? FontWeight.bold : FontWeight.normal,
                fontSize: is_select ? 18.0 : 16.0),
          ),
        ),
      ),
    );
  }

  Future create_anbar() async {
    var body = jsonEncode({
      "user": id_user,
      "commodities": map_parts,
      "manager_select": selected_manager,
      "anbar_select": anbar_select,
      "clock_create": formattedStartTime.toString().toEnglishDigit(),
      "clock_date_anbar": "",
      "anbar_date": null,
      "accept_date": null,
      "clock_accept": "",
      "description": controlleranbardescription.text,
      "is_accept": false,
      "manager_accept": false,
      "salon_manager_accept": false,
      "anbar_accept": false
    });
    String infourl = Helper.url.toString() + 'anbar/create_anbar';
    try {
      var response = await http.post(
        Uri.parse(infourl), // آدرس API خود را جایگزین کن
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 201) {
        MyMessage.mySnackbarMessage(context, "درخواست با موفقیت ثبت شد", 1);
        // print("Success: ${response.body}");
      } else {
        // print("Error: ${response.body}"); // خطای سرور را چاپ کن
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } catch (e) {
      // print("Exception: $e");
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? count_lable = "عدد";
  String? anbar_description = "";
  TextEditingController controlleranbardescription = TextEditingController();
  String? count = "";
  TextEditingController controllercount = TextEditingController();
  Widget text_form(
    String lable,
    IconData icon,
    TextEditingController controller,
    String? save,
    bool is_show,
    int? maxline,
    TextInputType type,
  ) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: type == TextInputType.number ? my_width * 0.7 : my_width,
        child: TextFormField(
          // initialValue: 'رمز',
          keyboardType: type,
          controller: controller,
          onSaved: (value) => save = value,
          obscureText: is_show,
          cursorColor: Colors.blue,
          maxLines: maxline,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: lable,
            // errorText: erroetext,
            hintStyle: const TextStyle(color: Colors.grey),
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)),
            suffixIcon: Icon(icon),
            suffixIconColor: Colors.grey,
            iconColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  String? kala;

  String? kala_select_name = "";
  String? kala_select_code = "";
  String? kala_select_unit = "";
  int? kala_id_select;
  TextEditingController kalaController = TextEditingController();

  List<String>? unit_items = [];
  List? data_kala = [];
  bool is_data = false;
  int data_count = 0;
  List? data_date_now = [];
  Future get_kala() async {
    String infourl = Helper.url.toString() + 'anbar/get_all_commodity';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      data_date_now = commodityModelFromJson(x);
      setState(() {
        data_kala = data_date_now;
        is_data = true;
        data_count = data_kala!.length;
        unit_items!.clear();
      });
      for (var i = 0; i < data_kala!.length; i++) {
        setState(() {
          unit_items!.add(data_kala![i].name);
        });
      }
      // print(unit_items);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }
}
