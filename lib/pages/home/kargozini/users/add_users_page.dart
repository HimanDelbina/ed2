import 'dart:convert';

import 'package:ed/pages/home/kargozini/users/kargozini_users_firstpage.dart';
import 'package:ed/static/helper_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconly/iconly.dart';
import 'package:http/http.dart' as http;
import '../../../../models/access_model.dart';
import '../../../../models/unit/unit_model.dart';

class AddUsersPage extends StatefulWidget {
  const AddUsersPage({super.key});

  @override
  State<AddUsersPage> createState() => _AddUsersPageState();
}

class _AddUsersPageState extends State<AddUsersPage> {
  @override
  void initState() {
    super.initState();
    get_all_access();
    get_unit();
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
              Column(
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
                        return ListTile(title: Text(suggestion));
                      },
                      controller: unitController,
                      onSelected: (String? suggestion) {
                        unitController.text = suggestion!;
                        Text(suggestion);
                        for (var i = 0; i < data_unit!.length; i++) {
                          if (data_unit![i].name == suggestion) {
                            setState(() {
                              unit_id_select = data_unit![i].id;
                              unit_select = data_unit![i].name;
                            });
                            print(unit_id_select);
                            print(unit_select);
                          }
                        }
                      },
                      suggestionsCallback: (String pattern) async {
                        return unit_items!
                            .where((x) => x.contains(pattern))
                            .toList();
                      },
                    ),
                  ),
                ],
              ),
              my_form(controllerFirstName, firstName, "نام", false,
                  IconlyBold.profile, TextInputType.name),
              my_form(controllerLastName, lastName, "نام خانوادگی", false,
                  IconlyBold.profile, TextInputType.name),
              my_form(controllerphoneNumber, phoneNumber, "شماره موبایل", false,
                  IconlyBold.call, TextInputType.number),
              my_form(controllercompanyCode, companyCode, "کد پرسنلی", false,
                  Icons.numbers, TextInputType.number),
              my_form(controllerpassword, password, "رمز", false,
                  IconlyBold.password, TextInputType.number),
              my_form_bool(
                "آیا کارمند است ؟",
                is_personel!,
                (value) => setState(() => is_personel = value),
                () {
                  setState(() {
                    is_personel = !is_personel!;
                  });
                  if (is_personel!) {
                    setState(() {
                      is_admin = false;
                      is_sarparast = false;
                      is_manager = false;
                      is_salon_manager = false;
                      is_kargozini = false;
                      is_anbar = false;
                    });
                  }
                },
              ),
              my_form_bool(
                "آیا فعال است ؟",
                is_active!,
                (value) => setState(() => is_active = value),
                () {
                  setState(() {
                    is_active = !is_active!;
                  });
                },
              ),
              my_form_bool(
                "آیا دسترسی ادمین دارد ؟",
                is_admin!,
                (value) => setState(() => is_admin = value),
                () {
                  setState(() {
                    is_admin = !is_admin!;
                  });
                  if (is_admin!) {
                    setState(() {
                      is_personel = false;
                      is_sarparast = false;
                      is_manager = false;
                      is_salon_manager = false;
                      is_kargozini = false;
                      is_anbar = false;
                    });
                  }
                },
              ),
              my_form_bool(
                "آیا سرپرست است ؟",
                is_sarparast!,
                (value) => setState(() => is_sarparast = value),
                () {
                  setState(() {
                    is_sarparast = !is_sarparast!;
                  });
                  if (is_sarparast!) {
                    setState(() {
                      is_personel = false;
                      is_admin = false;
                      is_manager = false;
                      is_salon_manager = false;
                      is_kargozini = false;
                      is_anbar = false;
                    });
                  }
                },
              ),
              my_form_bool(
                "آیا مدیر واحد است ؟",
                is_manager!,
                (value) => setState(() => is_manager = value),
                () {
                  setState(() {
                    is_manager = !is_manager!;
                  });
                  if (is_manager!) {
                    setState(() {
                      is_personel = false;
                      is_admin = false;
                      is_sarparast = false;
                      is_salon_manager = false;
                      is_kargozini = false;
                      is_anbar = false;
                    });
                  }
                },
              ),
              my_form_bool(
                "آیا مدیر سالن است ؟",
                is_salon_manager!,
                (value) => setState(() => is_salon_manager = value),
                () {
                  setState(() {
                    is_salon_manager = !is_salon_manager!;
                  });
                  if (is_salon_manager!) {
                    setState(() {
                      is_personel = false;
                      is_admin = false;
                      is_sarparast = false;
                      is_manager = false;
                      is_kargozini = false;
                      is_anbar = false;
                    });
                  }
                },
              ),
              my_form_bool(
                "آیا دسترسی کارگزینی دارد ؟",
                is_kargozini!,
                (value) => setState(() => is_kargozini = value),
                () {
                  setState(() {
                    is_kargozini = !is_kargozini!;
                  });
                  if (is_kargozini!) {
                    setState(() {
                      is_personel = false;
                      is_admin = false;
                      is_sarparast = false;
                      is_manager = false;
                      is_salon_manager = false;
                      is_anbar = false;
                    });
                  }
                },
              ),
              my_form_bool(
                "آیا دسترسی انبار دارد ؟",
                is_anbar!,
                (value) => setState(() => is_anbar = value),
                () {
                  setState(() {
                    is_anbar = !is_anbar!;
                  });
                  if (is_anbar!) {
                    setState(() {
                      is_personel = false;
                      is_admin = false;
                      is_sarparast = false;
                      is_manager = false;
                      is_salon_manager = false;
                      is_kargozini = false;
                    });
                  }
                },
              ),
              const Row(
                children: [
                  Text("دسترسی ها"),
                  Expanded(child: Divider(indent: 10.0)),
                ],
              ),
              is_get_data!
                  ? ListView.builder(
                      itemCount: data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                access_bool![index] = !access_bool![index];
                              });
                              if (access_bool![index]) {
                                setState(() {
                                  access_select!.add(data![index].id);
                                  accessSelect.add({
                                    "id": data![index].id,
                                    "name": data![index].name,
                                    "tag": data![index].tag
                                  });
                                });
                              } else if (access_bool![index] == false) {
                                setState(() {
                                  access_select!.remove(data![index].id);
                                  accessSelect.removeWhere((element) =>
                                      element['id'] == data![index].id);
                                });
                              }
                              print(data![index].toString());
                              print(accessSelect);
                            },
                            title: Text(data![index].name),
                            trailing: Checkbox(
                              value: access_bool![index],
                              onChanged: (value) {
                                setState(() {
                                  access_bool![index] = !access_bool![index];
                                });
                                if (access_bool![index]) {
                                  setState(() {
                                    access_select!.add(data![index].id);
                                    accessSelect.add({
                                      "id": data![index].id,
                                      "name": data![index].name,
                                      "tag": data![index].tag
                                    });
                                  });
                                } else if (access_bool![index] == false) {
                                  setState(() {
                                    access_select!.remove(data![index].id);
                                    accessSelect.removeWhere((element) =>
                                        element['id'] == data![index].id);
                                  });
                                }
                                print(data![index].toString());
                                print(accessSelect);
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const Text("داده ای وجود ندارد"),
              const Divider(),
              GestureDetector(
                onTap: () {
                  create_user();
                },
                child: Container(
                  height: my_height * 0.06,
                  width: my_width,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: const Center(
                    child: Text(
                      "تایید",
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

  String? firstName = "";
  TextEditingController controllerFirstName = TextEditingController();
  String? lastName = "";
  TextEditingController controllerLastName = TextEditingController();
  String? phoneNumber = "";
  TextEditingController controllerphoneNumber = TextEditingController();
  String? companyCode = "";
  TextEditingController controllercompanyCode = TextEditingController();
  String? password = "";
  TextEditingController controllerpassword = TextEditingController();
  bool? is_admin = false;
  bool? is_personel = true;
  bool? is_active = true;
  bool? is_manager = false;
  bool? is_salon_manager = false;
  bool? is_kargozini = false;
  bool? is_sarparast = false;
  bool? is_anbar = false;

  Widget my_form(
    TextEditingController controller,
    String? save,
    String? lable,
    bool is_show,
    IconData icon,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
          suffixIcon: Icon(icon),
          suffixIconColor: Colors.grey,
        ),
      ),
    );
  }

  Widget my_form_bool(
    String? lable,
    bool data,
    Function(bool)? function,
    VoidCallback ontap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          onTap: ontap,
          title: Text(lable!),
          trailing: Switch(value: data, onChanged: function),
        ),
      ),
    );
  }

  List? data = [];
  List? data_show = [];
  List<bool>? access_bool = [];
  List<int>? access_select = [];
  List<Map<String, dynamic>> accessSelect = [];
  bool? is_get_data = false;
  Future get_all_access() async {
    String infourl = Helper.url.toString() + 'user/get_all_access';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      // var jsonResponse = json.decode(response.body);
      // MissionModel recive_data = MissionModel.fromJson(jsonResponse);
      var x = response.body;
      var recive_data = accessModelFromJson(x);
      setState(() {
        data = recive_data;
        data_show = recive_data;
        access_bool = List<bool>.generate(data!.length, (i) => false);
        is_get_data = true;
      });
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  Future create_user() async {
    var body = jsonEncode({
      "first_name": controllerFirstName.text,
      "last_name": controllerLastName.text,
      "phone_number": controllerphoneNumber.text,
      "company_code": controllercompanyCode.text,
      "password": controllerpassword.text,
      "unit": unit_id_select,
      "image": "",
      "is_admin": is_admin,
      "is_shift": is_sarparast,
      "is_user": is_personel,
      "is_active": is_active,
      "is_manager": is_manager,
      "is_kargozini": is_kargozini,
      "is_salon_manager": is_salon_manager,
      "is_unit_manager": is_manager,
      "is_anbar": is_anbar,
      "access": access_select
    });
    String infourl = Helper.url.toString() + 'user/create_user';
    var response = await http.post(Uri.parse(infourl), body: body, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    print(body);
    if (response.statusCode == 201) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const KargoziniUsersFirstPage(),
          ));

      MyMessage.mySnackbarMessage(context, "کاربر با موفقیت ثبت شد", 1);
    } else if (response.statusCode == 226) {
      MyMessage.mySnackbarMessage(context, "شماره موبایل تکراری است", 1);
    } else if (response.statusCode == 208) {
      MyMessage.mySnackbarMessage(context, "کد پرسنلی تکراری است", 1);
    } else {
      print('Error: ${response.body}');
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? unit_select = "";
  int? unit_id_select;
  TextEditingController unitController = TextEditingController();

  List<String>? unit_items = [];
  List? data_unit = [];
  bool is_data = false;
  int data_count = 0;
  List? data_date_now = [];
  Future get_unit() async {
    String infourl = Helper.url.toString() + 'user/get_all_unit';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      data_date_now = unitModelFromJson(x);
      setState(() {
        data_unit = data_date_now;
        is_data = true;
        data_count = data_unit!.length;
        unit_items!.clear();
      });
      for (var i = 0; i < data_unit!.length; i++) {
        setState(() {
          unit_items!.add(data_unit![i].name);
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
