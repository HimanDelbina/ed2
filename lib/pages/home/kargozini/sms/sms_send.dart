import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../models/message/sms_save_model.dart';
import '../../../../models/users/users_model.dart';
import '../../../../static/helper_page.dart';

class SmsSend extends StatefulWidget {
  const SmsSend({super.key});

  @override
  State<SmsSend> createState() => _SmsSendState();
}

class _SmsSendState extends State<SmsSend> {
  int? id_user = 0;
  int? id_unit = 0;

  void get_user_data() async {
    final SharedPreferences prefsUser = await SharedPreferences.getInstance();
    setState(() {
      id_user = prefsUser.getInt("id") ?? 0;
      id_unit = prefsUser.getInt("unit_id") ?? 0;
    });
    get_all_user();
    get_sms_save();
  }

  @override
  void initState() {
    get_user_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double my_height = MediaQuery.of(context).size.height;
    double my_width = MediaQuery.of(context).size.width;
    return Padding(
      padding: PagePadding.page_padding,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Text("انتخاب کارمند : "),
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
                      for (var i = 0; i < data_user!.length; i++) {
                        if (data_user![i].firstName +
                                " " +
                                data_user![i].lastName ==
                            suggestion) {
                          setState(() {
                            user_id_select = data_user![i].id;
                            user_select = data_user![i].firstName;
                            phone_number = data_user![i].phoneNumber;
                          });
                        }
                      }
                    },
                    suggestionsCallback: (String pattern) async {
                      return user_items!
                          .where((x) => x.contains(pattern))
                          .toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          my_form(controllerDescription, description, "متن پیام", false,
              IconlyBold.paper, TextInputType.name),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("پیام های ذخیره شده"),
              ),
              Expanded(child: Divider(color: Colors.grey))
            ],
          ),
          Expanded(
            child: is_get_data_sms!
                ? ListView.builder(
                    itemCount: sms_data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            select_sms_id = index;
                            select_sms = sms_data![index].content;
                            controllerDescription.text =
                                sms_data![index].content;
                          });
                        },
                        child: AnimatedContainer(    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInBack,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: select_sms_id == index
                                    ? Colors.green.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.5)),
                            color: select_sms_id == index
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: const EdgeInsetsDirectional.symmetric(
                              vertical: 5.0),
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Icon(
                                    select_sms_id == index
                                        ? Icons.check
                                        : Icons.remove,
                                    color: select_sms_id == index
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 15.0),
                              ),
                              Expanded(
                                  child: Text(
                                sms_data![index].content,
                                style: TextStyle(
                                    fontWeight: select_sms_id == index
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Lottie.asset("assets/lottie/loading.json",
                        height: 40.0)),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              create_sms();
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
                  "ارسال پیام",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String? description = "";
  TextEditingController controllerDescription = TextEditingController();
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
        maxLines: 5,
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

  List<String>? user_items = [];
  List? data_user = [];
  String? user_select = "";
  int? user_id_select;
  TextEditingController unitController = TextEditingController();
  List? data = [];
  bool? is_get_data = false;
  double? sumData;
  Future get_all_user() async {
    String infourl = Helper.url.toString() + 'user/get_all_user';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = usersModelFromJson(x);
      setState(() {
        data = recive_data;
        data_user = data;
        is_get_data = true;
      });
      for (var i = 0; i < data_user!.length; i++) {
        setState(() {
          user_items!
              .add(data_user![i].firstName + " " + data_user![i].lastName);
        });
      }
      print(user_items);
    } else if (response.statusCode == 204) {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? phone_number;
  Future create_sms() async {
    var body = jsonEncode({
      "sender": id_user,
      "receiver": phone_number,
      "content": controllerDescription.text
    });
    String infourl = Helper.url.toString() + 'message/send_sms';
    try {
      var response = await http.post(Uri.parse(infourl), body: body, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      print(body);
      if (response.statusCode == 201) {
        setState(() {
          controllerDescription.clear();
        });
        MyMessage.mySnackbarMessage(context, "اس ام اس با موفقیت ارسال شد", 1);
      } else if (response.statusCode == 204) {
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      } else {
        print("خطای سرور: ${response.statusCode}");
        MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
      }
    } catch (e) {
      print("خطای شبکه: $e");
      MyMessage.mySnackbarMessage(context, "ارتباط با سرور برقرار نشد", 1);
    }
  }

  List? sms_data = [];
  bool? is_get_data_sms = false;
  Future get_sms_save() async {
    String infourl = Helper.url.toString() + 'message/get_all_save_sms';
    var response = await http.get(Uri.parse(infourl), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      var x = response.body;
      var recive_data = smsDefaultModelFromJson(x);
      setState(() {
        sms_data = recive_data;
        is_get_data_sms = true;
      });
    } else {
      MyMessage.mySnackbarMessage(context, "خطایی رخ داده", 1);
    }
  }

  String? select_sms;
  int? select_sms_id;
}
