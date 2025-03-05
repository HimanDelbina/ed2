import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ed/models/guard/car/car_model.dart';
import 'package:ed/static/helper_page.dart';
import 'package:http/http.dart' as http;

class ImportCommodityPage extends StatefulWidget {
  const ImportCommodityPage({super.key});

  @override
  State<ImportCommodityPage> createState() => _ImportCommodityPageState();
}

class _ImportCommodityPageState extends State<ImportCommodityPage> {
  bool? is_sadaf = false;
  bool? is_mahtab = true;
  bool? is_mavad = false;
  bool? is_kala = true;

  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    get_all_car();
  }

  @override
  void initState() {
    super.initState();
    get_user_data();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: PagePadding.page_padding,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        is_mahtab = true;
                        is_sadaf = false;
                        company_select = 1;
                      });
                    },
                    child: Container(
                      height: my_height * 0.06,
                      width: my_width * 0.42,
                      decoration: BoxDecoration(
                        color: is_mahtab!
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          "مهتاب",
                          style: TextStyle(
                              fontWeight: is_mahtab!
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 18.0,
                              color: is_mahtab! ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        is_mahtab = false;
                        is_sadaf = true;
                        company_select = 2;
                      });
                    },
                    child: Container(
                      height: my_height * 0.06,
                      width: my_width * 0.42,
                      decoration: BoxDecoration(
                        color: is_sadaf!
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          "صدف",
                          style: TextStyle(
                              fontWeight: is_sadaf!
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 18.0,
                              color: is_sadaf! ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        is_kala = true;
                        is_mavad = false;
                        select_kala = "M";
                      });
                    },
                    child: Container(
                      height: my_height * 0.06,
                      width: my_width * 0.42,
                      decoration: BoxDecoration(
                        color: is_kala!
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          "مواد اولیه",
                          style: TextStyle(
                              fontWeight: is_kala!
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 18.0,
                              color: is_kala! ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        is_kala = false;
                        is_mavad = true;
                        select_kala = "K";
                      });
                    },
                    child: Container(
                      height: my_height * 0.06,
                      width: my_width * 0.42,
                      decoration: BoxDecoration(
                        color: is_mavad!
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Text(
                          "کالا",
                          style: TextStyle(
                              fontWeight: is_mavad!
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 18.0,
                              color: is_mavad! ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text("نوع خودرو : "),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(),
                      ),
                      child: TypeAheadField<String>(
                        itemBuilder: (context, String suggestion) {
                          return ListTile(title: Text(suggestion));
                        },
                        controller: carController,
                        onSelected: (String? suggestion) {
                          carController.text = suggestion!;
                          Text(suggestion);
                          for (var i = 0; i < data_car!.length; i++) {
                            if (data_car![i].name == suggestion) {
                              setState(() {
                                car_id_select = data_car![i].id;
                                car_select = data_car![i].name;
                              });
                            }
                          }
                          print(car_id_select);
                        },
                        suggestionsCallback: (String pattern) async {
                          return car_items!
                              .where((x) => x.contains(pattern))
                              .toList();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              my_form(controllerName, name, "نام کالا", false,
                  Icons.description, TextInputType.text, 1),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text("پلاک خودرو"),
                  ),
                  Expanded(child: Divider()),
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
              is_kala!
                  ? my_form(controllerCount, count, "تعداد کالا", false,
                      Icons.height, TextInputType.number, 1)
                  : my_form(controllerWeight, weight, "وزن بار", false,
                      Icons.height, TextInputType.number, 1),
              my_form(controllerSeller, seller, "نام فروشنده", false,
                  Icons.person, TextInputType.text, 1),
              my_form(controllerDelivery, delivery, "تحویل دهنده", false,
                  Icons.person, TextInputType.text, 1),
              my_form(controllerPhoneNumber, phoneNumber, "شماره موبایل", false,
                  Icons.call, TextInputType.number, 1),
              my_form(controllerDescription, description, "توضیحات", false,
                  Icons.description, TextInputType.text, 3),
              const Divider(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    car_plate_select = controllerFour.text +
                        controllerThree.text +
                        controllerSecond.text +
                        controllerFirst.text;
                  });
                  create_importcommodity();
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
        ),
      ),
    );
  }

  List<String>? car_items = [];
  List? data_car = [];
  String? car_select = "";
  int? car_id_select;
  TextEditingController carController = TextEditingController();
  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_all_car() async {
    String infourl = Helper.url.toString() + 'guard/get_all_car';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = carModelFromJson(x);
      setState(() {
        data = recive_data;
        data_car = data;
        is_get_data = true;
      });
      for (var i = 0; i < data_car!.length; i++) {
        setState(() {
          car_items!.add(data_car![i].name);
        });
      }
      print(car_items);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  String? name = "";
  TextEditingController controllerName = TextEditingController();
  String? description = "";
  TextEditingController controllerDescription = TextEditingController();
  String? weight = "";
  TextEditingController controllerWeight = TextEditingController();
  String? count = "";
  TextEditingController controllerCount = TextEditingController();
  String? seller = "";
  TextEditingController controllerSeller = TextEditingController();
  String? delivery = "";
  TextEditingController controllerDelivery = TextEditingController();
  String? phoneNumber = "";
  TextEditingController controllerPhoneNumber = TextEditingController();

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

  String? plate_first = "";
  TextEditingController controllerFirst = TextEditingController();
  String? plate_second = "";
  TextEditingController controllerSecond = TextEditingController();
  String? plate_three = "";
  TextEditingController controllerThree = TextEditingController();
  String? plate_four = "";
  TextEditingController controllerFour = TextEditingController();
  Widget myFormPlate(
    TextEditingController controller,
    String label,
    bool isObscure,
    TextInputType inputType,
    FocusNode currentFocus,
    FocusNode? nextFocus,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: inputType,
        obscureText: isObscure,
        cursorColor: Colors.blue,
        onChanged: (value) {
          if (value.length == 2 && nextFocus != null) {
            currentFocus.unfocus();
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  // Widget my_formPlate(
  //   TextEditingController controller,
  //   String? save,
  //   String? lable,
  //   bool is_show,
  //   TextInputType type,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
  //     child: TextFormField(
  //       controller: controller,
  //       onSaved: (value) => save = value,
  //       keyboardType: type,
  //       obscureText: is_show,
  //       cursorColor: Colors.blue,
  //       decoration: InputDecoration(
  //         border: const OutlineInputBorder(),
  //         labelText: lable,
  //         hintStyle: const TextStyle(color: Colors.grey),
  //       ),
  //     ),
  //   );
  // }

  int? company_select = 1;
  String? select_kala = "M";
  String? car_plate_select;
  Future create_importcommodity() async {
    var body = jsonEncode({
      "user": id_user,
      "company": company_select,
      "car": car_id_select,
      "select": select_kala,
      "name": controllerName.text,
      "car_plate": car_plate_select,
      "weight_commodity": controllerWeight.text,
      "count_commodity": controllerCount.text,
      "commodity_description": controllerDescription.text,
      "seller_name": controllerSeller.text,
      "delivery_person": controllerDelivery.text,
      "car_phone": controllerPhoneNumber.text,
      "edit_description": "",
      "is_edit": false,
      "is_guard": true,
      "is_anbar": false,
      "is_admin": false,
      "is_print": false,
      "anbar_date": null,
      "admin_date": null
    });
    String infourl = Helper.url.toString() + 'guard/create_commodity';
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
}
